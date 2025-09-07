import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:galleria_app/screens/home_screen.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            SizedBox(height: 20),
            
            // Page view with cards
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _buildCardPage(
                    title: 'Discover Art \nToys',
                    subtitle: 'Explore amazing creations from \ntalented artists and passionate collectors around the world. \nFind your next treasure.',
                    imagePath: 'assets/images/intropic/post1.png',
                  ),
                  _buildCardPage(
                    title: 'Track Your \nCollection',
                    subtitle: 'Organize and save details of your precious toys. Keep track \nof artists, purchase dates, \nand special memories',
                    imagePath: 'assets/images/intropic/post2.png',
                  ),
                  _buildCardPage(
                    title: 'Rate & Connect',
                    subtitle: 'Share your thoughts, leave reviews, \nand connect with fellow art toy enthusiasts in our vibrant community.',
                    imagePath: 'assets/images/intropic/post3.jpeg',
                  ),
                ],
              ),
            ),
            
            // Bottom navigation
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left side - Skip button
                  GestureDetector(
                    onTap: () => _onSkip(),
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  
                  // Center - page indicator
                  Row(
                    children: List.generate(3, (index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        width: index == _currentPage ? 20 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: index == _currentPage 
                              ? Colors.black87 
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  
                  // Right side - next/get started button
                  GestureDetector(
                    onTap: () {
                      if (_currentPage < 2) {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        _onDone();
                      }
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        _currentPage < 2 ? Icons.arrow_forward_ios : Icons.check,
                        color: Colors.black87,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardPage({
    required String title,
    required String subtitle,
    required String imagePath,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Stack(
            children: [
              // Background image
              Positioned.fill(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback if image not found
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF4ECDC4),
                            Color(0xFF44A08D),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.image,
                          size: 80,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Blur overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              
              // Main content
              Padding(
                padding: EdgeInsets.all(40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 60),
                    
                    // Spacer for content positioning
                    Expanded(
                      flex: 2,
                      child: SizedBox(),
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Title
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            offset: Offset(1, 1),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Subtitle
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                        height: 1.4,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: Offset(1, 1),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSkip() {
    // Navigate to the last page instead of finishing
    _pageController.animateToPage(
      2, // Go to page 3 (index 2)
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ON_BOARDING', false);
    // Navigate to home page after completing onboarding
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }
}