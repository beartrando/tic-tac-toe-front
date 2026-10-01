import 'package:front/infrastructure/feedback/actions/feedback_action.dart';
import 'package:front/infrastructure/feedback/haptic/haptic_effect.dart';

class MoveAction extends FeedbackAction {
  const MoveAction({
    required super.audioPlayer,
    required super.audioConfig,
    required super.hapticFeedback,
    required super.visualEffectsHandler,
    required super.getSetting,
  });

  @override
  String? get soundEffect => audioConfig.move;

  @override
  HapticEffect? get haptic => HapticEffect.light;
}
