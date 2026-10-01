import 'package:front/infrastructure/feedback/config/audio_config.dart';
import 'package:front/infrastructure/feedback/events/feedback_event.dart';
import 'package:front/infrastructure/feedback/haptic/haptic_effect.dart';
import 'package:front/infrastructure/feedback/visual/visual_effect_type.dart';

class WinEvent extends FeedbackEvent {
  const WinEvent()
    : super(
        soundEffect: AudioConfig.winDefault,
        haptic: HapticEffect.heavy,
        visual: VisualEffectType.win,
      );
}
