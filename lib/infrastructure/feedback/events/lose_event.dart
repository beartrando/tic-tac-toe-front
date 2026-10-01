import 'package:front/infrastructure/feedback/config/audio_config.dart';
import 'package:front/infrastructure/feedback/events/feedback_event.dart';
import 'package:front/infrastructure/feedback/haptic/haptic_effect.dart';
import 'package:front/infrastructure/feedback/visual/visual_effect_type.dart';

class LoseEvent extends FeedbackEvent {
  const LoseEvent()
    : super(
        soundEffect: AudioConfig.loseDefault,
        haptic: HapticEffect.medium,
        visual: VisualEffectType.lose,
      );
}
