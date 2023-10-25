import 'package:flutter/material.dart';
import 'package:Speak2Note/API/firebase_api.dart';
import 'package:Speak2Note/globals/dimension.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () async {
            await FirebaseAPI().signInWithApple();
          },
          child: Container(
            padding: EdgeInsets.all(Dimensions.height5 * 2),
            child: Icon(
              Icons.apple,
              color: Colors.black54,
              size: Dimensions.height5 * 9,
            ),
          ),
        ),
      ),
    );
  }
}
