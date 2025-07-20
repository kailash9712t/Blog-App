import 'package:blog/Pages/Auth/EmailVerification/State/email_verification.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class EmailVerificationPage extends StatefulWidget {
  final String? email;

  const EmailVerificationPage({super.key, required this.email});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    _initializeAnimations();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmailVerificationModel>().startVerificationProcess(context);
      context.read<EmailVerificationModel>().email = widget.email;
    });
    super.initState();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _pulseController.repeat(reverse: true);
    _fadeController.forward();
  }

  Widget buildStatusIcon() {
    return Consumer<EmailVerificationModel>(
      builder: (context, instance, child) {
        bool hasError = instance.errorMessage != null || instance.isExpired;

        if (hasError && _pulseController.isAnimating) {
          _pulseController.stop();
        } else if (!hasError && !_pulseController.isAnimating) {
          _pulseController.repeat(reverse: true);
        }

        return hasError
            ? Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red[400]!, Colors.red[600]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.error_outline,
                size: 50,
                color: Colors.white,
              ),
            )
            : AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue[400]!, Colors.blue[600]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.email_outlined,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            );
      },
    );
  }

  @override
  void dispose() {
    _pulseController.stop();
    _fadeController.stop();

    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 60),

                        buildStatusIcon(),

                        const SizedBox(height: 32),

                        Consumer<EmailVerificationModel>(
                          builder: (context, instance, child) {
                            return Text(
                              instance.titleText,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color:
                                    instance.errorMessage != null ||
                                            instance.isExpired
                                        ? Colors.red[700]
                                        : Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            );
                          },
                        ),

                        const SizedBox(height: 16),

                        Consumer<EmailVerificationModel>(
                          builder: (context, instance, child) {
                            return Text(
                              instance.subtitleText,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            );
                          },
                        ),

                        const SizedBox(height: 40),

                        Consumer<EmailVerificationModel>(
                          builder: (context, instance, child) {
                            return instance.isLoading
                                ? const Column(
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(height: 16),
                                    Text(
                                      'Sending email...',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                )
                                : const SizedBox.shrink();
                          },
                        ),

                        const SizedBox(height: 60),

                        Consumer<EmailVerificationModel>(
                          builder: (context, instance, child) {
                            return !instance.isLoading
                                ? Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 24,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 10,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Didn\'t receive the email?',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 16),

                                      if (instance.isResendEnabled)
                                        SizedBox(
                                          width: double.infinity,
                                          height: 48,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 24,
                                            ),
                                            child: ElevatedButton.icon(
                                              onPressed:
                                                  widget.email != null
                                                      ? () {
                                                        instance
                                                            .resendVerificationEmail(
                                                              context,
                                                              widget.email!,
                                                            );
                                                      }
                                                      : null,
                                              icon: const Icon(Icons.refresh),
                                              label: const Text('Resend Email'),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.blue[600],
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                elevation: 0,
                                              ),
                                            ),
                                          ),
                                        )
                                      else
                                        Column(
                                          children: [
                                            Text(
                                              'You can resend the email in',
                                              style: TextStyle(
                                                color: Colors.grey[500],
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 8,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.blue[50],
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                '${instance.countdownSeconds}s',
                                                style: TextStyle(
                                                  color: Colors.blue[600],
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                )
                                : const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
