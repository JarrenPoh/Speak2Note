import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:Speak2Note/API/firebase_api.dart';
import 'package:Speak2Note/navigation_container.dart';
import 'package:Speak2Note/widgets/custom_dialog.dart';

class HiddenDrawerScreen extends StatefulWidget {
  const HiddenDrawerScreen({super.key});

  @override
  State<HiddenDrawerScreen> createState() => _HiddenDrawerScreenState();
}

class _HiddenDrawerScreenState extends State<HiddenDrawerScreen> {
  List<ScreenHiddenDrawer> pages = [];
  @override
  Widget build(BuildContext context) {
    pages = [
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Speak2Note',
          baseStyle: TextStyle(),
          selectedStyle: TextStyle(),
          colorLineSelected: Colors.black54,
        ),
        NavigationContainer(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: '登出',
          baseStyle: TextStyle(),
          selectedStyle: TextStyle(),
          colorLineSelected: Colors.black54,
        ),
        Center(
          child: CupertinoButton(
            child: const Text(
              '點擊登出',
              style: TextStyle(color: Colors.black54),
            ),
            onPressed: () async {
              await CustomDialog(
                context,
                '要登出按確定',
                '你確定要登出當前帳號嗎',
                Colors.black,
                Colors.black54,
                () async {
                  Navigator.pop(context);
                  await FirebaseAPI().signOut();
                },
              );
            },
          ),
        ),
      ),
    ];
    return HiddenDrawerMenu(
      elevationAppBar: 0,
      withShadow: false,
      actionsAppBar: [],
      backgroundColorAppBar: Color.fromARGB(255, 86, 86, 86),
      backgroundColorMenu: Colors.white,
      screens: pages,
      slidePercent: 40,
      contentCornerRadius: 40,
    );
  }
}
