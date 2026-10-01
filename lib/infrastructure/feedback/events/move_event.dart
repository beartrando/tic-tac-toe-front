import 'package:front/infrastructure/feedback/config/audio_config.dart';
import 'package:front/infrastructure/feedback/haptic/haptic_effect.dart';

class MoveEvent extends FeedbackEvent {
  const MoveEvent()
    : super(soundEffect: AudioConfig.move, haptic: HapticEffect.light);
}
