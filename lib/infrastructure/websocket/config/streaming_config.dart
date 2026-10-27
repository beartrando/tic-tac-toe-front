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
    final isLocal = host == 'localhost' || host == '127.0.0.1';
    final scheme = isLocal ? 'ws' : 'wss';
    final origin = '$scheme://$host$finalPort';

    return StreamingConfig(origin: origin);
  }
}
