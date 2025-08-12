import 'package:blog/Firebase/firebase.dart';
import 'package:blog/Models/Hive_Model/UserData/user.dart';
import 'package:blog/Utils/date_and_time.dart';
import 'package:blog/Utils/user_data_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CustomDialogBox {
  Future<void> showDialogBox(BuildContext context, String email) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Message",
              style: TextStyle(fontWeight: FontWeight.w500, color: Colors.blue),
            ),
            content: Text("Please Verify your Email."),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    context.push("/emailVerification?email=$email");
                    getData(context);
                  },
                  child: Text("Verify"))
            ],
          );
        });
  }

  Future<void> getData(BuildContext context) async {
    String? username = FirebaseOperation().retriveUsername();

    if (username == null) return;

    Map<String, dynamic>? userData =
        await FireStoreOperation().getUserData(username);

    if (userData == null) return;

    if (!context.mounted) return;

    UserModel user = context.read<UserDataProvider>().userModel;

    user.username = userData["username"];
    user.displayName = userData["displayName"];
    user.bio = userData["bio"];
    user.coverUrl = userData["coverImageUrl"];
    user.profileUrl = userData["profileImageUrl"];
    user.email = userData["email"];
    Timestamp time = userData["joiningDate"];
    DateTime again = time.toDate();
    user.joiningDate = DateAndTime().monthAndYear(again);
    user.location = userData["location"];

    if (!context.mounted) return;

    await context.read<UserDataProvider>().storeLocally();
  }
}
