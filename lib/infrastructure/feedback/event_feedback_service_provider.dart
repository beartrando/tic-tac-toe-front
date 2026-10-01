import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front/features/setting/application/setting_provider.dart';
import 'package:front/infrastructure/audio/music_player_provider.dart';
import 'package:front/infrastructure/audio/sound_effects_player_provider.dart';
import 'package:front/infrastructure/feedback/event_feedback_service.dart';
import 'package:front/infrastructure/feedback/haptic/haptic_feedback_adapter_provider.dart';
import 'package:front/infrastructure/feedback/visual/visual_effects_handler_provider.dart';

final eventFeedbackServiceProvider = Provider<EventFeedbackService>((ref) {
  final soundEffectsPlayer = ref.watch(soundEffectsPlayerProvider);
  final musicPlayer = ref.watch(musicPlayerProvider);
  final hapticFeedback = ref.watch(hapticFeedbackAdapterProvider);
  final visualEffectsHandler = ref.watch(visualEffectsHandlerProvider);

  return EventFeedbackService(
    getSetting: () => ref.read(settingProvider),
    soundEffectsPlayer: soundEffectsPlayer,
    musicPlayer: musicPlayer,
    hapticFeedback: hapticFeedback,
    visualEffectsHandler: visualEffectsHandler,
  );
});
