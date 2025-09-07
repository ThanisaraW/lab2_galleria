import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:galleria_app/screens/home_page.dart';
import 'package:galleria_app/screens/profile_screen.dart';
import 'package:galleria_app/screens/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constant/app_constant.dart';
import 'intro_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _pageIndex = 0;
  bool _isLoggedIn = false;

  final pages = [
    HomePage(),
    Center(child: Text('Search Page', style: headingTextStyle)),
    Center(child: Text('Notifications Page', style: headingTextStyle)),
    ArtistProfileScreen()
  ];

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // Function to check login status
  void _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.getBool('IS_LOGGED_IN') ?? false;
    });
  }

  // Logout function
  void _logout() async {
    // Show confirmation dialog for logout
    bool confirmLogout = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Sign Out', 
                style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    ) ?? false;

    if (confirmLogout) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('IS_LOGGED_IN', false);
      await prefs.remove('USER_EMAIL');
      await prefs.remove('USER_NAME');
      
      setState(() {
        _isLoggedIn = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully signed out'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back to Login page (skip Onboarding)
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    }
  }

  // Function to go to login page
  void _goToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    ).then((_) {
      // Check login status again when returning
      _checkLoginStatus();
    });
  }

  // Function to show Onboarding again
  void _showOnboarding() async {
    bool confirmShow = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Show Guide'),
          content: const Text('Would you like to view the app guide again?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('View Guide'),
            ),
          ],
        );
      },
    ) ?? false;

    if (confirmShow) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('ON_BOARDING', true);
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => IntroScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Galleria'),
        backgroundColor: const Color.fromARGB(255, 74, 80, 113),
        foregroundColor: Colors.white,
        actions: [
          // Login/Logout button
          IconButton(
            icon: Icon(_isLoggedIn ? Icons.logout : Icons.login),
            tooltip: _isLoggedIn ? 'Sign Out' : 'Sign In',
            onPressed: _isLoggedIn ? _logout : _goToLogin,
          ),
          // Show Onboarding button
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: 'View Guide',
            onPressed: _showOnboarding,
          ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _pageIndex,
        height: 60,
        backgroundColor: Colors.white,
        color: const Color.fromARGB(255, 74, 80, 113),
        items: const [
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.search, color: Colors.white),
          Icon(Icons.notifications, color: Colors.white),
          Icon(Icons.person, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
      ),
      body: pages[_pageIndex],
    );
  }
}