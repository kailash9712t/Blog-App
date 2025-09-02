import 'dart:async';

import 'package:blog/Firebase/firebase.dart';
import 'package:blog/Models/BlogPost/follow.dart';
import 'package:blog/Models/BlogPost/post.dart';
import 'package:blog/Models/Hive_Model/UserData/user.dart';
import 'package:blog/Models/User/user_profile.dart';
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

  Map<String, BlogPost> personalPost = {};
  List<dynamic> likedPost = [];

  List<Follow> follower = [];
  List<Follow> following = [];

  Logger logs = Logger(
      level: kReleaseMode ? Level.off : Level.debug,
      printer: PrettyPrinter(methodCount: 1, colors: true));

  Future<void> initialTask(
      BuildContext context, bool userOwnProfile, String username) async {
    try {
      if (userOwnProfile) {
        userModel = context.read<UserProfileState>().model;
      } else {
        Map<String, dynamic>? data =
            await FireStoreOperation().getUserData(username);

        if (data == null) throw Exception("no user present");

        Timestamp stamp = data["joiningDate"] as Timestamp;

        DateTime time = stamp.toDate();

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
      personalPost = {};

      String? username = userModel.username;

      if (username == null) return;

      List<Map<String, dynamic>>? listOfUser =
          await HandlePost().loadPost(username);

      logs.i("here are their list : $listOfUser");

      if (listOfUser == null) return;

      handleList(listOfUser);

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
    if (hashListOfLikedPost.contains(post.id)) {
      logs.i("here post id ${post.id}");
      post.isLiked = true;
    }
    personalPost[post.id] = post;
  }

  Timer? userSpamLikes;

  void toggleLike(String? username, String postId, BuildContext context) async {
    logs.i("clicked on like id : - $postId");

    BlogPost? post = personalPost[postId];

    if (post == null) {
      throw Exception("post not found");
    }

    logs.i("clicked on like id : - ${post.likes} ${post.isLiked}");

    post.likes = post.isLiked ? post.likes - 1 : post.likes + 1;
    post.isLiked = !post.isLiked;
    logs.i("clicked on like id : - ${post.likes} ${post.isLiked}");
    notifyListeners();
    HapticFeedback.lightImpact();

    if (userSpamLikes != null) {
      userSpamLikes!.cancel();
      userSpamLikes = null;
      return;
    }

    if (username == null) {
      logs.i("username is null");
      return;
    }

    userSpamLikes = Timer(Duration(seconds: 3), () async {
      bool response =
          await HandlePost().addLikes(username, postId, post.isLiked);
      userSpamLikes = null;
      if (!response) throw Exception("user liked request failed");
    });
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

  Future<void> loadLikedPost() async {
    try {
      likedPost = await HandlePost().getLikedPost();
      hashSetOperation();
    } catch (error) {
      logs.i("$filename.loadLikedPost ${error.toString()}");
    }
    notifyListeners();
  }

  void handleRender() {
    bool firstFrameRender = WidgetsBinding.instance.firstFrameRasterized;
    bool inBuildPhase = WidgetsBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks;

    if (firstFrameRender && !inBuildPhase) notifyListeners();
  }

  Set<String> hashListOfLikedPost = {};

  void hashSetOperation() async {
    for (int i = 0; i < likedPost.length; i++) {
      hashListOfLikedPost.add(likedPost[i]["postId"]);
    }
  }

  List<String> mediaTab = [];

  void retrivePhotosfromMediaTab() async {
    personalPost.forEach((key, value) {
      mediaTab.addAll(value.contentImage);
    });
  }
}
