import 'package:front/domain/setting/value_objects/setting.dart';
import 'package:front/infrastructure/audio/music_player.dart';
import 'package:front/infrastructure/audio/sound_effects_player.dart';
import 'package:front/infrastructure/feedback/haptic/haptic_feedback_adapter.dart';
import 'package:front/infrastructure/feedback/visual/no_op_visual_effects_handler.dart';
import 'package:front/infrastructure/feedback/visual/visual_effect_type.dart';
import 'package:front/infrastructure/feedback/visual/visual_effects_handler.dart';

class EventFeedbackService {
  final Setting Function() _getSetting;
  final SoundEffectsPlayer _soundEffectsPlayer;
  final MusicPlayer _musicPlayer;
  final HapticFeedbackAdapter _hapticFeedback;
  final VisualEffectsHandler _visualEffectsHandler;

  EventFeedbackService({
    required Setting Function() getSetting,
    required SoundEffectsPlayer soundEffectsPlayer,
    required MusicPlayer musicPlayer,
    HapticFeedbackAdapter hapticFeedback = const HapticFeedbackAdapter(),
    VisualEffectsHandler visualEffectsHandler = const NoOpVisualEffectsHandler(),
  })  : _getSetting = getSetting,
        _soundEffectsPlayer = soundEffectsPlayer,
        _musicPlayer = musicPlayer,
        _hapticFeedback = hapticFeedback,
        _visualEffectsHandler = visualEffectsHandler;

  Future<void> move() async {
    final setting = _getSetting();

    if (setting.vibrationEnabled.value) {
      await _hapticFeedback.lightImpact();
    }

    if (setting.effectsSoundEnabled.value) {
      _visualEffectsHandler.trigger(VisualEffectType.move);
      await _soundEffectsPlayer.playMove();
    }
  }

  Future<void> win() async {
    final setting = _getSetting();

    if (setting.vibrationEnabled.value) {
      await _hapticFeedback.heavyImpact();
    }

    if (setting.effectsSoundEnabled.value) {
      _visualEffectsHandler.trigger(VisualEffectType.win);
      await _soundEffectsPlayer.playWin();
    }
  }

  Future<void> lose() async {
    final setting = _getSetting();

    if (setting.vibrationEnabled.value) {
      await _hapticFeedback.mediumImpact();
    }

    if (setting.effectsSoundEnabled.value) {
      _visualEffectsHandler.trigger(VisualEffectType.lose);
      await _soundEffectsPlayer.playLose();
    }
  }

  Future<void> rejectMove() async {
    final setting = _getSetting();

    if (setting.vibrationEnabled.value) {
      await _hapticFeedback.selectionClick();
    }

    if (setting.effectsSoundEnabled.value) {
      _visualEffectsHandler.trigger(VisualEffectType.rejectMove);
      await _soundEffectsPlayer.playRejectMove();
    }
  }

  Future<void> playBackgroundMusic() async {
    final setting = _getSetting();

    if (!setting.soundEnabled.value) {
      return;
    }

    await _musicPlayer.play('audio/music/background.mp3');
  }

  Future<void> stopBackgroundMusic() async {
    await _musicPlayer.stop();
  }
}
