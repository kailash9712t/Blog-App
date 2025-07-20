import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/web.dart';

Logger logs = Logger(
  level: kReleaseMode ? Level.off : Level.debug,
  printer: PrettyPrinter(methodCount: 1, colors: true),
);

String fileName = "firebase.dart";

class FirebaseOperation {
  final auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>> createNew(String email, String password) async {
    bool status = false;
    String message = "";
    try {
      final response = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      logs.i("Google New Account Created : $response");

      status = true;
      message = "Email registered";
    } on FirebaseException catch (e) {
      logs.e("Firebase Exception : ${e.code}");

      status = false;
      message = "email already used!";
    } catch (error) {
      logs.e("Firebase.createNew : ${error.toString()}");

      status = false;
      message = error.toString();
    }

    return {"status": status, "message": message};
  }

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    bool status = false;
    String message = "";

    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      status = true;
      message = "user Login";
    } on FirebaseException catch (e) {
      status = false;
      message = e.code;
      logs.e("Firebase Exception : ${e.code == "account-exists-with-different-credential"}");
    } catch (error) {
      status = false;
      message = error.toString();
      logs.e("Firebase.signIn : ${error.toString()}");
    }
    return {"status": status, "message": message};
  }

  Future<void> emailVerificaiton(User? user) async {
    try {
      await user?.sendEmailVerification();
    } catch (error) {
      logs.e("Firebase.emailVerification : ${error.toString()}");
    }
  }
}

class FireStoreOperation {
  final FirebaseFirestore instance = FirebaseFirestore.instance;

  Future<bool> storeUserData(Map<String, dynamic> userData) async {
    try {
      await instance
          .collection("Users")
          .doc(userData["username"])
          .set(userData);

      return true;
    } catch (error) {
      logs.e("Firebase.storeUserData : ${error.toString()}");
    }

    return false;
  }

  Future<bool> updateData(Map<String, dynamic> updateData) async {
    try {
      await instance
          .collection("Users")
          .doc(updateData["username"])
          .update(updateData);

      return true;
    } catch (error) {
      logs.e("Firebase.updateData : ${error.toString()}");
    }
    return false;
  }
}

class Storage {
  final FirebaseStorage instance = FirebaseStorage.instance;
  Future<String?> uploadFile(File file) async {
    try {
      String filepath = file.path.split("/").last;

      logs.i(filepath);

      Reference ref = instance.ref().child(filepath);

      UploadTask task = ref.putFile(file);

      logs.i("task : - $task");

      final snapShot = await task;

      String? url;

      logs.i(snapShot.state);

      if (snapShot.state == TaskState.success)
        await snapShot.ref.getDownloadURL();

      return url;
    } catch (error) {
      logs.e("Firebase.uploadFile : ${error.toString()}");
    }
    return null;
  }
}
