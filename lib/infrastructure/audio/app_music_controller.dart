import 'package:audioplayers/audioplayers.dart';
import 'package:front/infrastructure/audio/music_controller.dart';

class AppMusicController implements MusicController {
  final AudioPlayer _player;
  final String _asset;
  final bool _enabled;
  final bool _loop;

  const AppMusicController({
    required AudioPlayer player,
    required String asset,
    required bool enabled,
    required bool loop,
  }) : _player = player,
       _asset = asset,
       _enabled = enabled,
       _loop = loop;

  Future<void> play() async {
    if (!_enabled) return;

    await _player.setReleaseMode(_loop ? ReleaseMode.loop : ReleaseMode.stop);

    await _player.play(AssetSource(_asset), volume: 1.0);
  }

  Future<void> stop() => _player.stop();

  Future<void> pause() => _player.pause();

  Future<void> resume() => _player.resume();
}
