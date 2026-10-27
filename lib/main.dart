import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front/app.dart';
import 'package:front/domain/setting/setting_domain.dart';
import 'package:front/domain/setting/setting_domain_provider.dart';
import 'package:front/features/setting/infrastructure/setting_storage.dart';
import 'package:front/features/setting/infrastructure/setting_storage_provider.dart';
import 'package:front/features/update/infrastructure/app_update_service.dart';
import 'package:front/firebase_options.dart';
import 'package:front/infrastructure/auth/auth_service_provider.dart';
import 'package:front/infrastructure/error/error_reporter.dart';
import 'package:front/infrastructure/error/firebase_error_reporter.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final logger = Logger();
ErrorReporter? _errorReporter;

Future<void> main() async {
  FlutterError.onError = _handleFlutterError;
  PlatformDispatcher.instance.onError = (error, stack) {
    _handleAsyncError(error, stack);
    return true;
  };

  runZonedGuarded(() async {
    await _bootstrapFlutter();
    await _initializeFirebase();

    final container = await _initRiverpodContainer();

    runApp(
      UncontrolledProviderScope(container: container, child: const MyApp()),
    );

    await AppUpdateService(logger).checkAndUpdate();
  }, _handleAsyncError);
}

void _handleFlutterError(FlutterErrorDetails details) {
  FlutterError.dumpErrorToConsole(details);
  debugPrint('Flutter error: ${details.exceptionAsString()}\n${details.stack}');
  logger.e(
    'Flutter error',
    error: details.exception,
    stackTrace: details.stack,
  );
  _errorReporter?.fatal(details.exception, details.stack ?? StackTrace.current);
}

void _handleAsyncError(Object error, StackTrace stack) {
  debugPrint('Uncaught async error: $error\n$stack');
  logger.e('Async error', error: error, stackTrace: stack);
  _errorReporter?.fatal(error, stack);
}

Future<void> _bootstrapFlutter() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await dotenv.load(fileName: '.env');
}

Future<void> _initializeFirebase() async {
  // Crashlytics is not available on web, Windows, or Linux. Firebase Core is
  // still initialized on supported platforms so other Firebase services can
  // be added without changing application startup.
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.linux) {
    return;
  }

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    if (!kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.macOS)) {
      _errorReporter = FirebaseErrorReporter();
    }
  } catch (error, stack) {
    // Firebase must not prevent the application from starting when a platform
    // configuration is missing or a Firebase plugin is unavailable.
    logger.w('Firebase initialization failed', error: error, stackTrace: stack);
  }
}

Future<ProviderContainer> _initRiverpodContainer() async {
  final preferences = await SharedPreferences.getInstance();

  final settingStorage = SettingStorage(preferences);
  final setting = await settingStorage.load();
  final settingDomain = SettingDomain(setting);

  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(preferences),

      settingDomainProvider.overrideWithValue(settingDomain),
    ],
  );

  try {
    final authService = container.read(authServiceProvider);
    await authService.getOrCreateAccessToken();
  } catch (error, stack) {
    logger.w('Initial access token acquisition failed', error: error, stackTrace: stack);
  }

  // final authService = container.read(authServiceProvider);
  // await authService.getOrCreateJwt();

  return container;
}
