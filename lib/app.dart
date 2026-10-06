import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front/infrastructure/localization/generated/l10n.dart';
import 'package:front/infrastructure/localization/locale_provider.dart';
import 'package:front/router.dart';
import 'package:front/theme.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeAsync = ref.watch(localeProvider);

    return localeAsync.when(
      data: (locale) => MaterialApp(
        onGenerateTitle: (context) => S.of(context).appTitle,
        theme: appTheme,
        locale: locale,
        supportedLocales: S.delegate.supportedLocales,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        initialRoute: '/',
        routes: appRouter,
      ),
      loading: () => const Directionality(
        textDirection: TextDirection.ltr,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) {
        debugPrint('Locale loading error: $err');
        return const Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: Text('Failed to load locale. Please try again later.'),
          ),
        );
      },
    );
  }
}
