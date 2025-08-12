import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/web.dart';

Logger logs = Logger(
  level: kReleaseMode ? Level.off : Level.debug,
  printer: PrettyPrinter(methodCount: 1, colors: true),
);

String fileName = "firebase.dart";

class FirebaseOperation {
  final auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>> createNew(
      String username, String email, String password) async {
    bool status = false;
    String message = "";
    try {
      final response = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      response.user?.updateDisplayName(username);

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
    int status = 0;
    String message = "";

    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      status = 0;
      message = "user Login";

      User? user = auth.currentUser;

      if (user != null && !user.emailVerified) {
        status = 1;
        message = "email not verify";
      }
    } on FirebaseException catch (e) {
      status = 2;
      message = e.code;
      logs.e(
          "Firebase Exception : ${e.code == "account-exists-with-different-credential"}");
    } catch (error) {
      status = 2;
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

  String? retriveUsername() {
    try {
      User? user = auth.currentUser;

      if (user == null) return null;

      return user.displayName;
    } catch (error) {
      logs.e("$fileName.retriveUsername ${error.toString()}");
    }

    return null;
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

  Future<bool> followOperation(
      String follow, String follower, String operation) async {
    DocumentReference followReference =
        instance.collection("Follow").doc(follow);
    DocumentReference followerReference =
        instance.collection("Follow").doc(follower);
    try {
      await followReference.update({
        "Followers": operation == "add"
            ? FieldValue.arrayUnion([follower])
            : FieldValue.arrayRemove([follower])
      });

      await followerReference.update({
        "Following": operation == "add"
            ? FieldValue.arrayUnion([follow])
            : FieldValue.arrayRemove([follow])
      });

      return true;
    } catch (error) {
      logs.e("$fileName.addFollow ${error.toString()}");
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

  Future<Map<String, dynamic>> isUsernameAlreadyPresent(String username) async {
    try {
      DocumentReference reference = instance.collection("Users").doc(username);
      DocumentSnapshot snapshot = await reference.get();

      if (!snapshot.exists) return {"status": true, "message": "new user!"};
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      String? email = data["email"];

      if (email == null) return {"status": true, "message": "new user!"};
    } catch (error) {
      logs.e("$fileName.isUserAlreadyPresent ${error.toString()}");
      return {"status": false, "message": "Internal error"};
    }

    return {"status": false, "message": "username already used!"};
  }

  Future<Map<String, dynamic>?> getUserData(String username) async {
    try {
      DocumentReference reference = instance.collection("Users").doc(username);
      DocumentSnapshot snapshot = await reference.get();

      if (!snapshot.exists) return null;

      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return data;
    } catch (error) {
      logs.e("$fileName.getUserData ${error.toString()}");
    }
    return null;
  }
}

class HandlePost {
  final FirebaseFirestore instance = FirebaseFirestore.instance;

  Future<bool> storePost(Map<String, dynamic> data) async {
    try {
      DocumentReference reference = instance
          .collection("Users")
          .doc(data["userName"])
          .collection("Tweet")
          .doc();

      await reference.set(data);

      return true;
    } catch (error) {
      logs.e("$fileName.storePost ${error.toString()}");
    }
    return false;
  }

  Future<List<Map<String, dynamic>>?> loadPost(String username) async {
    try {
      logs.i("here task to execute $username");
      final snapshot = await instance
          .collection("Users")
          .doc(username)
          .collection("Tweet")
          .orderBy('timeAgo', descending: true)
          .get();

      logs.i("snapshot : - ${snapshot.docs.length}");

      List<Map<String, dynamic>> data =
          snapshot.docs.map((doc) => doc.data()).toList();

      return data;
    } catch (error) {
      logs.e("$fileName.loadPost ${error.toString()}");
    }

    return null;
  }
}

class Relation {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  Future<bool> addFriend(String user, Map<String, dynamic> userData) async {
    try {
      DocumentReference reference = instance
          .collection("Users")
          .doc(user)
          .collection("Followers")
          .doc(userData["username"]);

      DocumentReference reference1 = instance
          .collection("Users")
          .doc(userData["username"])
          .collection("Following")
          .doc(user);

      WriteBatch batch = instance.batch();

      batch.set(reference, userData);
      batch.set(reference1, {
        "username": user,
        "displayName": userData["displayName"],
        "profileUrl": userData["profileUrl"]
      });

      await batch.commit();

      return true;
    } catch (error) {
      logs.e("$fileName.addFriend ${error.toString()}");
    }

    return false;
  }
}
