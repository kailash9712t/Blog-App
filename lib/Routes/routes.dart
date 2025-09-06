import 'package:blog/Models/BlogPost/post.dart';
import 'package:blog/Pages/Auth/EmailVerification/UI/email_verification.dart';
import 'package:blog/Pages/Auth/Login/Ui/login.dart';
import 'package:blog/Pages/Auth/ProfileSetUp/UI/profile_set.dart';
import 'package:blog/Pages/Auth/ProfileSetUp1/UI/profile_set_up1.dart';
import 'package:blog/Pages/Auth/Register/Ui/register.dart';
import 'package:blog/Pages/Followers/UI/followers.dart';
import 'package:blog/Pages/Home/UI/home.dart';
import 'package:blog/Pages/Loading/UI/loading.dart';
import 'package:blog/Pages/Posts/UI/post.dart';
import 'package:blog/Pages/User/UI/user.dart';
import 'package:go_router/go_router.dart';

GoRouter route = GoRouter(
  routes: [
    GoRoute(path: "/login", builder: (cotext, state) => LoginPage()),
    GoRoute(path: "/register", builder: (context, state) => RegisterPage()),
    GoRoute(path: "/home", builder: (context, state) => BlogHomeScreen()),
    GoRoute(
      path: "/userProfile",
      builder: (context, state) {
        String? username = state.uri.queryParameters["username"];
        String? isUserProfile = state.uri.queryParameters["isUserProfile"];

        return UserProfilePage(
          username: username!,
          isUserProfile: bool.parse(isUserProfile!),
        );
      },
    ),
    GoRoute(
      path: "/profileSetUp",
      builder: (context, state) => ProfileSetupPage(),
    ),
    GoRoute(
        path: "/profileSetUp1",
        builder: (context, state) {
          bool editPage = bool.parse(state.uri.queryParameters["editPage"]!);
          return ProfilePage(editPage: editPage);
        }),
    GoRoute(
      path: "/emailVerification",
      builder: (context, state) =>
          EmailVerificationPage(email: state.uri.queryParameters['email']),
    ),
    GoRoute(path: "/", builder: (context, state) => LoadingPage()),
    GoRoute(
        path: "/posts",
        builder: (context, state) {
          final userPost = state.extra as BlogPost;
          return TweetDetailPage(
            post: userPost,
          );
        }),
    GoRoute(
        path: "/Following",
        builder: (context, state) =>
            FollowersPage(username: "kailash9712t", followersCount: 10)),
  ],
);
