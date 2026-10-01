import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/domain/setting/setting_domain.dart';
import 'package:front/domain/setting/setting_domain_provider.dart';
import 'package:front/domain/setting/value_objects/effects_sound_enabled.dart';
import 'package:front/domain/setting/value_objects/setting.dart';
import 'package:front/domain/setting/value_objects/sound_enabled.dart';
import 'package:front/domain/setting/value_objects/vibration_enabled.dart';
import 'package:front/infrastructure/audio/audio_player.dart';
import 'package:front/infrastructure/audio/music_player_provider.dart';
import 'package:front/infrastructure/audio/sound_effects_player.dart';
import 'package:front/infrastructure/audio/sound_effects_player_provider.dart';
import 'package:front/infrastructure/feedback/event_feedback_service.dart';
import 'package:front/infrastructure/feedback/event_feedback_service_provider.dart';
import 'package:front/infrastructure/feedback/haptic/haptic_feedback_adapter.dart';
import 'package:front/infrastructure/feedback/visual/visual_effect_type.dart';
import 'package:front/infrastructure/feedback/visual/visual_effects_handler.dart';

class FakeSoundEffectsPlayer implements SoundEffectsPlayer {
  int playMoveCount = 0;
  int playWinCount = 0;
  int playLoseCount = 0;
  int playRejectMoveCount = 0;
  int stopCount = 0;
  int disposeCount = 0;

  @override
  Future<void> playMove() async {
    playMoveCount++;
  }

  @override
  Future<void> playWin() async {
    playWinCount++;
  }

  @override
  Future<void> playLose() async {
    playLoseCount++;
  }

  @override
  Future<void> playRejectMove() async {
    playRejectMoveCount++;
  }

  @override
  Future<void> stop() async {
    stopCount++;
  }

  @override
  Future<void> dispose() async {
    disposeCount++;
  }
}

class FakeMusicPlayer implements MusicPlayer {
  int playCount = 0;
  int stopCount = 0;
  int pauseCount = 0;
  int disposeCount = 0;

  @override
  Future<void> play() async {
    playCount++;
  }

  @override
  Future<void> stop() async {
    stopCount++;
  }

  @override
  Future<void> pause() async {
    pauseCount++;
  }

  @override
  Future<void> dispose() async {
    disposeCount++;
  }
}

class FakeHapticFeedbackAdapter implements HapticFeedbackAdapter {
  int lightImpactCount = 0;
  int mediumImpactCount = 0;
  int heavyImpactCount = 0;
  int selectionClickCount = 0;

  @override
  Future<void> lightImpact() async {
    lightImpactCount++;
  }

  @override
  Future<void> mediumImpact() async {
    mediumImpactCount++;
  }

  @override
  Future<void> heavyImpact() async {
    heavyImpactCount++;
  }

  @override
  Future<void> selectionClick() async {
    selectionClickCount++;
  }
}

class FakeVisualEffectsHandler implements VisualEffectsHandler {
  final List<VisualEffectType> triggered = [];

