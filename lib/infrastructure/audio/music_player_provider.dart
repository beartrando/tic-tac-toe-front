import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front/infrastructure/audio/audio_player.dart';

final musicPlayerProvider = Provider<AudioPlayer>((ref) {
  final player = AudioPlayer();
  ref.onDispose(() => player.dispose());
  return player;
});
