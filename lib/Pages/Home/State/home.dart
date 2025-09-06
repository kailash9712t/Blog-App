import 'dart:io';

import 'package:blog/Firebase/firebase.dart';
import 'package:blog/Models/BlogPost/post.dart';
import 'package:blog/Models/Hive_Model/UserData/user.dart';
import 'package:blog/Models/User/user_profile.dart';
import 'package:blog/Utils/cloudinary.dart';
import 'package:blog/Utils/snackbar.dart';
import 'package:blog/Utils/uuid.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

enum UploadStatus { notStart, start, stored, failed }

class HomePageModel extends ChangeNotifier {
  String filename = "home.dart";
  List<File> imageInList = [];
  Map<int, File> imageInMap = {};
  int assignIndex = 0;
  // List<File> selectedImage = [];
  // Set<File> selectedFile = {};
  final ImagePicker _picker = ImagePicker();
  List<BlogPost> posts = [
    BlogPost(
      id: "1",
      userName: "Alice Johnson",
      userHandle: "alice_j",
      userAvatar:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgWkA3X9cdGn3tggpvy_hnWe0QmRZW-DjwHw&s",
      timeAgo: "2h",
      content:
          "Just finished reading an amazing article about Flutter development. The way widgets compose together is truly beautiful! 🚀",
      profileUrl:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQTZB3inQS_rlFHLkaHoCVN7aXs4ZiYNySBtg&s",
      likes: 24,
      comments: 5,
      reposts: 12,
      isLiked: false,
    ),
    BlogPost(
      id: "2",
      userName: "Tech Blogger",
      userHandle: "@techblogger",
      userAvatar:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTCwYtl1tFUwEbfdDLVzOmud-NVp1vrzzunyMdPsCIHWH6UWEbI_Ua-I_1GOvpDYFCDgpQ&usqp=CAU",
      timeAgo: "4h",
      content:
          "The future of mobile development is here! What do you think about the latest updates in cross-platform frameworks?",
      likes: 89,
      comments: 23,
      reposts: 34,
      isLiked: true,
    ),
    BlogPost(
      id: "3",
      userName: "Sarah Wilson",
      userHandle: "@sarah_codes",
      userAvatar:
          "https://blog.texasbar.com/files/2013/09/JessicaMangrum_smaller1.jpg",
      timeAgo: "6h",
      content:
          "Building beautiful UIs has never been easier. Here's my latest project showcase!",
      profileUrl:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQTZB3inQS_rlFHLkaHoCVN7aXs4ZiYNySBtg&s",
      likes: 156,
      comments: 67,
      reposts: 23,
      isLiked: false,
    ),
  ];

  Future<void> pickImageFromSource() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 400,
        maxHeight: 400,
        imageQuality: 70,
      );

      if (image == null) return;

      imageInMap[assignIndex] = File(image.path);

      imageInList = imageInMap.values.toList();

      logs.i("user pick a image");
      notifyListeners();

      assignIndex++;
    } catch (e) {
      logs.e("$filename.pickImageFromSource ${e.toString()}");
    }
  }

  Map<String, UploadStatus> values = {"uploadPost": UploadStatus.notStart};
  bool isPostExtend = false;

  Logger logs = Logger(
      level: kReleaseMode ? Level.off : Level.debug,
      printer: PrettyPrinter(methodCount: 2, colors: true));

  Future<void> savePost(Map<String, dynamic> data) async {
    try {
      bool status = await HandlePost().storePost(data);
      logs.i(status);
      if (!status) {
        updateStatus(UploadStatus.failed);
        return;
      }

      updateStatus(UploadStatus.stored);

      await Future.delayed(Duration(seconds: 3));
    } catch (error) {
      logs.i("$filename.HomePageModel ${error.toString()}");
    }

    updateStatus(UploadStatus.notStart);

    isPostExtend = false;
    notifyListeners();
  }

  void updateStatus(UploadStatus status) {
    values["uploadPost"] = status;
    notifyListeners();
  }

  void togglePostExpansion() {
    isPostExtend = !isPostExtend;
    notifyListeners();
    HapticFeedback.lightImpact();
  }

  void toggleLike(String postId) {
    BlogPost post = posts.firstWhere((p) => p.id == postId);
    BlogPost likeUpdated = post.copyWith(
        isLiked: !post.isLiked,
        likes: post.likes -
            (post.isLiked ? 1 : -1)); // hey here the logic of toggle like
    post = likeUpdated;

    print(post.likes);

    notifyListeners();
    HapticFeedback.lightImpact();
  }

  void displayList(List<String?> response) {
    for (var imageUrl in response) {
      logs.i(imageUrl);
    }
  }

  void publishPost(String text, BuildContext context) async {
    try {
      updateStatus(UploadStatus.start);

      if (text.isEmpty) {
        return updateStatus(UploadStatus.notStart);
      }
      UserModel localUserData = context.read<UserProfileState>().model;

      logs.i("publish post start ");

      List<Future<String?>> futureUpload = imageInMap.entries
          .map((entries) => CloudinaryOperation().uploadImage(entries.value))
          .toList();

      logs.i("publish post intermediate ");

      List<String?> response = await Future.wait(futureUpload);

      logs.i("image upload done");

      displayList(response);

      Map<String, dynamic> data = {
        "postID": UUID().newId(),
        "displayName": localUserData.displayName,
        "userName": localUserData.username,
        "timeAgo": DateTime.now(),
        "content": text,
        "profileUrl": localUserData.profileUrl,
        "imageUrl": response,
        "likes": 0,
        "comments": 0,
        "reposts": 0,
      };

      HapticFeedback.mediumImpact();

      if (!context.mounted) return;

      await context.read<HomePageModel>().savePost(data);

      if (!context.mounted) return;

      CustomSnackbar().showMessage(
          context, Icons.check, Colors.green, "Post published successfully!");

      imageInList.clear();
      imageInMap.clear();
      assignIndex = 0;
    } catch (error) {
      logs.i("$filename.publishPost ${error.toString()}");
    }
  }

  void removeImage(int index) {
    int removeIndexkey = imageInMap.keys.toList()[index];
    imageInMap.remove(removeIndexkey);
    imageInList = imageInMap.values.toList();
    notifyListeners();
  }

  void resetState() {
    imageInList.clear();
    imageInMap.clear();
    assignIndex = 0;
  }
}
