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
            color: Colors.black45.withOpacity(0.25),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '# ${formatTimeRange(widget.segments[widget.index].start.toInt(),widget.segments[widget.index].end.toInt())}',
          ),
        ),
        SizedBox(height: Dimensions.height2),
        RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 15),
            children: widget.textSpans,
          ),
        ),
        SizedBox(height: Dimensions.height5),
        Divider(),
      ],
    );
  }

  List<TextSpan> miggrateTextspan(
    String text,
    String query,
  ) {
    int index = text.indexOf(query);
    List<TextSpan> textSpans = [];

    if (index != -1) {
      textSpans.add(
        TextSpan(
          text: text.substring(0, index),
          style: TextStyle(color: Colors.black),
        ),
      );
      textSpans.add(
        TextSpan(
          text: query,
          style: TextStyle(
            backgroundColor: Colors.blueAccent.withOpacity(0.5),
            color: Colors.black,
          ),
        ),
      );
      textSpans.add(
        TextSpan(
          text: text.substring(index + query.length),
          style: TextStyle(color: Colors.black),
        ),
      );
    } else {
      // If query is not found in text, display the entire text as white.
      textSpans.add(
        TextSpan(
          text: text,
          style: TextStyle(color: Colors.black),
        ),
      );
    }
    return textSpans;
  }
}
