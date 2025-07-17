class UserModel {
  String username;
  String? displayName;
  String email;
  String password;
  String joiningDate;
  String? bio;
  String? location;
  bool completeProfile;

  UserModel({
    required this.username,
    this.displayName,
    required this.email,
    required this.password,
    required this.joiningDate,
    this.bio,
    this.location,
    required this.completeProfile,
  });
}
