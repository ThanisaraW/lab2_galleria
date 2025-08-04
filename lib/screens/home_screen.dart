import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../constant/app_constant.dart';

//type stw, select the first stateful widget template
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _pageIndex = 0;
  final _pages = [
    Center(child: Text('Home Page', style: headingTextStyle)),
    Center(child: Text('Search Page', style: headingTextStyle)),    
    Center(child: Text('Notifications Page', style: headingTextStyle)),
    Center(child: Text('Profile Page', style: headingTextStyle)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: _pages[_pageIndex],

  
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: primaryColor,
        animationDuration: const Duration(milliseconds: 300), //This will make it faster and more smooth

        items: [
          Icon(Icons.home, size: 30, color: secondaryColor),
          Icon(Icons.search, size: 30, color: secondaryColor),
          Icon(Icons.notifications, size: 30, color: secondaryColor),
          Icon(Icons.person, size: 30, color: secondaryColor),
        ],

        onTap: (index) {
          // Handle navigation logic here
          setState(() {
            _pageIndex = index;
          });
        },

        ),
    );
  }
}