import 'dart:async';
import 'package:blog/Utils/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

class EmailVerificationModel extends ChangeNotifier {
  String filename = "emailVerification.dart";
  Timer? timer;
  Timer? timeoutTimer;
  int countdownSeconds = 60;
  bool isResendEnabled = false;
  bool isLoading = false;
  bool isExpired = false;
  String? errorMessage;
  String? email;

  Logger logs = Logger(
    level: kReleaseMode ? Level.off : Level.debug,
    printer: PrettyPrinter(methodCount: 1, colors: true),
  );
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  void startVerificationProcess(BuildContext context) {
    startCountdown(context);
    startTimeoutTimer(context);
  }

  void startCountdown(BuildContext context) async {
    try {
      logs.i("countdown start");

      timer?.cancel();

      countdownSeconds = 60;
      isResendEnabled = false;
      notifyListeners();

      User? user = firebaseAuth.currentUser;

      if (user == null) return;

      logs.i(user.email);
      logs.i(user.email?.length);

      unawaited(user.sendEmailVerification().catchError((onError) {
        logs.w("$filename.startCountDown ${onError.toString()}");
      }));

      timer = Timer.periodic(const Duration(seconds: 1), (time) {
        if (context.mounted) {
          user?.reload();
          user = firebaseAuth.currentUser;

          logs.i(user?.emailVerified);

          if (user!.emailVerified) {
          context.go("/profileSetUp1?editPage=false");
            resetState();
            return;
          }

          if (countdownSeconds > 0) {
            countdownSeconds--;
            logs.i(countdownSeconds);
          } else {
            isResendEnabled = true;
            timer?.cancel();
          }
          notifyListeners();
        } else {
          timer?.cancel();
        }
      });
    } catch (error) {
      logs.e("Email countdown $error");
    }
  }

  void startTimeoutTimer(BuildContext context) {
    timeoutTimer?.cancel();

    timeoutTimer = Timer(const Duration(minutes: 10), () {
      if (context.mounted) {
        isExpired = true;
        notifyListeners();
      }
    });
  }

  void resendVerificationEmail(BuildContext context, String email) async {
    HapticFeedback.selectionClick();
    isLoading = true;
    errorMessage = null;
    isExpired = false;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2));

      if (!context.mounted) return;

      isLoading = false;
      notifyListeners();

      startCountdown(context);
      startTimeoutTimer(context);

      CustomSnackbar().showMessage(
        context,
        Icons.check_circle,
        Colors.green,
        'Verification email sent!',
      );
    } catch (e) {
      isLoading = false;
      errorMessage = 'Failed to send verification email. Please try again.';
      notifyListeners();

      if (context.mounted) {
        CustomSnackbar().showMessage(
          context,
          Icons.close,
          Colors.red,
          'Failed to send email. Please try again.',
        );
      }
    }
  }

  String get titleText {
    if (errorMessage != null || isExpired) return 'Verification Failed';
    return 'Check Your Email';
  }

  String get subtitleText {
    if (isExpired) {
      return 'The verification link has expired.\nPlease request a new verification email.';
    }
    if (errorMessage != null) {
      return errorMessage!;
    }
    return 'We\'ve sent a verification link to\n$maskedEmail\n\nClick the link in your email to verify your account.';
  }

  String get maskedEmail {
    if (email == null || email!.isEmpty) return '';

    final parts = email!.split('@');
    if (parts.length != 2) return email!;

    final username = parts[0];
    final domain = parts[1];

    if (username.length <= 2) return email!;

    final maskedUsername =
        '${username.substring(0, 2)}${'*' * (username.length - 2)}';
    return '$maskedUsername@$domain';
  }

  void resetState() {
    timer?.cancel();
    timeoutTimer?.cancel();

    timer = null;
    timeoutTimer = null;
    countdownSeconds = 60;
    isResendEnabled = false;
    isLoading = false;
    isExpired = false;

    errorMessage = null;
    email = null;
  }
}
