import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front/infrastructure/audio/audio_player.dart';

final soundEffectPlayerProvider = Provider<AudioPlayer>((ref) {
  final player = AudioPlayer();
  ref.onDispose(() => player.dispose());
  return player;
});
