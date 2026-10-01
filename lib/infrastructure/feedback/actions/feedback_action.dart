import 'package:front/domain/setting/value_objects/setting.dart';
import 'package:front/infrastructure/audio/audio_player.dart';
import 'package:front/infrastructure/feedback/config/audio_config.dart';
import 'package:front/infrastructure/feedback/haptic/haptic_effect.dart';
import 'package:front/infrastructure/feedback/haptic/haptic_feedback_adapter.dart';
import 'package:front/infrastructure/feedback/visual/visual_effect_type.dart';
import 'package:front/infrastructure/feedback/visual/visual_effects_handler.dart';

abstract class FeedbackAction {
  final AudioPlayer audioPlayer;
  final AudioConfig audioConfig;
  final HapticFeedbackAdapter hapticFeedback;
  final VisualEffectsHandler visualEffectsHandler;
  final Setting Function() getSetting;

  const FeedbackAction({
    required this.audioPlayer,
    required this.audioConfig,
    required this.hapticFeedback,
    required this.visualEffectsHandler,
    required this.getSetting,
  });

  String? get soundEffect => null;

  HapticEffect? get haptic => null;

  VisualEffectType? get visual => null;

  Future<void> execute() async {
    final setting = getSetting();

    await Future.wait([
      if (soundEffect != null && setting.effectsSoundEnabled.value)
        audioPlayer.play(soundEffect!),

      if (haptic != null && setting.vibrationEnabled.value)
        hapticFeedback.execute(haptic!),

      if (visual != null && setting.effectsSoundEnabled.value)
        Future(() => visualEffectsHandler.trigger(visual!)),
    ]);
  }
}
