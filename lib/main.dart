import 'package:blog/Models/Hive_Model/UserData/user.dart';
import 'package:blog/Models/User/user_profile.dart';
import 'package:blog/Pages/Auth/EmailVerification/State/email_verification.dart';
import 'package:blog/Pages/Auth/Login/State/login.dart';
import 'package:blog/Pages/Auth/ProfileSetUp/State/profile_set.dart';
import 'package:blog/Pages/Auth/ProfileSetUp1/State/profile_set_up1.dart';
import 'package:blog/Pages/Auth/Register/State/register.dart';
import 'package:blog/Pages/Home/State/home.dart';
import 'package:blog/Pages/User/State/user.dart';
import 'package:blog/Routes/routes.dart';
import 'package:blog/Utils/user_data_provider.dart';
import 'package:blog/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final dir = await getApplicationDocumentsDirectory();

  Hive.init(dir.path);
  Hive.registerAdapter(UserModelAdapter());

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserDataProvider()),
        ChangeNotifierProvider(create: (context) => LoginPageModel()),
        ChangeNotifierProvider(create: (context) => RegisterModel()),
        ChangeNotifierProvider(create: (context) => ProfileSetModel()),
        ChangeNotifierProvider(create: (context) => ProfileSetUp1()),
        ChangeNotifierProvider(create: (context) => EmailVerificationModel()),
        ChangeNotifierProvider(create: (context) => UserPageModel()),
        ChangeNotifierProvider(create: (context) => HomePageModel()),
        ChangeNotifierProvider(create: (context) => UserProfileState())
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
