import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front/infrastructure/feedback/visual/no_op_visual_effects_handler.dart';
import 'package:front/infrastructure/feedback/visual/visual_effects_handler.dart';

final visualEffectsHandlerProvider = Provider<VisualEffectsHandler>((ref) {
  return const NoOpVisualEffectsHandler();
});
