import 'package:audioplayers/audioplayers.dart';
import 'package:front/infrastructure/audio/music_controller.dart';

class AppMusicController implements MusicController {
  final AudioPlayer _player;
  final String _asset;

  const AppMusicController({
    required AudioPlayer player,
    required String asset,
  })  : _player = player,
        _asset = asset;

  Future<void> play() => _player.play(AssetSource(_asset), volume: 1.0);

  Future<void> stop() => _player.stop();

  Future<void> pause() => _player.pause();

  Future<void> resume() => _player.resume();
}