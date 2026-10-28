import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:front/infrastructure/websocket/config/websocket_config.dart';

class StreamingConfig implements WebsocketConfig {
  @override
  final String origin;

  const StreamingConfig({required this.origin});

  factory StreamingConfig.fromEnv() {
    final raw = dotenv.env['STREAMING_WS_ADDRESS']?.trim();

    if (raw == null || raw.isEmpty) {
      throw const FormatException('STREAMING_WS_ADDRESS is empty');
    }

    final hasScheme = raw.contains('://');
    final uri = Uri.parse(hasScheme ? raw : '//$raw');

    if (uri.host.isEmpty) {
      throw FormatException('Invalid STREAMING_WS_ADDRESS: $raw');
    }

    if (uri.hasQuery || uri.hasFragment || uri.userInfo.isNotEmpty) {
      throw FormatException(
        'STREAMING_WS_ADDRESS must contain only an address and optional path: $raw',
      );
    }

    final host = uri.host;
    final isLocal = host == 'localhost' ||
        host == '127.0.0.1' ||
        host == '::1';

    var scheme = uri.scheme;

    if (scheme.isEmpty) {
      scheme = isLocal ? 'ws' : 'wss';
    } else if (scheme == 'http') {
      scheme = 'ws';
    } else if (scheme == 'https') {
      scheme = 'wss';
    }

    if (scheme != 'ws' && scheme != 'wss') {
      throw FormatException('Unsupported WebSocket scheme: $scheme');
    }

    final port = uri.hasPort ? uri.port : null;

    if (port == 0) {
      throw FormatException('WebSocket port must not be 0: $raw');
    }

    final isDefaultPort =
        (scheme == 'ws' && port == 80) ||
            (scheme == 'wss' && port == 443);

    final portPart =
    port == null || isDefaultPort ? '' : ':$port';

    final path = uri.path.replaceFirst(RegExp(r'/+$'), '');

    return StreamingConfig(
      origin: '$scheme://$host$portPart$path',
    );
  }
}
