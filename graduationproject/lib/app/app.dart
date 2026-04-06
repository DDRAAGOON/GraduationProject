import 'package:flutter/material.dart';

import 'router/app_router.dart';
import 'theme/app_theme.dart';
import '../shared/state/theme_controller.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance.themeMode,
      builder: (context, mode, _) => MaterialApp(
        title: 'Jobito',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: mode,
        initialRoute: AppRoutes.companyOnboardingSmartSearch,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
