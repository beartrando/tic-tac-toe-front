import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:front/infrastructure/websocket/config/websocket_config.dart';

class StreamingConfig implements WebsocketConfig {
  @override
  final String origin;

  const StreamingConfig({required this.origin});

  factory StreamingConfig.fromEnv() {
    final host = dotenv.env['STREAMING_HOST'] ?? 'localhost';
    final port = dotenv.env['STREAMING_PORT'] ?? '';

    final finalPort = port.isEmpty ? '' : ':$port';
    final origin = 'ws://$host$finalPort';

    return StreamingConfig(origin: origin);
  }
}
