import 'package:blog/Config/env.dart';
import 'package:blog/Models/Hive_Model/UserData/user.dart';
import 'package:blog/Utils/date_and_time.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:logger/web.dart';

class UserDataProvider extends ChangeNotifier {
  UserModel userModel = UserModel();

  final Logger logs = Logger(
    level: kReleaseMode ? Level.off : Level.debug,
    printer: PrettyPrinter(methodCount: 1, colors: true),
  );

  void loadData(
      {String? username,
      String? bio,
      String? displayName,
      String? location,
      String? email,
      String? coverUrl,
      String? profileUrl,
      DateTime? joiningDate,
      int? follower,
      int? following}) {
    userModel.username = username ?? userModel.username;
    userModel.bio = bio ?? userModel.bio;
    userModel.displayName = displayName ?? userModel.displayName;
    userModel.location = location ?? userModel.location;

    userModel.email = email ?? userModel.email;
    userModel.coverUrl = coverUrl ?? userModel.coverUrl;
    userModel.profileUrl = profileUrl ?? userModel.profileUrl;

    if (joiningDate != null) {
      userModel.joiningDate =
          DateAndTime().monthAndYear(joiningDate) ??
              userModel.joiningDate;
    }

    userModel.followers = follower ?? userModel.followers;
    userModel.following = following ?? userModel.following;

    notifyListeners();
  }

  Future<void> storeLocally() async {
    String boxName = HiveBoxName.userData;

    Box box = Hive.isBoxOpen(boxName)
        ? Hive.box<UserModel>(boxName)
        : await Hive.openBox<UserModel>(boxName);

    await box.put("userData", userModel);
  }

  Future<void> loadDataFromLocalDatabase() async {
    String boxName = HiveBoxName.userData;

    Box box = Hive.isBoxOpen(boxName)
        ? Hive.box<UserModel>(boxName)
        : await Hive.openBox<UserModel>(boxName);

    UserModel? temp = await box.get("userData");

    if (temp == null) {
      logs.w("user data not present locally");
      return;
    }

    userModel = temp;
  }
}
