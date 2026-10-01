class AudioConfig {
  final String backgroundMusic;
  final String move;
  final String win;
  final String lose;
  final String rejectMove;

  const AudioConfig({
    this.backgroundMusic = 'audio/music/background.mp3',
    this.move = 'audio/effects/move.wav',
    this.win = 'audio/effects/win.wav',
    this.lose = 'audio/effects/lose.wav',
    this.rejectMove = 'audio/effects/reject-move.wav',
  });
}
