import 'package:front/infrastructure/feedback/actions/feedback_action.dart';
import 'package:front/infrastructure/feedback/haptic/haptic_effect.dart';
import 'package:front/infrastructure/feedback/visual/visual_effect_type.dart';

class LoseAction extends FeedbackAction {
  const LoseAction({
    required super.audioPlayer,
    required super.audioConfig,
    required super.hapticFeedback,
    required super.visualEffectsHandler,
    required super.getSetting,
  });

  @override
  String? get soundEffect => audioConfig.lose;

  @override
  HapticEffect? get haptic => HapticEffect.medium;

  @override
  VisualEffectType? get visual => VisualEffectType.lose;
}
