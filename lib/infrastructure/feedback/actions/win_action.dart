import 'package:front/infrastructure/feedback/actions/feedback_action.dart';
import 'package:front/infrastructure/feedback/haptic/haptic_effect.dart';
import 'package:front/infrastructure/feedback/visual/visual_effect_type.dart';

class WinAction extends FeedbackAction {
  const WinAction({
    required super.audioPlayer,
    required super.audioConfig,
    required super.hapticFeedback,
    required super.visualEffectsHandler,
    required super.getSetting,
  });

  @override
  String? get soundEffect => audioConfig.win;

  @override
  HapticEffect? get haptic => HapticEffect.heavy;

  @override
  VisualEffectType? get visual => VisualEffectType.win;
}
