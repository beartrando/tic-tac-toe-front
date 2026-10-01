import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front/infrastructure/audio/music_player.dart';

final musicPlayerProvider = Provider<MusicPlayer>((ref) {
  final player = MusicPlayer();
  ref.onDispose(() => player.dispose());
  return player;
});
