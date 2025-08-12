import 'package:blog/Firebase/firebase.dart';
import 'package:blog/Models/BlogPost/follow.dart';
import 'package:blog/Models/BlogPost/post.dart';
import 'package:blog/Models/Hive_Model/UserData/user.dart';
import 'package:blog/Utils/date_and_time.dart';
import 'package:blog/Utils/user_data_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';

String filename = "user.dart";

class UserPageModel extends ChangeNotifier {
  UserModel userModel = UserModel();
  bool isFollowing = false;

  List<BlogPost> personalPost = [];
  List<Follow> follower = [];
  List<Follow> following = [];

  Logger logs = Logger(
      level: kReleaseMode ? Level.off : Level.debug,
      printer: PrettyPrinter(methodCount: 1, colors: true));

  Future<void> initialTask(
      BuildContext context, bool userOwnProfile, String username) async {
    try {
      if (userOwnProfile) {
        userModel = context.read<UserDataProvider>().userModel;
      } else {
        Map<String, dynamic>? data =
            await FireStoreOperation().getUserData(username);

        if (data == null) throw Exception("no user present");

        print("problem here :");

        Timestamp stamp = data["joiningDate"] as Timestamp;

        DateTime time = stamp.toDate();

        print("check out ");

        userModel = UserModel(
            username: data["username"],
            bio: data["bio"],
            coverUrl: data["coverImageUrl"],
            displayName: data["displayName"],
            email: data["email"],
            joiningDate: DateAndTime().monthAndYear(time),
            location: data["location"],
            profileUrl: data["profileImageUrl"]);
      }
    } catch (error) {
      logs.e("$filename.initialTask ${error.toString()}");
    }
    notifyListeners();
  }

  Future<void> loadPost(BuildContext context) async {
    try {
      personalPost = [];

      String? username = userModel.username;

      if (username == null) return;

      List<Map<String, dynamic>>? listOfUser =
          await HandlePost().loadPost(username);

      if (listOfUser == null) return;

      handleList(listOfUser);

      display();

      handleRender();
    } catch (error) {
      logs.i("$filename.loadPost ${error.toString()}");
    }
  }

  void handleList(List<Map<String, dynamic>> data) async {
    try {
      for (int i = 0; i < data.length; i++) {
        convertMapToClass(data[i]);
      }
    } catch (error) {
      logs.i("$filename.handleList ${error.toString()}");
    }
  }

  void convertMapToClass(Map<String, dynamic> data) {
    BlogPost post = BlogPost.fromJson(data);
    personalPost.add(post);
  }

  void display() {
    for (int i = 0; i < personalPost.length; i++) {
      logs.i(personalPost[i]);
    }
  }

  void toggleLike(String postId) {
    BlogPost post = personalPost.firstWhere((p) => p.id == postId);
    BlogPost likeUpdated = post.copyWith(
        isLiked: !post.isLiked, likes: post.likes - (post.isLiked ? 1 : -1));
    post = likeUpdated;
    notifyListeners();
    HapticFeedback.lightImpact();
  }

  Future<void> follow(BuildContext context, Map<String, dynamic> data) async {
    try {
      String? currentUsername =
          context.read<UserDataProvider>().userModel.username;

      if (currentUsername == null) return;

      Relation().addFriend(currentUsername, data);

      isFollowing = true;

      notifyListeners();
    } catch (error) {
      logs.e("$fileName.follow ${error.toString()}");
    }
  }

  void handleRender() {
    bool firstFrameRender = WidgetsBinding.instance.firstFrameRasterized;
    bool inBuildPhase = WidgetsBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks;

    print("To FirstFrameRender : - $firstFrameRender");

    if (firstFrameRender && !inBuildPhase) notifyListeners();
  }
}
