import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front/domain/setting/setting_domain_provider.dart';
import 'package:front/domain/setting/value_objects/setting.dart';
import 'package:front/features/setting/application/setting_notifier.dart';
import 'package:front/infrastructure/audio/app_music_controller_provider.dart';

final settingProvider = StateNotifierProvider<SettingNotifier, Setting>((ref) {
  final settingDomain = ref.watch(settingDomainProvider);

  return SettingNotifier(settingDomain);
});
