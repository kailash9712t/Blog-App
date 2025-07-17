import 'package:blog/Firebase/firebase.dart';
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

        bool isLogin = await FirebaseOperation().signIn(email, password);

        HapticFeedback.mediumImpact();

        if (!context.mounted) return;

        if (isLogin) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Login successful!'),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
          context.go('/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.close, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Invalid credential'),
                ],
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
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
