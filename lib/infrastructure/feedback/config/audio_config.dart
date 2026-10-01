class AudioConfig {
  static const String backgroundMusicDefault = 'audio/music/background.mp3';
  static const String moveDefault = 'audio/effects/move.wav';
  static const String winDefault = 'audio/effects/win.wav';
  static const String loseDefault = 'audio/effects/lose.wav';
  static const String rejectMoveDefault = 'audio/effects/reject-move.wav';

  final String backgroundMusic;
  final String move;
  final String win;
  final String lose;
  final String rejectMove;

  const AudioConfig({
    this.backgroundMusic = backgroundMusicDefault,
    this.move = moveDefault,
    this.win = winDefault,
    this.lose = loseDefault,
    this.rejectMove = rejectMoveDefault,
  });
}