  @override
  void trigger(VisualEffectType effect) {
    triggered.add(effect);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('EventFeedbackService', () {
    late FakeSoundEffectsPlayer sfxPlayer;
    late FakeMusicPlayer musicPlayer;
    late FakeHapticFeedbackAdapter hapticAdapter;
    late FakeVisualEffectsHandler visualHandler;

    Setting createSetting({
      bool sound = true,
      bool effects = true,
      bool vibration = true,
    }) {
      return Setting(
        soundEnabled: SoundEnabled(sound),
        effectsSoundEnabled: EffectsSoundEnabled(effects),
        vibrationEnabled: VibrationEnabled(vibration),
      );
    }

    setUp(() {
      sfxPlayer = FakeSoundEffectsPlayer();
      musicPlayer = FakeMusicPlayer();
      hapticAdapter = FakeHapticFeedbackAdapter();
      visualHandler = FakeVisualEffectsHandler();
    });

    test('move() triggers lightImpact, sfx, and visual effect when all enabled', () async {
      final service = EventFeedbackService(
        getSetting: () => createSetting(),
        soundEffectsPlayer: sfxPlayer,
        musicPlayer: musicPlayer,
        hapticFeedback: hapticAdapter,
        visualEffectsHandler: visualHandler,
      );

      await service.move();

      expect(hapticAdapter.lightImpactCount, 1);
      expect(sfxPlayer.playMoveCount, 1);
      expect(visualHandler.triggered, [VisualEffectType.move]);
    });

    test('move() ignores vibration when vibrationEnabled is false', () async {
      final service = EventFeedbackService(
        getSetting: () => createSetting(vibration: false),
        soundEffectsPlayer: sfxPlayer,
        musicPlayer: musicPlayer,
        hapticFeedback: hapticAdapter,
        visualEffectsHandler: visualHandler,
      );

      await service.move();

      expect(hapticAdapter.lightImpactCount, 0);
      expect(sfxPlayer.playMoveCount, 1);
      expect(visualHandler.triggered, [VisualEffectType.move]);
    });

    test('move() ignores sound and visual effects when effectsSoundEnabled is false', () async {
      final service = EventFeedbackService(
        getSetting: () => createSetting(effects: false),
        soundEffectsPlayer: sfxPlayer,
        musicPlayer: musicPlayer,
        hapticFeedback: hapticAdapter,
        visualEffectsHandler: visualHandler,
      );

      await service.move();

      expect(hapticAdapter.lightImpactCount, 1);
      expect(sfxPlayer.playMoveCount, 0);
      expect(visualHandler.triggered, isEmpty);
    });

    test('win() triggers heavyImpact, victory sfx, and win visual effect', () async {
      final service = EventFeedbackService(
        getSetting: () => createSetting(),
        soundEffectsPlayer: sfxPlayer,
        musicPlayer: musicPlayer,
        hapticFeedback: hapticAdapter,
        visualEffectsHandler: visualHandler,
      );

      await service.win();

      expect(hapticAdapter.heavyImpactCount, 1);
      expect(sfxPlayer.playWinCount, 1);
      expect(visualHandler.triggered, [VisualEffectType.win]);
    });

    test('lose() triggers mediumImpact, fail sfx, and lose visual effect', () async {
      final service = EventFeedbackService(
        getSetting: () => createSetting(),
        soundEffectsPlayer: sfxPlayer,
        musicPlayer: musicPlayer,
        hapticFeedback: hapticAdapter,
        visualEffectsHandler: visualHandler,
      );

      await service.lose();

      expect(hapticAdapter.mediumImpactCount, 1);
      expect(sfxPlayer.playLoseCount, 1);
      expect(visualHandler.triggered, [VisualEffectType.lose]);
    });

    test('rejectMove() triggers selectionClick, reject-move sfx, and rejectMove visual effect', () async {
      final service = EventFeedbackService(
        getSetting: () => createSetting(),
        soundEffectsPlayer: sfxPlayer,
        musicPlayer: musicPlayer,
        hapticFeedback: hapticAdapter,
        visualEffectsHandler: visualHandler,
      );

      await service.rejectMove();

      expect(hapticAdapter.selectionClickCount, 1);
      expect(sfxPlayer.playRejectMoveCount, 1);
      expect(visualHandler.triggered, [VisualEffectType.rejectMove]);
    });

    test('playBackgroundMusic() plays only when soundEnabled is true', () async {
      var currentSetting = createSetting(sound: false);
      final service = EventFeedbackService(
        getSetting: () => currentSetting,
        soundEffectsPlayer: sfxPlayer,
        musicPlayer: musicPlayer,
        hapticFeedback: hapticAdapter,
        visualEffectsHandler: visualHandler,
      );

      await service.playBackgroundMusic();
      expect(musicPlayer.playCount, 0);

      currentSetting = createSetting(sound: true);
      await service.playBackgroundMusic();
      expect(musicPlayer.playCount, 1);
    });

    test('stopBackgroundMusic() delegates to musicPlayer.stop()', () async {
      final service = EventFeedbackService(
        getSetting: () => createSetting(),
        soundEffectsPlayer: sfxPlayer,
        musicPlayer: musicPlayer,
        hapticFeedback: hapticAdapter,
        visualEffectsHandler: visualHandler,
      );

      await service.stopBackgroundMusic();
      expect(musicPlayer.stopCount, 1);
    });

    test('eventFeedbackServiceProvider can be resolved from ProviderContainer', () {
      final container = ProviderContainer(
        overrides: [
          settingDomainProvider.overrideWithValue(SettingDomain(createSetting())),
          soundEffectsPlayerProvider.overrideWithValue(sfxPlayer),
          musicPlayerProvider.overrideWithValue(musicPlayer),
        ],
      );

      final service = container.read(eventFeedbackServiceProvider);
      expect(service, isNotNull);
    });
  });
}
