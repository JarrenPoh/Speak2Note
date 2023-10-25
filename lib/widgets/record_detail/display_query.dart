import 'package:Speak2Note/globals/dimension.dart';
import 'package:Speak2Note/providers/record_detail/whisper_article_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DisplayQuery extends StatefulWidget {
  final WhisperArticleBloc bloc;
  final List<int> queryList;
  const DisplayQuery({
    super.key,
    required this.queryList,
    required this.bloc,
  });

  @override
  State<DisplayQuery> createState() => _DisplayQueryState();
}

class _DisplayQueryState extends State<DisplayQuery> {
  int queryIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 40,
        color: Color.fromARGB(255, 86, 86, 86),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(width: Dimensions.width5 * 3),
            Text(
              '${(queryIndex + 1)} of ${widget.queryList.length}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Expanded(child: Column(children: [])),
            IconButton(
              icon: Icon(CupertinoIcons.chevron_up),
              onPressed: () {
                setState(() {
                  if (queryIndex == 0) {
                    queryIndex = widget.queryList.length - 1;
                  } else {
                    queryIndex--;
                  }
                  widget.bloc
                      .scrollToHeight(widget.queryList[queryIndex], Dimensions.height5 * 15);
                });
              },
              color: Colors.white,
            ),
            IconButton(
              icon: Icon(CupertinoIcons.chevron_down),
              onPressed: () {
                setState(() {
                  if (queryIndex == widget.queryList.length - 1) {
                    queryIndex = 0;
                  } else {
                    queryIndex++;
                  }
                  widget.bloc
                      .scrollToHeight(widget.queryList[queryIndex], Dimensions.height5 * 15);
                });
              },
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
