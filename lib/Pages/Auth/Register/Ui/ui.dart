import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  late AnimationController _animationController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
    );

    _animationController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _slideController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      HapticFeedback.lightImpact();

      await Future.delayed(Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      HapticFeedback.mediumImpact();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Registration successful!'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      if (!mounted) return;

      Navigator.pushReplacementNamed(context, '/home');
    } else {
      HapticFeedback.heavyImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.purple.shade50, Colors.white, Colors.blue.shade50],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(24.0),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Hero(
                              tag: 'logo',
                              child: SizedBox(
                                height: 100,
                                child: AnimatedBuilder(
                                  animation: _animationController,
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scale:
                                          1.0 +
                                          (_animationController.value * 0.1),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: RadialGradient(
                                            colors: [
                                              Colors.purple.shade400,
                                              Colors.blue.shade600,
                                            ],
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.purple.withOpacity(
                                                0.3,
                                              ),
                                              blurRadius: 20,
                                              offset: Offset(0, 10),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.person_add_outlined,
                                          size: 50,
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),

                            SizedBox(height: 30),

                            SlideTransition(
                              position: _slideAnimation,
                              child: Column(
                                children: [
                                  Text(
                                    'Create Account',
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),

                                  SizedBox(height: 8),

                                  Text(
                                    'Sign up to get started',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 40),

                            ..._buildAnimatedFormFields(),

                            SizedBox(height: 40),

                            _buildAnimatedButton(
                              text: 'Create Account',
                              onPressed: _isLoading ? null : _register,
                              isLoading: _isLoading,
                              backgroundColor: Colors.blue,
                              delay: 5,
                            ),

                            SizedBox(height: 30),

                            _buildAnimatedSignInLink(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildAnimatedFormFields() {
    return [
      _buildAnimatedTextField(
        controller: _nameController,
        labelText: 'Full Name',
        prefixIcon: Icons.person_outlined,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your full name';
          }
          return null;
        },
        delay: 1,
      ),

      SizedBox(height: 20),

      _buildAnimatedTextField(
        controller: _emailController,
        labelText: 'Email',
        prefixIcon: Icons.email_outlined,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your email';
          }
          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
            return 'Please enter a valid email';
          }
          return null;
        },
        delay: 2,
      ),

      SizedBox(height: 20),

      _buildAnimatedTextField(
        controller: _passwordController,
        labelText: 'Password',
        prefixIcon: Icons.lock_outlined,
        obscureText: _obscurePassword,
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility : Icons.visibility_off,
            color: Colors.blue,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
            HapticFeedback.selectionClick();
          },
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          }
          if (value.length < 6) {
            return 'Password must be at least 6 characters';
          }
          return null;
        },
        delay: 3,
      ),

      SizedBox(height: 20),

      _buildAnimatedTextField(
        controller: _confirmPasswordController,
        labelText: 'Confirm Password',
        prefixIcon: Icons.lock_outlined,
        obscureText: _obscureConfirmPassword,
        suffixIcon: IconButton(
          icon: Icon(
            _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
            color: Colors.blue,
          ),
          onPressed: () {
            setState(() {
              _obscureConfirmPassword = !_obscureConfirmPassword;
            });
            HapticFeedback.selectionClick();
          },
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please confirm your password';
          }
          if (value != _passwordController.text) {
            return 'Passwords do not match';
          }
          return null;
        },
        delay: 4,
      ),
    ];
  }

  Widget _buildAnimatedTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    required String? Function(String?) validator,
    required int delay,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 800),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: TextFormField(
                controller: controller,
                obscureText: obscureText,
                keyboardType: keyboardType,
                validator: validator,
                decoration: InputDecoration(
                  labelText: labelText,
                  prefixIcon: Icon(prefixIcon, color: Colors.blue),
                  suffixIcon: suffixIcon,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  floatingLabelStyle: TextStyle(color: Colors.blue),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  labelStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
                  errorStyle: TextStyle(fontSize: 12, height: 1.2),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedButton({
    required String text,
    required VoidCallback? onPressed,
    required bool isLoading,
    required Color backgroundColor,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 1000),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                colors: [backgroundColor, backgroundColor.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: backgroundColor.withOpacity(0.3),
                  blurRadius: 15,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child:
                  isLoading
                      ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                          strokeWidth: 2,
                        ),
                      )
                      : Text(
                        text,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedSignInLink() {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 1200),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account? ',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Text(
                  'Sign In',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
