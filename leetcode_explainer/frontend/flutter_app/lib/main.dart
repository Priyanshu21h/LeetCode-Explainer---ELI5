import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/main_shell.dart';

void main() {
  runApp(const ProviderScope(child: LeetCodeExplainerApp()));
}

class LeetCodeExplainerApp extends StatelessWidget {
  const LeetCodeExplainerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LeetCode Explainer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0D1A),
        primaryColor: const Color(0xFF6C63FF),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6C63FF),
          secondary: Color(0xFF3ECFCF),
          surface: Color(0xFF161625),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/login': (_) => const LoginScreen(),
        '/home': (_) => const MainShell(),
      },
    );
  }
}
