import 'package:blog/Pages/Auth/Login/Ui/login.dart';
import 'package:blog/Pages/Auth/ProfileSetUp/UI/profile_set.dart';
import 'package:blog/Pages/Auth/ProfileSetUp1/UI/profile_set_up1.dart';
import 'package:blog/Pages/Auth/Register/Ui/register.dart';
import 'package:blog/Pages/Home/UI/home.dart';
import 'package:blog/Pages/User/UI/User.dart';
import 'package:go_router/go_router.dart';

GoRouter route = GoRouter(routes: [
  GoRoute(path: "/main",builder: (cotext,state) => LoginPage()),
  GoRoute(path: "/register", builder: (context,state) => RegisterPage()),
  GoRoute(path: "/home", builder: (context,state) => BlogHomeScreen()),
  GoRoute(path: "/userProfile", builder: (context,state) => UserProfilePage()),
  GoRoute(path: "/profileSetUp", builder: (context,state) => ProfileSetupPage()),
  GoRoute(path: "/", builder: (context,state) => ProfileEditPage())
]);
