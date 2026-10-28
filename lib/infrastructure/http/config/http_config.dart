import 'package:flutter_dotenv/flutter_dotenv.dart';

class HttpConfig {
  final String origin;

  const HttpConfig({
    required this.origin,
  });

  factory HttpConfig.fromEnv() {
    final raw = (dotenv.env['GATEWAY_HTTP_ADDRESS'] ??
            dotenv.env['GATEWAY_HOST'] ??
            dotenv.env['GATEWAY_HTTP'] ??
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

    var scheme = uri.scheme;
    if (scheme.isEmpty) {
      scheme = 'https';
    }

    final port = uri.hasPort ? uri.port : null;
    final path = uri.path;
    final normalizedPath = (path.isEmpty || path == '/') ? '' : path;

    final isDefaultPort = (port == null) ||
        (port == 80 && (scheme == 'http' || scheme == 'ws')) ||
        (port == 443 && (scheme == 'https' || scheme == 'wss'));

    final portPart = (port == null || isDefaultPort) ? '' : ':$port';

    final origin = '$scheme://$host$portPart$normalizedPath';

    return HttpConfig(origin: origin);
  }
}
