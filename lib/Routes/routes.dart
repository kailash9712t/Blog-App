import 'package:blog/Pages/Auth/Login/Ui/ui.dart';
import 'package:blog/Pages/Auth/Register/Ui/ui.dart';
import 'package:blog/Pages/Home/UI/ui.dart';
import 'package:blog/Pages/User/UI/ui.dart';
import 'package:go_router/go_router.dart';

GoRouter route = GoRouter(routes: [
  GoRoute(path: "/",builder: (cotext,state) => LoginPage()),
  GoRoute(path: "/register", builder: (context,state) => RegisterPage()),
  GoRoute(path: "/home", builder: (context,state) => BlogHomeScreen()),
  GoRoute(path: "/userProfile", builder: (context,state) => UserProfilePage()),
]);
