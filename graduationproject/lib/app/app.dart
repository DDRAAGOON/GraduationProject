// Root [MaterialApp]: theme mode, locale, navigation, and localization delegates.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'router/app_router.dart';
import 'theme/app_theme.dart';
import '../core/network/api_interceptors.dart';
import '../screens/user/auth/cubit/auth_cubit.dart';
import '../shared/l10n/app_localizations.dart';
import '../shared/state/locale_controller.dart';
import '../shared/state/theme_controller.dart';

/// App-level [NavigatorState] key shared with [ApiInterceptors] so that a
/// global 401 Unauthorized response can redirect the user to the Login screen
/// without requiring a [BuildContext].
final navigatorKey = GlobalKey<NavigatorState>();

/// App-level [ScaffoldMessengerState] key for showing SnackBars globally
final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Register the key with the interceptor once, at the very root of the tree.
    ApiInterceptors.navigatorKey = navigatorKey;

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: ThemeController.instance.themeMode,
          builder: (context, mode, _) => ValueListenableBuilder<Locale>(
            valueListenable: LocaleController.instance.locale,
            builder: (context, locale, _) => BlocProvider<AuthCubit>(
              create: (_) => AuthCubit(),
              child: MaterialApp(
                title: 'Jobito',
                debugShowCheckedModeBanner: false,

                // ── Global navigator key for session-expiry redirects ───────
                navigatorKey: navigatorKey,

                // ── Global scaffold messenger for SnackBars ─────────────────
                scaffoldMessengerKey: scaffoldMessengerKey,

                // ── Theme Configuration ─────────────────────────────────────
                theme: AppTheme.light(),
                darkTheme: AppTheme.dark(),
                themeMode: mode,

                // ── Localization Configuration ──────────────────────────────
                locale: locale,
                supportedLocales: const [Locale('en'), Locale('ar')],
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],

                // ── Navigation Configuration ────────────────────────────────
                initialRoute: AppRoutes.splash,
                onGenerateRoute: AppRouter.onGenerateRoute,
              ),
            ),
          ),
        );
      },
    );
  }
}
