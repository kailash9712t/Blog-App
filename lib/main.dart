import 'package:blog/Pages/Auth/EmailVerification/State/email_verification.dart';
import 'package:blog/Pages/Auth/EmailVerification/UI/email_verification.dart';
import 'package:blog/Pages/Auth/Login/State/login.dart';
import 'package:blog/Pages/Auth/ProfileSetUp/State/profile_set.dart';
import 'package:blog/Pages/Auth/ProfileSetUp1/State/profile_set_up1.dart';
import 'package:blog/Pages/Auth/Register/State/register.dart';
import 'package:blog/Routes/routes.dart';
import 'package:blog/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginPageModel()),
        ChangeNotifierProvider(create: (context) => RegisterModel()),
        ChangeNotifierProvider(create: (context) => ProfileSetModel()),
        ChangeNotifierProvider(create: (context) => ProfileSetUp1()),
        ChangeNotifierProvider(create: (context) => EmailVerificationModel()),

      ],
      child: MaterialApp.router(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        routerConfig: route,
      ),
    );
  }
}
