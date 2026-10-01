import 'package:audioplayers/audioplayers.dart' as ap;

class AudioPlayer {
  final ap.AudioPlayer _player;

  AudioPlayer({ap.AudioPlayer? player}) : _player = player ?? ap.AudioPlayer();

  Future<void> play(String asset) async {
    await _player.setReleaseMode(ap.ReleaseMode.loop);
    await _player.play(ap.AssetSource(asset));
  }

  Future<void> stop() => _player.stop();

  Future<void> pause() => _player.pause();

  Future<void> dispose() => _player.dispose();
}
