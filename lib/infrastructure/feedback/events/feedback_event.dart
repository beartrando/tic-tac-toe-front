import 'package:front/infrastructure/feedback/haptic/haptic_effect.dart';
import 'package:front/infrastructure/feedback/visual/visual_effect_type.dart';

typedef Music = String;
typedef SoundEffect = String;

abstract class FeedbackEvent {
  final Music? music;
  final SoundEffect? soundEffect;
  final HapticEffect? haptic;
  final VisualEffectType? visual;

  const FeedbackEvent({this.music, this.soundEffect, this.haptic, this.visual});
}
