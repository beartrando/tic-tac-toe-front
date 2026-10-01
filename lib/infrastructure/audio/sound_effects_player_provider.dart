import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front/infrastructure/audio/sound_effects_player.dart';

final soundEffectsPlayerProvider = Provider<SoundEffectsPlayer>((ref) {
  final player = SoundEffectsPlayer();
  ref.onDispose(() => player.dispose());
  return player;
});
