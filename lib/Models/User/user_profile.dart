// ignore_for_file: non_constant_identifier_names

import 'package:blog/Models/Hive_Model/UserData/user.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';

class UserProfileState extends ChangeNotifier {
  UserModel model = UserModel();

  Logger logs = Logger(
      level: kReleaseMode ? Level.off : Level.debug,
      printer: PrettyPrinter(methodCount: 1, colors: true));

  void intializeData(
      {String? displayName,
      String? username,
      String? email,
      String? joiningDate,
      String? bio,
      String? location,
      bool? completeProfile,
      String? cover_url,
      String? profie_url,
      int following = 0,
      int followers = 0,
      String? website}) {
    model.username = username;
    model.displayName = displayName;
    model.email = email;
    model.joiningDate = joiningDate;
    model.bio = bio;
    model.location = location;
    model.completeProfile = model.completeProfile;
    model.coverUrl = cover_url;
    model.profileUrl = profie_url;
    model.following = following;
    model.followers = followers;
    model.website = website;

    notifyListeners();
  }

  Future<void> storeLocally() async {
    try {
      Box box = Hive.isBoxOpen("UserBox")
          ? Hive.box<UserModel>("UserBox")
          : await Hive.openBox<UserModel>("UserBox");

      await box.put("UserData", model);
    } catch (error) {
      logs.e("storeLocally ${error.toString()}");
    }
  }

  Future<void> loadData() async {
    try {
      Box box = Hive.isBoxOpen("UserBox")
          ? Hive.box<UserModel>("UserBox")
          : await Hive.openBox<UserModel>("UserBox");

      model = await box.get("UserData");
    } catch (error) {
      logs.e("loadData ${error.toString()}");
    }
  }

  Future<void> deleteBox() async {
    try {
      await Hive.deleteBoxFromDisk("UserBox");
      model = UserModel();
    } catch (error) {
      logs.e("deleteBox ${error.toString()}");
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "userName": model.username,
      "displayName": model.displayName,
      "email": model.email,
      "profileUrl": model.profileUrl,
      "joiningDate": model.joiningDate,
      "location": model.location,
      "completeProfile": model.completeProfile,
      "coverUrl": model.coverUrl,
      "bio": model.bio,
      "followers": model.followers,
      "following": model.following,
      "website": model.website,
    };
  }
}
