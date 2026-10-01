import 'package:front/domain/setting/value_objects/setting.dart';
import 'package:front/infrastructure/audio/audio_player.dart';
import 'package:front/infrastructure/feedback/events/feedback_event.dart';
import 'package:front/infrastructure/feedback/haptic/haptic_feedback_adapter.dart';
import 'package:front/infrastructure/feedback/visual/visual_effects_handler.dart';

class EventFeedbackService {
  final AudioPlayer audioPlayer;
  final HapticFeedbackAdapter hapticFeedback;
  final VisualEffectsHandler visualEffectsHandler;
  final Setting Function() getSetting;

  const EventFeedbackService({
    required this.audioPlayer,
    required this.hapticFeedback,
    required this.visualEffectsHandler,
    required this.getSetting,
  });

  Future<void> execute(FeedbackEvent event) async {
    final setting = getSetting();

    await Future.wait([
      if (event.soundEffect != null && setting.effectsSoundEnabled.value)
        audioPlayer.play(event.soundEffect!),

      if (event.haptic != null && setting.vibrationEnabled.value)
        hapticFeedback.execute(event.haptic!),

      if (event.visual != null && setting.effectsSoundEnabled.value)
        Future(() => visualEffectsHandler.trigger(event.visual!)),
    ]);
  }
}
