import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/home_screen.dart';
import 'screens/intro_screen.dart';
import 'screens/login_page.dart';

bool showOnboarding = true;
bool isLoggedIn = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  showOnboarding = prefs.getBool('ON_BOARDING') ?? true;
  isLoggedIn = prefs.getBool('IS_LOGGED_IN') ?? false;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Galleria App',
      home: _getInitialScreen(),
    );
  }

  Widget _getInitialScreen() {
    // ถ้า login แล้ว ให้เข้าหน้าหลักเลย (ข้าม Onboarding)
    if (isLoggedIn) {
      return const HomeScreen();
    }
    // ถ้ายังไม่เคยดู onboarding ให้แสดง IntroScreen ก่อน
    else if (showOnboarding) {
      return IntroScreen();
    }
    // ถ้าดู onboarding แล้ว แต่ยังไม่ได้ login ให้แสดงหน้า login
    else {
      return const LoginPage();
    }
  }
}