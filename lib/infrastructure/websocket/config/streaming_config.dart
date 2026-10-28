import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:front/infrastructure/websocket/config/websocket_config.dart';

class StreamingConfig implements WebsocketConfig {
  @override
  final String origin;

  const StreamingConfig({required this.origin});

  factory StreamingConfig.fromEnv() {
    final raw = (dotenv.env['STREAMING_WS_ADDRESS'] ??
            dotenv.env['STREAMING_HOST'] ??
            'localhost')
        .trim();

    final isLegacy = !raw.contains('://');
    Uri uri;
    if (isLegacy) {
      if (raw.contains(':')) {
        final idx = raw.lastIndexOf(':');
        final hostPart = raw.substring(0, idx);
        final portPart = raw.substring(idx + 1);
        uri = Uri(
          scheme: '',
          host: hostPart.isEmpty ? 'localhost' : hostPart,
          port: int.tryParse(portPart),
        );
      } else {
        uri = Uri(
          scheme: '',
          host: raw.isEmpty ? 'localhost' : raw,
        );
      }
    } else {
      uri = Uri.tryParse(raw) ?? Uri(scheme: '', host: 'localhost');
    }

    final host = uri.host.isEmpty ? 'localhost' : uri.host;
    final isLocal = host == 'localhost' || host == '127.0.0.1';

    var scheme = uri.scheme;
    if (scheme.isEmpty) {
      scheme = isLocal ? 'ws' : 'wss';
    }

    final port = uri.hasPort ? uri.port : null;
    final path = uri.path;
    final normalizedPath = (path.isEmpty || path == '/') ? '' : path;

    final isDefaultPort = (port == null) ||
        (port == 80 && (scheme == 'ws' || scheme == 'http')) ||
        (port == 443 && (scheme == 'wss' || scheme == 'https'));

    final portPart = (port == null || isDefaultPort) ? '' : ':$port';

    final origin = '$scheme://$host$portPart$normalizedPath';

    return StreamingConfig(origin: origin);
  }
}
