import 'package:front/domain/setting/setting_domain.dart';
import 'package:front/domain/setting/value_objects/setting.dart';
import 'package:front/domain/setting/value_objects/sound_enabled.dart';
import 'package:front/domain/setting/value_objects/effects_sound_enabled.dart';
import 'package:front/domain/setting/value_objects/vibration_enabled.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SettingDomain', () {
    late SettingDomain settingDomain;

    setUp(() {
      settingDomain = SettingDomain(const Setting.defaultValue());
    });

    test('returns current setting', () {
      final setting = settingDomain.setting;

      expect(setting.soundEnabled.value, true);
      expect(setting.effectsSoundEnabled.value, true);
      expect(setting.vibrationEnabled.value, true);
    });

    test('setSoundEnabled updates sound setting', () {
      settingDomain.setSoundEnabled(const SoundEnabled(false));

      expect(settingDomain.setting.soundEnabled.value, false);
      expect(settingDomain.setting.effectsSoundEnabled.value, true);
      expect(settingDomain.setting.vibrationEnabled.value, true);
    });

    test('setEffectsSoundEnabled updates effects sound setting', () {
      settingDomain.setEffectsSoundEnabled(const EffectsSoundEnabled(false));

      expect(settingDomain.setting.effectsSoundEnabled.value, false);
      expect(settingDomain.setting.soundEnabled.value, true);
      expect(settingDomain.setting.vibrationEnabled.value, true);
    });

    test('setVibrationEnabled updates vibration setting', () {
      settingDomain.setVibrationEnabled(const VibrationEnabled(false));

      expect(settingDomain.setting.vibrationEnabled.value, false);
      expect(settingDomain.setting.soundEnabled.value, true);
      expect(settingDomain.setting.effectsSoundEnabled.value, true);
    });

    test('multiple updates work independently', () {
      settingDomain.setSoundEnabled(const SoundEnabled(false));
      settingDomain.setEffectsSoundEnabled(const EffectsSoundEnabled(false));
      settingDomain.setVibrationEnabled(const VibrationEnabled(false));

      expect(settingDomain.setting.soundEnabled.value, false);
      expect(settingDomain.setting.effectsSoundEnabled.value, false);
      expect(settingDomain.setting.vibrationEnabled.value, false);
    });
  });

  group('Setting', () {
    test('defaultValue creates setting with all true', () {
      final setting = const Setting.defaultValue();

      expect(setting.soundEnabled.value, true);
      expect(setting.effectsSoundEnabled.value, true);
      expect(setting.vibrationEnabled.value, true);
    });

    test('copyWith updates only specified fields', () {
      const original = Setting.defaultValue();
      final updated = original.copyWith(
        soundEnabled: const SoundEnabled(false),
      );

      expect(updated.soundEnabled.value, false);
      expect(updated.effectsSoundEnabled.value, true);
      expect(updated.vibrationEnabled.value, true);
      // Original unchanged
      expect(original.soundEnabled.value, true);
    });

    test('copyWith can update multiple fields', () {
      const original = Setting.defaultValue();
      final updated = original.copyWith(
        soundEnabled: const SoundEnabled(false),
        vibrationEnabled: const VibrationEnabled(false),
      );

      expect(updated.soundEnabled.value, false);
      expect(updated.effectsSoundEnabled.value, true);
      expect(updated.vibrationEnabled.value, false);
    });
  });

  group('SoundEnabled', () {
    test('stores boolean value', () {
      const enabled = SoundEnabled(true);
      const disabled = SoundEnabled(false);

      expect(enabled.value, true);
      expect(disabled.value, false);
    });
  });

  group('EffectsSoundEnabled', () {
    test('stores boolean value', () {
      const enabled = EffectsSoundEnabled(true);
      const disabled = EffectsSoundEnabled(false);

      expect(enabled.value, true);
      expect(disabled.value, false);
    });
  });

  group('VibrationEnabled', () {
    test('stores boolean value', () {
      const enabled = VibrationEnabled(true);
      const disabled = VibrationEnabled(false);

      expect(enabled.value, true);
      expect(disabled.value, false);
    });
  });
}
