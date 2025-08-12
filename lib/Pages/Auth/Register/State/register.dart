import 'package:blog/Firebase/firebase.dart';
import 'package:blog/Utils/snackbar.dart';
import 'package:blog/Utils/user_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RegisterModel extends ChangeNotifier {
  bool isLoading = false;
  String fileName = "RegisterModel";

  Future<void> register(
    BuildContext context,
    GlobalKey<FormState> formKey,
    String email,
    String password,
  ) async {
    UserDataProvider data = context.read<UserDataProvider>();
    try {
      if (formKey.currentState!.validate()) {
        isLoading = true;
        notifyListeners();

        HapticFeedback.lightImpact();

        await Future.delayed(Duration(seconds: 2));

        HapticFeedback.mediumImpact();

        if (!context.mounted) return;

        DateTime currentDateAndTime = DateTime.now();

        print("test1");

        Map<String, dynamic> userData = {
          "username": data.userModel.username,
          "email": email,
          "password": password,
          "joiningDate": currentDateAndTime,
          "followers": 0,
          "following": 0
        };

        print("test2");

        bool isDataStore = await FireStoreOperation().updateData(userData);
        Map<String, dynamic> response = await FirebaseOperation()
            .createNew(data.userModel.username!, email, password);

        bool status = response["status"] as bool;
        String message = response["message"];

        if (!context.mounted) return;

        if (isDataStore && status) {
          CustomSnackbar().showMessage(
            context,
            Icons.check_circle,
            Colors.green,
            message,
          );

          if (!context.mounted) return;

          data.loadData(
              email: email, joiningDate: currentDateAndTime);

          context.push("/emailVerification?email=$email");
        } else {
          CustomSnackbar().showMessage(
            context,
            Icons.close,
            Colors.red,
            message,
          );
        }
      } else {
        HapticFeedback.heavyImpact();
      }

      isLoading = false;
      notifyListeners();
    } catch (error) {
      logs.e("$fileName.register ${error.toString()}");
    }
  }
}
