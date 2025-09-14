import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart'; // เพิ่ม Firebase Auth
import 'package:galleria_app/screens/signup_page.dart';
import 'package:galleria_app/screens/home_screen.dart';
import 'package:galleria_app/screens/intro_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late AnimationController _floatingController;
  late AnimationController _socialButtonsController;
  
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _socialButtonsAnimation;

  @override
  void initState() {
    super.initState();
    
    // Main animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    // Pulse animation for logo
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    // Floating animation for background elements
    _floatingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    // Social buttons animation controller
    _socialButtonsController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
    ));
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _floatingAnimation = Tween<double>(
      begin: -10,
      end: 10,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));

    _socialButtonsAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _socialButtonsController,
      curve: Curves.easeOutBack,
    ));
    
    _animationController.forward();
    _pulseController.repeat(reverse: true);
    _floatingController.repeat(reverse: true);
    
    // Delay social buttons animation
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        _socialButtonsController.forward();
      }
    });
  }

  // แก้ไขฟังก์ชัน _login ให้ใช้ Firebase Auth (ตามที่อาจารย์สอน)
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      // Haptic feedback
      HapticFeedback.lightImpact();
      
      setState(() {
        _isLoading = true;
      });
      
      try {
        // Firebase Auth Sign In (ตามที่อาจารย์สอน)
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        
        // Save login status
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('IS_LOGGED_IN', true);
        await prefs.setString('USER_EMAIL', _emailController.text);
        
        setState(() {
          _isLoading = false;
        });
        
        // Success haptic feedback
        HapticFeedback.mediumImpact();
        
        // แสดงข้อความสำเร็จ
        _showMyDialog('Login successfully.');
        
        // Navigate to intro screen หลังจาก login สำเร็จ
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => IntroScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.0, 0.1),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      )),
                      child: child,
                    ),
                  );
                },
              ),
              (route) => false,
            );
          }
        });
        
      } on FirebaseAuthException catch (e) {
        setState(() {
          _isLoading = false;
        });
        
        print('Failed with error code: ${e.code}');
        print(e.message);
        
        // แสดงข้อผิดพลาดตามที่อาจารย์สอน
        String errorMessage = '';
        if (e.code == 'invalid-email') {
          errorMessage = 'No user found for that email.';
        } else if (e.code == 'user-not-found') {
          errorMessage = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Wrong password provided for that user.';
        } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
          errorMessage = 'Wrong password provided for that user.';
        } else {
          errorMessage = 'Login failed. Please try again.';
        }
        
        _showMyDialog(errorMessage);
        
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        _showMyDialog('An error occurred. Please try again.');
        print(e);
      }
    }
  }

  // เพิ่มฟังก์ชันแสดง Dialog (ตามที่อาจารย์สอน)
  void _showMyDialog(String txtMsg) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.amberAccent,
          title: const Text('Galleria App'),
          content: Text(txtMsg),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // เปลี่ยนฟังก์ชันนี้ให้ไปหน้า SignUpPage แทน
  Future<void> _navigateToSignUp() async {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SignUpPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          );
        },
      ),
    );
  }

  Future<void> _socialLogin(String provider) async {
    HapticFeedback.lightImpact();
    setState(() {
      _isLoading = true;
    });
    
    // สำหรับตอนนี้ใช้การจำลองก่อน (Social Login ต้องการ setup เพิ่มเติม)
    await Future.delayed(const Duration(seconds: 2));
    
    // Save login status
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('IS_LOGGED_IN', true);
    await prefs.setString('USER_EMAIL', '$provider@example.com');
    await prefs.setString('LOGIN_METHOD', provider);
    
    setState(() {
      _isLoading = false;
    });
    
    // Success haptic feedback
    HapticFeedback.mediumImpact();
    
    _showMyDialog('$provider login successful!');
    
    // Navigate to intro screen
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => IntroScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.1),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  )),
                  child: child,
                ),
              );
            },
          ),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6366f1), // Modern indigo
              Color(0xFF8b5cf6), // Purple
              Color(0xFF06b6d4), // Cyan
              Color(0xFF3b82f6), // Blue
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated background elements
            ...List.generate(6, (index) => AnimatedBuilder(
              animation: _floatingAnimation,
              builder: (context, child) => Positioned(
                left: (index * 80.0) + _floatingAnimation.value,
                top: (index * 120.0) + _floatingAnimation.value * 0.5,
                child: Container(
                  width: 60 + (index * 10),
                  height: 60 + (index * 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            )),
            
            SafeArea(
              child: Column(
                children: [
                  // Top Navigation with enhanced styling
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new, 
                                           color: Colors.white, size: 20),
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: ScaleTransition(
                              scale: _scaleAnimation,
                              child: Column(
                                children: [
                                  SizedBox(height: size.height * 0.02),
                                  
                                  // Enhanced Logo Section
                                  AnimatedBuilder(
                                    animation: _pulseAnimation,
                                    builder: (context, child) => Transform.scale(
                                      scale: _pulseAnimation.value,
                                      child: Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Colors.white,
                                              Color(0xFFf0f0f0),
                                            ],
                                          ),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.white.withOpacity(0.3),
                                              blurRadius: 30,
                                              offset: const Offset(0, 15),
                                            ),
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1),
                                              blurRadius: 20,
                                              offset: const Offset(0, 10),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.photo_camera_outlined,
                                          size: 55,
                                          color: Color(0xFF6366f1),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 40),
                                  // Enhanced Welcome Text
                                  ShaderMask(
                                    shaderCallback: (bounds) => const LinearGradient(
                                      colors: [Colors.white, Color(0xFFe5e7eb)],
                                    ).createShader(bounds),
                                    child: const Text(
                                      'Welcome Back!',
                                      style: TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Sign in to continue your creative journey',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white.withOpacity(0.85),
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                  const SizedBox(height: 40),
                                  
                                  // Enhanced Login Form Card
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(28),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.2),
                                        width: 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.08),
                                          blurRadius: 40,
                                          offset: const Offset(0, 20),
                                        ),
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.9),
                                          blurRadius: 10,
                                          offset: const Offset(0, -5),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(36.0),
                                      child: Form(
                                        key: _formKey,
                                        child: Column(
                                          children: [
                                            // Enhanced Email Field
                                            _buildInputField(
                                              controller: _emailController,
                                              label: 'Email Address',
                                              icon: Icons.mail_outline_rounded,
                                              keyboardType: TextInputType.emailAddress,
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'Please enter your email';
                                                }
                                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                                  return 'Please enter a valid email address';
                                                }
                                                return null;
                                              },
                                            ),
                                            const SizedBox(height: 28),
                                            // Enhanced Password Field
                                            _buildInputField(
                                              controller: _passwordController,
                                              label: 'Password',
                                              icon: Icons.lock_outline_rounded,
                                              isPassword: true,
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'Please enter your password';
                                                }
                                                if (value.length < 6) {
                                                  return 'Password must be at least 6 characters';
                                                }
                                                return null;
                                              },
                                            ),
                                            const SizedBox(height: 20),
                                            // Enhanced Forgot Password
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: TextButton(
                                                onPressed: () {
                                                  HapticFeedback.lightImpact();
                                                  // TODO: Implement forgot password
                                                },
                                                style: TextButton.styleFrom(
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 16, vertical: 8),
                                                ),
                                                child: const Text(
                                                  'Forgot Password?',
                                                  style: TextStyle(
                                                    color: Color(0xFF6366f1),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 36),
                                            // Enhanced Login Button
                                            Container(
                                              width: double.infinity,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  colors: [
                                                    Color(0xFF6366f1),
                                                    Color(0xFF8b5cf6),
                                                  ],
                                                ),
                                                borderRadius: BorderRadius.circular(18),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: const Color(0xFF6366f1).withOpacity(0.4),
                                                    blurRadius: 25,
                                                    offset: const Offset(0, 12),
                                                  ),
                                                ],
                                              ),
                                              child: ElevatedButton(
                                                onPressed: _isLoading ? null : _login,
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.transparent,
                                                  shadowColor: Colors.transparent,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(18),
                                                  ),
                                                ),
                                                child: _isLoading
                                                    ? const SizedBox(
                                                        width: 24,
                                                        height: 24,
                                                        child: CircularProgressIndicator(
                                                          color: Colors.white,
                                                          strokeWidth: 2.5,
                                                        ),
                                                      )
                                                    : const Text(
                                                        'Log In',
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.white,
                                                          letterSpacing: 0.5,
                                                        ),
                                                      ),
                                              ),
                                            ),
                                            
                                            // เปลี่ยนปุ่ม Quick Sign Up ให้ไปหน้า SignUpPage
                                            const SizedBox(height: 16),
                                            Container(
                                              width: double.infinity,
                                              height: 50,
                                              child: OutlinedButton(
                                                onPressed: _isLoading ? null : _navigateToSignUp,
                                                style: OutlinedButton.styleFrom(
                                                  side: const BorderSide(
                                                    color: Color(0xFF6366f1),
                                                    width: 2,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(18),
                                                  ),
                                                ),
                                                child: const Text(
                                                  'Sign Up',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF6366f1),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  
                                  // Social Login Buttons
                                  AnimatedBuilder(
                                    animation: _socialButtonsAnimation,
                                    builder: (context, child) => Transform.scale(
                                      scale: _socialButtonsAnimation.value,
                                      child: Opacity(
                                        opacity: _socialButtonsAnimation.value,
                                        child: Column(
                                          children: [
                                            // OR Divider
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    height: 1,
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Colors.transparent,
                                                          Colors.white.withOpacity(0.5),
                                                          Colors.transparent,
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                                  child: Text(
                                                    'OR',
                                                    style: TextStyle(
                                                      color: Colors.white.withOpacity(0.8),
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    height: 1,
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Colors.transparent,
                                                          Colors.white.withOpacity(0.5),
                                                          Colors.transparent,
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 32),
                                            _buildSocialLoginButtons(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  
                                  // เอาส่วน Sign Up link ด้านล่างออก
                                  SizedBox(height: size.height * 0.05),
                                ],
                              ),
                            ),
                          ),
                        ),
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

  Widget _buildSocialLoginButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSocialButton(
                'Google',
                Icons.g_mobiledata,
                const Color(0xFFDB4437),
                () => _socialLogin('Google'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSocialButton(
                'Facebook',
                Icons.facebook,
                const Color(0xFF4267B2),
                () => _socialLogin('Facebook'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: _buildSocialButton(
            'Continue with GitHub',
            Icons.code,
            const Color(0xFF333333),
            () => _socialLogin('GitHub'),
            isWide: true,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton(
    String text,
    IconData icon,
    Color color,
    VoidCallback onPressed, {
    bool isWide = false,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.9),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                if (isWide) const SizedBox(width: 12),
                if (isWide)
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                if (!isWide) const SizedBox(width: 8),
                if (!isWide)
                  Flexible(
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword && !_isPasswordVisible,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1E293B),
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF6366f1),
                  Color(0xFF8b5cf6),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible 
                        ? Icons.visibility_outlined 
                        : Icons.visibility_off_outlined,
                    color: const Color(0xFF64748B),
                    size: 22,
                  ),
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(
              color: Color(0xFF6366f1),
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(
              color: Color(0xFFEF4444),
              width: 2,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(
              color: Color(0xFFEF4444),
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 22,
          ),
        ),
        validator: validator,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    _floatingController.dispose();
    _socialButtonsController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}