import 'package:blog/Firebase/firebase.dart';
import 'package:blog/Utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class LoginPageModel extends ChangeNotifier {
  bool isLoading = false;

  Future<void> login(
    BuildContext context,
    GlobalKey<FormState> formKey,
    String email,
    String password,
  ) async {
    try {
      if (formKey.currentState!.validate()) {
        isLoading = true;
        notifyListeners();

        HapticFeedback.lightImpact();

        Map<String, dynamic> response = await FirebaseOperation().signIn(
          email,
          password,
        );

        bool isLogin = response["status"] as bool;
        String message = response["message"];

        HapticFeedback.mediumImpact();

        if (!context.mounted) return;

        if (isLogin) {
          CustomSnackbar().showMessage(context, Icons.check_circle ,Colors.green, message);
          context.go('/home');
        } else {
          CustomSnackbar().showMessage(context,Icons.close , Colors.red, message);
        }
      } else {
        HapticFeedback.heavyImpact();
      }
    } catch (error) {
      print("Error : $error");
    }

    isLoading = false;
    notifyListeners();
  }
}
