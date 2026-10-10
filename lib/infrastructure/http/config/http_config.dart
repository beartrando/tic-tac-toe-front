
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HttpConfig {
  final String origin;

  const HttpConfig({
    required this.origin,
  });

  factory HttpConfig.fromEnv() {
    final host = dotenv.env['GATEWAY_HOST'] ?? 'localhost';
    final port = int.tryParse(dotenv.env['GATEWAY_PORT'] ?? '') ?? 443;

    final scheme = port == 443 ? 'https' : 'http';
    final finalPort = port == 443 ? '' : ':$port';

    final origin = '$scheme://$host$finalPort';

    return HttpConfig(origin: origin);
  }
}