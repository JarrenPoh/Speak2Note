import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Speak2Note/globals/dimension.dart';
import 'package:Speak2Note/globals/medium_text.dart';
import 'package:Speak2Note/globals/regular_text.dart';

Future CustomDialog(
    context, title, content, color_title, color_content, onPress) {
  return showDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: RegularText(
          color: color_title,
          size: Dimensions.height2 * 6,
          text: '',
        ),
        content: MediumText(
          color: color_content,
          size: Dimensions.height2 * 8,
          text: content,
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: MediumText(
              color: Colors.blueAccent,
              size: Dimensions.height2 * 8,
              text: '取消',
            ),
          ),
          CupertinoDialogAction(
            onPressed: () => onPress(),
            child: MediumText(
              color: Colors.redAccent,
              size: Dimensions.height2 * 8,
              text: '確定',
            ),
          ),
        ],
      );
    },
  );
}
