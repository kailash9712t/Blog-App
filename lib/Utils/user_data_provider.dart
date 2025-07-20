import 'package:blog/Models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/web.dart';

class UserDataProvider {
  static final UserDataProvider instance = UserDataProvider.internal();

  UserModel userModel = UserModel();

  final Logger logs = Logger(
    level: kReleaseMode ? Level.off : Level.debug,
    printer: PrettyPrinter(methodCount: 1, colors: true),
  );

  UserDataProvider.internal() {
    logs.i("private constructor call");
  }

  factory UserDataProvider() => instance;
}
