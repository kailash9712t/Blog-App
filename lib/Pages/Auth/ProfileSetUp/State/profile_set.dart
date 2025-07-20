import 'package:blog/Firebase/firebase.dart';
import 'package:blog/Utils/snackbar.dart';
import 'package:blog/Utils/user_data_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/web.dart';

class ProfileSetModel extends ChangeNotifier {
  bool isLoading = false;
  String currentFileName = "profile_set.dart";

  Logger logs = Logger(
    level: kReleaseMode ? Level.off : Level.debug,
    printer: PrettyPrinter(colors: true),
  );

  Future<void> profileDataStore(
    GlobalKey<FormState> formKey,
    BuildContext context,
    String username,
    String? location,
  ) async {
    String currentMethod = "profileDataStore";
    try {
      if (formKey.currentState!.validate()) {
        isLoading = true;
        notifyListeners();

        HapticFeedback.lightImpact();

        await Future.delayed(Duration(seconds: 2));

        HapticFeedback.mediumImpact();

        Map<String, dynamic> userData = {
          "username" : username,
          "email": null,
          "password": null,
          "joiningDate": DateTime.now(),
          "bio": null,
          "location": location,
          "isProfileCompleted": false,
          "displayName": null,
          "coverImageUrl": null,
          "profileImageUrl": null,
        };

        bool response = await FireStoreOperation().storeUserData(userData);

        if (!context.mounted) return;

        if (response) {
          UserDataProvider().userModel.username = username;

          context.push("/register");

          CustomSnackbar().showMessage(context,Icons.check_circle, Colors.green, "Data Saved!");
        } else {
          CustomSnackbar().showMessage(context,Icons.close ,Colors.red, "Failed");
        }
      } else {
        HapticFeedback.heavyImpact();
      }
    } catch (error) {
      logs.e("$currentFileName.$currentMethod Error : - ${error.toString()}");
    }
  }
}
