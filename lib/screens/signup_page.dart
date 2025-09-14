import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:galleria_app/screens/home_screen.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _acceptTerms = false;
  String _selectedCountryCode = '+66'; // Default to Thailand
  
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late AnimationController _floatingController;
  
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _scaleAnimation;

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
    
    _animationController.forward();
    _pulseController.repeat(reverse: true);
    _floatingController.repeat(reverse: true);
  }

  // Firebase Authentication Signup Method
  Future<void> _createUserWithEmailAndPassword() async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      
      // Update the user profile with display name
      await credential.user?.updateDisplayName(_nameController.text.trim());
      
      // Save additional user data to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('IS_LOGGED_IN', true);
      await prefs.setString('USER_EMAIL', _emailController.text.trim());
      await prefs.setString('USER_NAME', _nameController.text.trim());
      await prefs.setString('USER_PHONE', '$_selectedCountryCode${_phoneController.text}');
      
      return; // Success - no exception thrown
      
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'The password provided is too weak.';
          break;
        case 'email-already-in-use':
          errorMessage = 'An account already exists for that email.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email/password accounts are not enabled.';
          break;
        default:
          errorMessage = 'An error occurred: ${e.message}';
      }
      
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate() && _acceptTerms) {
      // Haptic feedback
      HapticFeedback.lightImpact();
      
      setState(() {
        _isLoading = true;
      });

      try {
        // Create user with Firebase Authentication
        await _createUserWithEmailAndPassword();

        setState(() {
          _isLoading = false;
        });

        // Success haptic feedback
        HapticFeedback.mediumImpact();

        // Show success dialog
        _showMyDialog('Account created successfully! Welcome aboard!');

        // Navigate to home screen after a short delay
        await Future.delayed(const Duration(seconds: 1));
        
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
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
        
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        
        // Show error dialog
        _showMyDialog(e.toString().replaceAll('Exception: ', ''));
      }
      
    } else if (!_acceptTerms) {
      // Show terms error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please accept the Terms of Service and Privacy Policy'),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  // Enhanced Alert Dialog (similar to the Firebase example)
  void _showMyDialog(String txtMsg) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text(
            'Account Registration',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
              fontSize: 20,
            ),
          ),
          content: Text(
            txtMsg,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF64748B),
              height: 1.5,
            ),
          ),
          actions: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366f1), Color(0xFF8b5cf6)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showTermsDialog() {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text(
            'Terms of Service',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
              fontSize: 20,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '1. By using this app, you agree to these terms.\n'
                  '2. You must provide accurate information when registering.\n'
                  '3. You are responsible for maintaining account security.\n'
                  '4. We reserve the right to suspend accounts that violate our policies.\n'
                  '5. The service is provided "as is" without warranties.\n'
                  '6. We may update these terms at any time.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366f1), Color(0xFF8b5cf6)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextButton(
                child: const Text(
                  'Close',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showPrivacyDialog() {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text(
            'Privacy Policy',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
              fontSize: 20,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '1. We collect information you provide when registering.\n'
                  '2. Your data is stored securely and not shared with third parties.\n'
                  '3. We may collect usage analytics to improve our service.\n'
                  '4. You can request deletion of your data at any time.\n'
                  '5. We use cookies to enhance user experience.\n'
                  '6. We comply with applicable data protection laws.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366f1), Color(0xFF8b5cf6)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextButton(
                child: const Text(
                  'Close',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        );
      },
    );
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
            ...List.generate(8, (index) => AnimatedBuilder(
              animation: _floatingAnimation,
              builder: (context, child) => Positioned(
                left: (index * 60.0) + _floatingAnimation.value,
                top: (index * 100.0) + _floatingAnimation.value * 0.7,
                child: Container(
                  width: 40 + (index * 8),
                  height: 40 + (index * 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.04),
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
                                  SizedBox(height: size.height * 0.01),
                                  
                                  // Enhanced Logo Section
                                  AnimatedBuilder(
                                    animation: _pulseAnimation,
                                    builder: (context, child) => Transform.scale(
                                      scale: _pulseAnimation.value,
                                      child: Container(
                                        width: 100,
                                        height: 100,
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
                                          Icons.person_add_alt_outlined,
                                          size: 45,
                                          color: Color(0xFF6366f1),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 35),

                                  // Enhanced Welcome Text
                                  ShaderMask(
                                    shaderCallback: (bounds) => const LinearGradient(
                                      colors: [Colors.white, Color(0xFFe5e7eb)],
                                    ).createShader(bounds),
                                    child: const Text(
                                      'Create Account',
                                      style: TextStyle(
                                        fontSize: 34,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Join us and start your creative adventure',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white.withOpacity(0.85),
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                  const SizedBox(height: 40),

                                  // Enhanced Signup Form Card
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
                                      padding: const EdgeInsets.all(32.0),
                                      child: Form(
                                        key: _formKey,
                                        child: Column(
                                          children: [
                                            // Enhanced Name Field
                                            _buildInputField(
                                              controller: _nameController,
                                              label: 'Full Name',
                                              icon: Icons.person_outline_rounded,
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'Please enter your full name';
                                                }
                                                if (value.trim().split(' ').length < 2) {
                                                  return 'Please enter your first and last name';
                                                }
                                                return null;
                                              },
                                            ),

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

                                            // Phone Number Field with Country Code
                                            _buildPhoneInputField(),

                                            // Enhanced Password Field
                                            _buildInputField(
                                              controller: _passwordController,
                                              label: 'Password',
                                              icon: Icons.lock_outline_rounded,
                                              isPassword: true,
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'Please enter a password';
                                                }
                                                if (value.length < 8) {
                                                  return 'Password must be at least 8 characters';
                                                }
                                                if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(value)) {
                                                  return 'Password must contain letters and numbers';
                                                }
                                                return null;
                                              },
                                            ),

                                            // Enhanced Confirm Password Field
                                            _buildInputField(
                                              controller: _confirmPasswordController,
                                              label: 'Confirm Password',
                                              icon: Icons.lock_outline_rounded,
                                              isPassword: true,
                                              isConfirmPassword: true,
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'Please confirm your password';
                                                }
                                                if (value != _passwordController.text) {
                                                  return 'Passwords do not match';
                                                }
                                                return null;
                                              },
                                            ),

                                            // Enhanced Terms and Conditions
                                            Container(
                                              margin: const EdgeInsets.only(bottom: 32, top: 8),
                                              padding: const EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF8FAFC),
                                                borderRadius: BorderRadius.circular(16),
                                                border: Border.all(
                                                  color: _acceptTerms 
                                                      ? const Color(0xFF6366f1).withOpacity(0.3)
                                                      : const Color(0xFFE2E8F0),
                                                  width: 1,
                                                ),
                                              ),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Transform.scale(
                                                    scale: 1.3,
                                                    child: Checkbox(
                                                      value: _acceptTerms,
                                                      onChanged: (value) {
                                                        HapticFeedback.selectionClick();
                                                        setState(() {
                                                          _acceptTerms = value ?? false;
                                                        });
                                                      },
                                                      activeColor: const Color(0xFF6366f1),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(6),
                                                      ),
                                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(top: 3.0),
                                                      child: RichText(
                                                        text: TextSpan(
                                                          style: const TextStyle(
                                                            fontSize: 14,
                                                            color: Color(0xFF64748B),
                                                            height: 1.5,
                                                          ),
                                                          children: [
                                                            const TextSpan(text: 'I agree to the '),
                                                            TextSpan(
                                                              text: 'Terms of Service',
                                                              style: const TextStyle(
                                                                color: Color(0xFF6366f1),
                                                                decoration: TextDecoration.underline,
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                              recognizer: TapGestureRecognizer()
                                                                ..onTap = _showTermsDialog,
                                                            ),
                                                            const TextSpan(text: ' and '),
                                                            TextSpan(
                                                              text: 'Privacy Policy',
                                                              style: const TextStyle(
                                                                color: Color(0xFF6366f1),
                                                                decoration: TextDecoration.underline,
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                              recognizer: TapGestureRecognizer()
                                                                ..onTap = _showPrivacyDialog,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // Enhanced Signup Button
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
                                                onPressed: _isLoading ? null : _signUp,
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
                                                        'Create Account',
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.white,
                                                          letterSpacing: 0.5,
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
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

  Widget _buildPhoneInputField() {
    final List<Map<String, String>> countryCodes = [
      {'code': '+66', 'name': 'Thailand', 'flag': '🇹🇭'},
      {'code': '+1', 'name': 'USA/Canada', 'flag': '🇺🇸'},
      {'code': '+49', 'name': 'Germany', 'flag': '🇩🇪'},
      {'code': '+44', 'name': 'UK', 'flag': '🇬🇧'},
      {'code': '+81', 'name': 'Japan', 'flag': '🇯🇵'},
      {'code': '+86', 'name': 'China', 'flag': '🇨🇳'},
      {'code': '+82', 'name': 'South Korea', 'flag': '🇰🇷'},
      {'code': '+65', 'name': 'Singapore', 'flag': '🇸🇬'},
      {'code': '+60', 'name': 'Malaysia', 'flag': '🇲🇾'},
      {'code': '+62', 'name': 'Indonesia', 'flag': '🇮🇩'},
      {'code': '+84', 'name': 'Vietnam', 'flag': '🇻🇳'},
      {'code': '+63', 'name': 'Philippines', 'flag': '🇵🇭'},
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
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
      child: Row(
        children: [
          // Country Code Dropdown
          Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedCountryCode,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    HapticFeedback.selectionClick();
                    setState(() {
                      _selectedCountryCode = newValue;
                    });
                  }
                },
                items: countryCodes.map<DropdownMenuItem<String>>((country) {
                  return DropdownMenuItem<String>(
                    value: country['code'],
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            country['flag']!,
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            country['code']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
                icon: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF6366f1),
                        Color(0xFF8b5cf6),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(16),
                elevation: 8,
              ),
            ),
          ),
          // Divider
          Container(
            height: 40,
            width: 1,
            color: const Color(0xFFE2E8F0),
          ),
          // Phone Number Input
          Expanded(
            child: TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, // Only allow digits
              ],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1E293B),
              ),
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                labelStyle: TextStyle(
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                hintText: '123456789',
                hintStyle: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 16,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 22,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                if (value.length < 9) {
                  return 'Please enter a valid phone number';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    bool isConfirmPassword = false,
    String? Function(String?)? validator,
  }) {
    bool isVisible = isPassword 
        ? (isConfirmPassword ? _isConfirmPasswordVisible : _isPasswordVisible)
        : false;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
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
        obscureText: isPassword && !isVisible,
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
                    isVisible 
                        ? Icons.visibility_outlined 
                        : Icons.visibility_off_outlined,
                    color: const Color(0xFF64748B),
                    size: 22,
                  ),
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    setState(() {
                      if (isConfirmPassword) {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      } else {
                        _isPasswordVisible = !_isPasswordVisible;
                      }
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
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}