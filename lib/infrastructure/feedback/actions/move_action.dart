import 'package:front/infrastructure/feedback/actions/feedback_action.dart';

class MoveAction extends FeedbackAction {
  const MoveAction({
    required super.soundEffectsPlayer,
    required super.musicPlayer,
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
