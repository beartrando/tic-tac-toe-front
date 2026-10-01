import 'package:audioplayers/audioplayers.dart' as ap;

class AudioPlayer {
  final ap.AudioPlayer _player;

  AudioPlayer({ap.AudioPlayer? player}) : _player = player ?? ap.AudioPlayer();

  Future<void> play(String asset, {bool loop = false}) async {
    await _player.setReleaseMode(
      loop ? ap.ReleaseMode.loop : ap.ReleaseMode.stop,
    );
    await _player.play(ap.AssetSource(asset));
  }

  Future<void> stop() => _player.stop();

  Future<void> pause() => _player.pause();

  Future<void> resume() => _player.resume();

  Future<void> dispose() => _player.dispose();
}
