import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseOperation {
  final auth = FirebaseAuth.instance;

  Future<void> createNew(String email, String password) async {
    try {
      final response = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print(response);
    } on FirebaseException catch (e) {
      print("Its firebase exception $e");
    } catch (error) {
      print(error);
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseException catch (e) {
      print("Its firebase exception $e");
    } catch (error) {
      print(error);
    }
    return false;
  }

  Future<void> emailVerificaiton(User? user) async {
    try {
      await user?.sendEmailVerification();
    } catch (error) {
      print("error at email verification");
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
      print("Error FireStore : $error");
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
      print("Error : $error");
    }
    return false;
  }
}
