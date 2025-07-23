import 'package:blog/Firebase/firebase.dart';
import 'package:blog/Utils/show_dialoag.dart';
import 'package:blog/Utils/snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/web.dart';

class LoginPageModel extends ChangeNotifier {
  bool isLoading = false;
  String currentFile = "login.dart";

  Logger logs = Logger(
    level: kReleaseMode ? Level.off : Level.debug,
    printer: PrettyPrinter(colors: true),
  );

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

        int isLogin = response["status"] as int;
        String message = response["message"];

        HapticFeedback.mediumImpact();

        if (!context.mounted) return;

        if (isLogin == 0) {
          CustomSnackbar()
              .showMessage(context, Icons.check_circle, Colors.green, message);
          context.go('/home');
        } else if (isLogin == 1) {
          CustomDialogBox().showDialogBox(context, email);
        } else {
          CustomSnackbar()
              .showMessage(context, Icons.close, Colors.red, message);
        }
      } else {
        HapticFeedback.heavyImpact();
      }
    } catch (error) {
      logs.e("$currentFile.login ${error.toString()}");
    }

    isLoading = false;
    notifyListeners();
  }
}
