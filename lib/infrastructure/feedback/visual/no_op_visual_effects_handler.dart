import 'visual_effect_type.dart';
import 'visual_effects_handler.dart';

class NoOpVisualEffectsHandler implements VisualEffectsHandler {
  const NoOpVisualEffectsHandler();

  @override
  void trigger(VisualEffectType effect) {}
}
