import 'package:blog/Firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class RegisterModel extends ChangeNotifier {
  bool isLoading = false;

  Future<void> register(
    BuildContext context,
    GlobalKey<FormState> formKey,
    String username,
    String email,
    String password,
  ) async {
    if (formKey.currentState!.validate()) {
      isLoading = true;
      notifyListeners();

      HapticFeedback.lightImpact();

      await Future.delayed(Duration(seconds: 2));

      HapticFeedback.mediumImpact();

      if (!context.mounted) return;

      Map<String, dynamic> userData = {
        "username": username,
        "email": email,
        "password": password,
        "joiningDate": DateTime.now(),
        "bio": null,
        "location": null,
        "isProfileCompleted": false,
        "DisplayName" : null
      };

      bool isDataStore = await FireStoreOperation().storeUserData(userData);

      if (!context.mounted) return;

      if (isDataStore) {
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

        if (!context.mounted) return;

        context.go("/profileSetUp");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Failed'),
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

    isLoading = false;
    notifyListeners();
  }
}
