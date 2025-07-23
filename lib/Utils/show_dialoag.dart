import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomDialogBox {
  Future<void> showDialogBox(BuildContext context,String email) async {
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
                  },
                  child: Text("Verify"))
            ],
          );
        });
  }
}
