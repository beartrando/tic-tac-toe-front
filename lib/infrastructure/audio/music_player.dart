import 'package:audioplayers/audioplayers.dart';
import 'package:front/infrastructure/audio/audio_config.dart';

class MusicPlayer {
  final AudioPlayer _player;
  final AudioConfig _config;

  MusicPlayer({
    AudioConfig config = const AudioConfig(),
    AudioPlayer? player,
  })  : _config = config,
        _player = player ?? AudioPlayer();

  Future<void> play([String? asset]) async {
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.play(AssetSource(asset ?? _config.backgroundMusic));
  }

  Future<void> stop() => _player.stop();

  Future<void> pause() => _player.pause();

  Future<void> dispose() => _player.dispose();
}
