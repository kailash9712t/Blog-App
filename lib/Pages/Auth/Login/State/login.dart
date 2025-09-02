import 'package:blog/Firebase/firebase.dart';
import 'package:blog/Models/User/user_profile.dart';
import 'package:blog/Utils/date_and_time.dart';
import 'package:blog/Utils/show_dialoag.dart';
import 'package:blog/Utils/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';

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
          await getData(context);

          if (!context.mounted) return;

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

  Future<void> getData(BuildContext context) async {
    String? username = FirebaseOperation().retriveUsername();

    if (username == null) return;

    Map<String, dynamic>? userData =
        await FireStoreOperation().getUserData(username);

    if (userData == null) return;

    if (!context.mounted) return;


    logs.i("user data retrive from firebase $userData");

    Timestamp time = userData["joiningDate"];
    DateTime again = time.toDate();

    context.read<UserProfileState>().intializeData(
        username: userData["username"],
        displayName: userData["displayName"],
        bio: userData["bio"],
        cover_url: userData["coverImageUrl"],
        profie_url: userData["profileImageUrl"],
        email: userData["email"],
        joiningDate: DateAndTime().monthAndYear(again),
        location: userData["location"],
        followers: userData["followers"] as int,
        following: userData["following"] as int,
        completeProfile: userData["isProfileCompleted"] as bool);

    print(context.read<UserProfileState>().toJson());

    if (!context.mounted) return;

    await context.read<UserProfileState>().storeLocally();
  }
}
