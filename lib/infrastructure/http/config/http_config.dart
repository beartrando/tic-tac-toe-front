import 'package:flutter_dotenv/flutter_dotenv.dart';

class HttpConfig {
  final String schema;
  final String host;
  final int port;

  const HttpConfig({
    required this.schema,
    required this.host,
    required this.port,
  });

  factory HttpConfig.fromEnv() {
    final host = dotenv.env['GATEWAY_HOST'] ?? 'localhost';
    final port = int.tryParse(dotenv.env['GATEWAY_PORT'] ?? '') ?? 9090;

    final schema = port == 443 ? 'https' : 'http';

    return HttpConfig(schema: schema, host: host, port: port);
  }
}
