import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front/features/setting/application/setting_provider.dart';
import 'package:front/infrastructure/audio/app_music_controller.dart';
import 'package:front/infrastructure/audio/music_controller.dart';
import 'package:front/infrastructure/feedback/config/audio_config.dart';

final musicControllerProvider = Provider<MusicController>((ref) {
  final player = AudioPlayer();
  final settings = ref.watch(settingProvider);

  ref.onDispose(player.dispose);

  return AppMusicController(
    player: player,
    asset: AudioConfig.backgroundMusicDefault,
    enabled: settings.soundEnabled.value,
    loop: true,
  );
});
