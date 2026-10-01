import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front/infrastructure/audio/audio_config_provider.dart';
import 'package:front/infrastructure/audio/music_player.dart';

final musicPlayerProvider = Provider<MusicPlayer>((ref) {
  final config = ref.watch(audioConfigProvider);
  final player = MusicPlayer(config: config);
  ref.onDispose(() => player.dispose());
  return player;
});
