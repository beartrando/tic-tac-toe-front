import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:front/infrastructure/audio/app_music_controller.dart';

final musicControllerProvider = Provider<AppMusicController>((ref) {
  final player = AudioPlayer();

  ref.onDispose(player.dispose);

  return AppMusicController(
    player: player,
    asset: 'audio/background_music.mp3',
  );
});
