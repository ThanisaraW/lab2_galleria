import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:galleria_app/screens/home_page.dart';
import 'package:galleria_app/screens/profile_screen.dart';
import '../constant/app_constant.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _pageIndex = 0;

  final pages = [
    HomePage(),
    Center(child: Text('Search Page', style: headingTextStyle)),
    Center(child: Text('Notifications Page', style: headingTextStyle)),
    ArtistProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CurvedNavigationBar(
        index: _pageIndex,
        height: 60,
        backgroundColor: Colors.white,
        color: Colors.blue,
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