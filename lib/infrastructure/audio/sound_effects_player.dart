import 'package:audioplayers/audioplayers.dart';

class SoundEffectsPlayer {
  final AudioPlayer _player;

  SoundEffectsPlayer({AudioPlayer? player}) : _player = player ?? AudioPlayer();

  Future<void> playMove() => _play('audio/effects/move.wav');

  Future<void> playWin() => _play('audio/effects/win.wav');

  Future<void> playLose() => _play('audio/effects/lose.wav');

  Future<void> playRejectMove() => _play('audio/effects/reject-move.wav');

  Future<void> _play(String assetPath) async {
    try {
      await _player.stop();
      await _player.play(
        AssetSource(assetPath),
        mode: PlayerMode.lowLatency,
      );
    } catch (_) {
      // Audio playback errors should not interrupt application logic.
    }
  }

  Future<void> stop() async {
    await _player.stop();
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
