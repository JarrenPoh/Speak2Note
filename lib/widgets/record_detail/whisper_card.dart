import 'package:Speak2Note/globals/dimension.dart';
import 'package:Speak2Note/globals/format.dart';
import 'package:Speak2Note/models/whisperMap.dart';
import 'package:flutter/material.dart';

class WhisperCard extends StatefulWidget {
  final List<TextSpan> textSpans;
  final List<WhisperSegment> segments;
  final int index;
  const WhisperCard({
    Key? key,
    required this.segments,
    required this.textSpans,
    required this.index,
  }) : super(key: key);

  @override
  State<WhisperCard> createState() => WhisperCardState();
}

class WhisperCardState extends State<WhisperCard> {
  bool callbackCalled = false;
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   print('finished');
    //   widget.bloc.catchRenderBox(widget.index);
    // });
  }

  @override
  Widget build(BuildContext context) {
    Color firstColor = Theme.of(context).colorScheme.primary;
    Color onSecondaryColor = Theme.of(context).colorScheme.onSecondary;
    Color thirdColor = Theme.of(context).colorScheme.tertiary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: Dimensions.height5 * 2),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.width5,
            vertical: Dimensions.height2,
          ),
          decoration: BoxDecoration(
            color: firstColor.withOpacity(0.25),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '# ${formatTimeRange(widget.segments[widget.index].start.toInt(), widget.segments[widget.index].end.toInt())}',
            style: TextStyle(color: firstColor),
          ),
        ),
        SizedBox(height: Dimensions.height2),
        RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 15,color: onSecondaryColor),
            children: widget.textSpans,
          ),
        ),
        SizedBox(height: Dimensions.height5),
        Divider(color: thirdColor),
      ],
    );
  }

  
}
