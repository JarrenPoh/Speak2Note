import 'package:Speak2Note/globals/dark_theme.dart';
import 'package:Speak2Note/globals/light_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Speak2Note/hidden_drawer_screen.dart';
import 'package:Speak2Note/pages/login_page.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:Speak2Note/globals/global_key.dart' as globals;

Future<void> main() async {
  await Future.delayed(Duration(seconds: 2));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Permission.microphone.request();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      // navigatorKey:  globals.appNavigator,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else if (snapshot.hasData) {
            return const HiddenDrawerScreen();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
