import 'package:hive_flutter/adapters.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  String? username; 
  @HiveField(1)
  String? displayName;
  @HiveField(2)
  String? email;
  @HiveField(3)
  String? password;
  @HiveField(4)
  String? joiningDate;
  @HiveField(5)
  String? bio;
  @HiveField(6)
  String? location;
  @HiveField(7)
  bool? completeProfile;
  @HiveField(8)
  String? coverUrl;
  @HiveField(9)
  String? profileUrl;
  @HiveField(10)
  int following;
  @HiveField(11)
  int followers;
  @HiveField(12)
  int posts;
  @HiveField(13)
  bool isVerify;
  @HiveField(14)
  String? website;

  UserModel(
      {this.username,
      this.displayName,
      this.email,
      this.password,
      this.joiningDate,
      this.bio,
      this.location,
      this.completeProfile,
      this.coverUrl,
      this.profileUrl,
      this.following = 0,
      this.followers = 0,
      this.posts = 0,
      this.isVerify = false,
      this.website});
}
