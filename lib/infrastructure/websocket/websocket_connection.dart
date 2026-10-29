import 'dart:async';

import 'package:front/infrastructure/auth/value_objects/access_token.dart';
import 'package:front/infrastructure/logging/server_log.dart';
import 'package:front/infrastructure/websocket/config/websocket_config.dart';
import 'package:logger/logger.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

final logger = Logger();

abstract class WebsocketConnection<T> {
  final WebsocketConfig config;
  final AccessToken accessToken;

  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  Timer? _heartbeat;

  void Function()? onConnectionLost;

  bool _closing = false;
  bool _connected = false;
  Future<void>? _closeFuture;

  String get pathname => '';

  final int heartbeatTimer = 10;
  final StreamController<T> _controller = StreamController<T>.broadcast();

  WebSocketChannel get channel {
    final value = _channel;
    if (value == null) {
      throw StateError('WebSocket channel has not been initialized');
    }
    return value;
  }

  bool get isConnected => _connected;

  void messageHandler(List<int> message) {
    logger.d('WebSocket message received: ${message.runtimeType}');

    try {
      // Restore protocol-specific parsing here if required.
      // final resp = T.fromBuffer(message);
      // safeAdd(resp.data);
    } catch (error, stackTrace) {
      logger.e(
        'Failed to parse WebSocket message',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  void safeAdd(T data) {
    if (!_controller.isClosed) {
      _controller.add(data);
    }
  }

  Uri getWsUri() {
    final base = Uri.parse(config.origin);

    if (base.host.isEmpty ||
        (base.scheme != 'ws' &&
            base.scheme != 'wss' &&
            base.scheme != 'http' &&
            base.scheme != 'https')) {
      throw FormatException(
        'Invalid WebSocket origin: scheme=${base.scheme}, '
        'host=${base.host}',
      );
    }

    final scheme = switch (base.scheme) {
      'http' => 'ws',
      'https' => 'wss',
      _ => base.scheme,
    };

    final path = [
      base.path.replaceFirst(RegExp(r'/$'), ''),
      pathname.replaceFirst(RegExp(r'^/'), ''),
    ].where((part) => part.isNotEmpty).join('/');

    final uri = base.replace(
      scheme: scheme,
      path: '/$path',
      queryParameters: {...base.queryParameters, 'token': accessToken.value},
    );

    if (uri.host.isEmpty || uri.hasPort && uri.port == 0) {
      throw FormatException(
        'Invalid WebSocket URI: scheme=${uri.scheme}, '
        'host=${uri.host}, port=${uri.port}',
      );
    }

    // Never log the full URI: it contains the access token.
    logger.i(
      'Connecting WebSocket: scheme=${uri.scheme}, '
      'host=${uri.host}, port=${uri.hasPort ? uri.port : 'default'}, '
      'path=${uri.path}',
    );

    ServerLog.log('websocket connect', <String, Object?>{
      'scheme': uri.scheme,
      'host': uri.host,
      'port': uri.hasPort ? uri.port : null,
      'path': uri.path,
    });

    return uri;
  }

  Future<void> connect() async {
    if (_closing) {
      throw StateError('Cannot connect a closing WebSocket');
    }

    if (_channel != null) {
      throw StateError('WebSocket connection already initialized');
    }

    final uri = getWsUri();

    try {
      final newChannel = WebSocketChannel.connect(uri);
      _channel = newChannel;

      // A channel being created does not mean the handshake succeeded.
      await newChannel.ready;

      if (_closing) {
        await newChannel.sink.close(status.normalClosure);
        return;
      }

      _connected = true;
      logger.i('WebSocket handshake completed');

      ServerLog.log('websocket handshake', <String, Object?>{
        'success': true,
      });

      _subscription = newChannel.stream.listen(
        (message) {
          if (message is List<int>) {
            ServerLog.log('websocket message', <String, Object?>{
              'received': true,
              'bytes': message.length,
            });
            messageHandler(message);
          } else {
            logger.e(
              'Unexpected WebSocket message type: '
              '${message.runtimeType}',
            );
            ServerLog.log('websocket message', <String, Object?>{
              'received': false,
              'type': message.runtimeType.toString(),
            });
          }
        },
        onError: (Object error, StackTrace stackTrace) {
          _connected = false;
          logger.e(
            'WebSocket stream error',
            error: error,
            stackTrace: stackTrace,
          );
          ServerLog.log('websocket error', <String, Object?>{
            'error': error.toString(),
          });
        },
        onDone: () {
          _connected = false;
          logger.w(
            'WebSocket closed; code=${newChannel.closeCode}, '
            'reason=${newChannel.closeReason}',
          );

          ServerLog.log('websocket closed', <String, Object?>{
            'code': newChannel.closeCode,
            'reason': newChannel.closeReason,
          });

          if (!_closing) {
            onConnectionLost?.call();
          }
        },
        cancelOnError: false,
      );

      _heartbeat = Timer.periodic(
        Duration(seconds: heartbeatTimer),
        (_) => ping(),
      );
    } catch (error, stackTrace) {
      _connected = false;
      logger.e(
        'WebSocket connection failed',
        error: error,
        stackTrace: stackTrace,
      );
      ServerLog.log('websocket handshake', <String, Object?>{
        'success': false,
        'error': error.toString(),
      });
      rethrow;
    }
  }

  WebsocketConnection(this.config, this.accessToken) {
    connect();
  }

  Stream<T> get messages => _controller.stream;

  void send(T message) {
    if (!_connected || _closing) {
      throw StateError('Cannot send: WebSocket is not connected');
    }

    _channel!.sink.add(message);
  }

  void ping() {
    // Keep the existing protocol-specific ping implementation here.
  }

  Future<void> close() {
    return _closeFuture ??= _close();
  }

  Future<void> _close() async {
    _closing = true;
    _connected = false;

    _heartbeat?.cancel();
    _heartbeat = null;

    await _subscription?.cancel();
    _subscription = null;

    final currentChannel = _channel;
    _channel = null;

    if (currentChannel != null) {
      await currentChannel.sink.close(status.normalClosure);
    }

    if (!_controller.isClosed) {
      await _controller.close();
    }

    logger.i('WebSocket connection closed');
  }
}
