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
    Color appBarColor = Theme.of(context).appBarTheme.backgroundColor!;
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    Color firstColor = Theme.of(context).colorScheme.primary;
    Color scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    pages = [
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'S2N',
          baseStyle: TextStyle(fontWeight: FontWeight.w600, color: onSecondary),
          selectedStyle: TextStyle(color: onSecondary),
          colorLineSelected: firstColor,
        ),
        NavigationContainer(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: '登出',
          baseStyle: TextStyle(fontWeight: FontWeight.bold, color: onSecondary),
          selectedStyle: TextStyle(color: onSecondary),
          colorLineSelected: firstColor,
        ),
        Center(
          child: CupertinoButton(
            child: Text(
              '點擊登出',
              style: TextStyle(color: firstColor),
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
      backgroundColorAppBar: appBarColor,
      backgroundColorMenu: onPrimary,
      backgroundColorContent: scaffoldBackgroundColor,
      screens: pages,
      slidePercent: 40,
      contentCornerRadius: 40,
      styleAutoTittleName: TextStyle(color: onSecondary,fontWeight: FontWeight.bold),
      leadingAppBar: Icon(Icons.menu, color: onSecondary),
    );
  }
}
