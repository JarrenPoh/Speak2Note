import 'package:flutter/material.dart';

class MediumText extends StatelessWidget {
  final Color color;
  final double size;
  final int? maxLines;
  final String text;
  const MediumText({
    super.key,
    required this.color,
    this.maxLines,
    required this.size,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: size,
        color: color,
        fontFamily: "NotoSansMedium",
      ),
    );
  }
}
