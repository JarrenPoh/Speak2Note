import 'package:flutter/cupertino.dart';
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
      body: Container(
        height: Dimensions.screenHeight,
        width: Dimensions.screenWidth,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(255, 255, 255, 1),
              Color.fromRGBO(191, 191, 191, 1),
              Color.fromRGBO(101, 101, 101, 1),
              Color.fromRGBO(52, 52, 52, 1),
              Color.fromRGBO(19, 19, 19, 1),
            ],
          ),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome!',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: Dimensions.height5 * 9,
                  ),
                ),
                SizedBox(height: Dimensions.height5 * 10),
                CupertinoButton(
                  onPressed: () async {
                    await FirebaseAPI().signInWithApple();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: Dimensions.height5 * 1.5),
                    margin:
                        EdgeInsets.symmetric(horizontal: Dimensions.width5 * 2),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 3),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.apple,
                          color: Colors.white,
                          size: Dimensions.height5 * 9,
                        ),
                        SizedBox(width: Dimensions.width5),
                        Text(
                          'Apple Sign In',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: Dimensions.height5 * 5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: EdgeInsets.only(
                  bottom: Dimensions.height5 * 8,
                  right: Dimensions.width5 * 4,
                ),
                child: Text(
                  'Speak2Note',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: Dimensions.height5 * 3,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
