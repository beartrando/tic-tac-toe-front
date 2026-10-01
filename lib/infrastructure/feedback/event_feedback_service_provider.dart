import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front/features/setting/application/setting_provider.dart';
import 'package:front/infrastructure/audio/music_player_provider.dart';
import 'package:front/infrastructure/feedback/event_feedback_service.dart';
import 'package:front/infrastructure/feedback/haptic/haptic_feedback_adapter_provider.dart';
import 'package:front/infrastructure/feedback/visual/visual_effects_handler_provider.dart';

final eventFeedbackServiceProvider = Provider<EventFeedbackService>((ref) {
  return EventFeedbackService(
    audioPlayer: ref.read(musicPlayerProvider),
    hapticFeedback: ref.read(hapticFeedbackAdapterProvider),
    visualEffectsHandler: ref.read(visualEffectsHandlerProvider),
    getSetting: () => ref.read(settingProvider),
  );
});
