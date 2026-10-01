import 'package:front/infrastructure/audio/audio_player.dart';
import 'package:front/infrastructure/feedback/config/audio_config.dart';
import 'package:front/infrastructure/feedback/haptic/haptic_feedback_adapter.dart';
import 'package:front/infrastructure/feedback/visual/visual_effects_handler.dart';

abstract class FeedbackAction {
  final AudioPlayer soundEffectsPlayer;
  final AudioPlayer musicPlayer;
  final AudioConfig audioConfig;
  final HapticFeedbackAdapter hapticFeedback;
  final VisualEffectsHandler visualEffectsHandler;
  final Setting Function() getSetting;

  const FeedbackAction({
    required this.soundEffectsPlayer,
    required this.musicPlayer,
    required this.audioConfig,
    required this.hapticFeedback,
    required this.visualEffectsHandler,
    required this.getSetting,
  });

  String? get music => null;
  String? get soundEffect => null;
  HapticEffect? get haptic => null;
  VisualEffectType? get visual => null;

  Future<void> execute() async {
    final setting = getSetting();

    await Future.wait([
      if (music != null && setting.soundEnabled.value)
        musicPlayer.play(music!),

      if (soundEffect != null && setting.effectsSoundEnabled.value)
        soundEffectsPlayer.play(soundEffect!),

      if (haptic != null && setting.vibrationEnabled.value)
        hapticFeedback.execute(haptic!),

      if (visual != null && setting.effectsSoundEnabled.value)
        visualEffectsHandler.trigger(visual!),
    ]);
  }
}
