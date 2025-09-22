import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'screens/intro_screen.dart';
import 'screens/login_page.dart';

bool showOnboarding = true;
bool isLoggedIn = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  showOnboarding = prefs.getBool('ON_BOARDING') ?? true;

  // ตรวจสอบว่า user ยัง login อยู่หรือไม่
  User? currentUser = FirebaseAuth.instance.currentUser;
  isLoggedIn = currentUser != null;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Galleria App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        fontFamily: 'Roboto',
      ),
      home: _getInitialScreen(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/intro': (context) => IntroScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }

  Widget _getInitialScreen() {
    // หาก user ยัง login อยู่ และผ่าน onboarding แล้ว
    if (isLoggedIn && !showOnboarding) {
      return const HomeScreen();
    }
    // หาก user ยัง login อยู่ แต่ยังไม่ผ่าน onboarding
    else if (isLoggedIn && showOnboarding) {
      return IntroScreen();
    }
    // หาก user ยังไม่ login
    else {
      return showOnboarding ? IntroScreen() : const LoginPage();
    }
  }
}