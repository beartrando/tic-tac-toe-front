abstract class FeedbackEvent {
  final Music? music;
  final SoundEffect? soundEffect;
  final HapticEffect? haptic;
  final VisualEffect? visual;

  const FeedbackEvent({this.music, this.soundEffect, this.haptic, this.visual});
}

