import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front/domain/setting/setting_domain.dart';
import 'package:front/domain/setting/value_objects/effects_sound_enabled.dart';
import 'package:front/domain/setting/value_objects/setting.dart';
import 'package:front/domain/setting/value_objects/sound_enabled.dart';
import 'package:front/domain/setting/value_objects/vibration_enabled.dart';
import 'package:front/infrastructure/audio/music_controller.dart';

class SettingNotifier extends StateNotifier<Setting> {
  final SettingDomain _settingDomain;
  final MusicController _musicController;

  SettingNotifier(this._settingDomain, this._musicController)
    : super(_settingDomain.setting);

  Future<void> setSoundEnabled(bool value) async {
    _settingDomain.setSoundEnabled(SoundEnabled(value));
    state = _settingDomain.setting;
    if (value) {
      await _musicController.resume();
    } else {
      await _musicController.pause();
    }
  }

  Future<void> setEffectsSoundEnabled(bool value) async {
    _settingDomain.setEffectsSoundEnabled(EffectsSoundEnabled(value));
    state = _settingDomain.setting;
  }

  Future<void> setVibrationEnabled(bool value) async {
    _settingDomain.setVibrationEnabled(VibrationEnabled(value));
    state = _settingDomain.setting;
  }
}
