import 'dart:io';

import 'package:blog/Firebase/firebase.dart';
import 'package:blog/Utils/cloudinary.dart';
import 'package:blog/Utils/snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/web.dart';

class ProfileSetUp1 extends ChangeNotifier {
  bool isLoading = false;
  String currentFileName = "ProfileSetUp1";
  Logger logs = Logger(
    level: kReleaseMode ? Level.off : Level.debug,
    printer: PrettyPrinter(colors: true),
  );

  File? profileImageUrl;
  File? coverImageUrl;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImageFromSource(ImageSource source, bool isProfile) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: isProfile ? 400 : 800,
        maxHeight: isProfile ? 400 : 400,
        imageQuality: 70,
      );

      if (image != null) {
        if (isProfile) {
          profileImageUrl = File(image.path);
        } else {
          coverImageUrl = File(image.path);
        }
        notifyListeners();
      }
    } catch (e) {
      print("Error : - $e");
    }
  }

  Future<void> profileDataStore1(
    BuildContext context,
    String displayName,
    String bio,
  ) async {
    String currentMethod = "profileDataStore1";
    try {
      print("let me check");
      isLoading = true;
      notifyListeners();

      HapticFeedback.lightImpact();

      await Future.delayed(Duration(seconds: 2));

      HapticFeedback.mediumImpact();
      String? profileImage;
      String? coverImage;

      if (profileImageUrl != null) {
        await CloudinaryOperation().uploadImage(profileImageUrl!);
      }
      if (coverImageUrl != null) {
        await CloudinaryOperation().uploadImage(coverImageUrl!);
      }
      print("ProfileImage : - $coverImage");

      Map<String, dynamic> userData = {
        "displayName": displayName,
        "bio": bio,
        "profileImageUrl": profileImage,
        "coverImageUrl": coverImage,
      };

      bool response = await FireStoreOperation().updateData(userData);

      if (!context.mounted) return;

      if (response) {
        context.push("/home");

        CustomSnackbar().showMessage(context,Icons.check_circle ,Colors.green, "Data Saved!");
      } else {
        CustomSnackbar().showMessage(context,Icons.close, Colors.red, "Failed");
      }
    } catch (error) {
      logs.e("$currentFileName.$currentMethod Error : - ${error.toString()}");
    }
  }

  Future<void> pickProfileImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 400,
        maxHeight: 400,
        imageQuality: 70,
      );

      if (image != null) {
        profileImageUrl = File(image.path);
      }
      notifyListeners();
    } catch (e) {
      print("Error : - $e");
    }
  }

  Future<void> pickCoverImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 400,
        imageQuality: 80,
      );

      if (image != null) {
        coverImageUrl = File(image.path);
      }
      notifyListeners();
    } catch (e) {
      print("Error : - $e");
    }
  }

  void handleCancel(
    TextEditingController displayNameController,
    TextEditingController bioController,
  ) {
    displayNameController.clear();
    bioController.clear();
  }
}
