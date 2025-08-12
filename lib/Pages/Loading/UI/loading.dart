import 'package:blog/Utils/user_data_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  Logger logs = Logger(
    level: kReleaseMode ? Level.off : Level.debug,
    printer: PrettyPrinter(methodCount: 1, colors: true),
  );

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initialTask();
    });
    super.initState();
  }

  void initialTask() async {
    User? user = auth.currentUser;

    if (user == null || !user.emailVerified) {
      context.go("/login");
    } else {
      await context.read<UserDataProvider>().loadDataFromLocalDatabase();
      if (!mounted) return;
      context.go("/home");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("This is Loading Page")));
  }
}
