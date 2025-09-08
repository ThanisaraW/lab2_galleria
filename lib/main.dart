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
      routes: {
        '/login': (context) => const LoginPage(),
        '/intro': (context) => IntroScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }

  Widget _getInitialScreen() {
    
    if (isLoggedIn && !showOnboarding) {
      return const HomeScreen();
    }

    
    else {
      return const LoginPage();
    }
  }
}