import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front/infrastructure/audio/audio_config.dart';

final audioConfigProvider = Provider<AudioConfig>((ref) {
  return const AudioConfig();
});
