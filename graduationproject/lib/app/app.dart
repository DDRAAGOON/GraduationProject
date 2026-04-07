// Root [MaterialApp]: theme mode, locale, navigation, and localization delegates.

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'router/app_router.dart';
import 'theme/app_theme.dart';
import '../shared/l10n/app_localizations.dart';
import '../shared/state/locale_controller.dart';
import '../shared/state/theme_controller.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance.themeMode,
      builder: (context, mode, _) => ValueListenableBuilder<Locale>(
        valueListenable: LocaleController.instance.locale,
        builder: (context, locale, _) => MaterialApp(
          title: 'Jobito',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: mode,
          locale: locale,
          supportedLocales: const [Locale('en'), Locale('ar')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          initialRoute: AppRoutes.companyOnboardingSmartSearch,
          onGenerateRoute: AppRouter.onGenerateRoute,
        ),
      ),
    );
  }
}
