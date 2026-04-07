import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduationproject/screens/user/auth/cubit/auth_cubit.dart';
import 'package:graduationproject/screens/user/auth/sign_in_screen.dart';
import 'package:graduationproject/screens/user/home/services_Screen.dart';
import 'package:graduationproject/screens/user/home/technical_screen.dart';
import 'screens/user/onboarding/onboarding_screen.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'Job Finder App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/onboarding',
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/home': (context) => const TechnicalScreen(),
        '/signin': (context) => const SignInScreen(),
      },
    );
  }
}


