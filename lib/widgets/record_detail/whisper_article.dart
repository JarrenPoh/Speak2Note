import 'package:Speak2Note/globals/dimension.dart';
import 'package:Speak2Note/models/recording_model.dart';
import 'package:Speak2Note/models/whisperMap.dart';
import 'package:Speak2Note/providers/home_page/record_list_bloc.dart';
import 'package:Speak2Note/providers/record_detail/whisper_article_bloc.dart';
import 'package:Speak2Note/widgets/record_detail/display_query.dart';
import 'package:Speak2Note/widgets/record_detail/whisper_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WhisperArticle extends StatefulWidget {
  final RecordingModel detail;
  final RecordListBloc recordListBloc;
  final WhisperArticleBloc whisperBloc;
  final String query;
  const WhisperArticle({
    super.key,
    required this.detail,
    required this.recordListBloc,
    required this.whisperBloc,
    required this.query,
  });

  @override
  State<WhisperArticle> createState() => _WhisperArticleState();
}

class _WhisperArticleState extends State<WhisperArticle> {
  List<WhisperSegment> _segments = [];
  bool _done = true;
  List<int> queryList = [];

  addQueryIndex(int index) {
    queryList.add(index);
  }

  @override
  void initState() {
    super.initState();
    _segments = widget.detail.whisperSegments ?? [];
    var i =
        _segments.indexWhere((element) => element.text!.contains(widget.query));
    if (widget.query != '') {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        widget.whisperBloc.scrollToHeight(i, Dimensions.height5 * 15);
      });
    }
    widget.whisperBloc.whisperMotifier.value['query'] = widget.query;
  }

  GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Color secondColor = Theme.of(context).colorScheme.secondary;
    Color onSecondaryColor = Theme.of(context).colorScheme.onSecondary;
    return ValueListenableBuilder(
      valueListenable: widget.whisperBloc.whisperMotifier,
      builder: (context, value, child) {
        value as Map;
        if (_segments.isEmpty) {
          _segments = value['body'] ?? [];
          _done = value['done'];
        }
        String _query = value['query'];
        queryList = [];
        //whisper轉錄內容
        if (_segments.isNotEmpty) {
          return Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width5 * 4,
                ),
                child: SingleChildScrollView(
                  controller: widget.whisperBloc.scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      _segments.length,
                      (index) {
                        List<TextSpan> _textSpans = miggrateTextspan(
                          _segments[index].text!,
                          _query,
                        );
                        if (_segments[index].text!.contains(_query)) {
                          addQueryIndex(index);
                        }
                        // widget.whisperBloc.whisperCardBloc
                        //     .createKey(_segments.length);

                        return WhisperCard(
                          // key: widget.whisperBloc.whisperCardBloc.cardKeyList[index],
                          segments: _segments,
                          textSpans: _textSpans,
                          index: index,
                        );
                      },
                    ),
                  ),
                ),
              ),
              if (queryList.isNotEmpty && _query != '')
                DisplayQuery(queryList: queryList, bloc: widget.whisperBloc),
            ],
          );
        }
        //正在轉錄中
        if (!_done) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        //轉錄按鍵
        if (_done && _segments.isEmpty) {
          return Center(
            child: CupertinoButton(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width5 * 3,
                  vertical: Dimensions.height5 * 2,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: secondColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '生成文字',
                  style: TextStyle(color: onSecondaryColor, fontSize: 16),
                ),
              ),
              onPressed: () async {
                await widget.whisperBloc.callWhisperApi(
                  widget.detail,
                  widget.whisperBloc.language,
                  widget.detail.recordingID,
                  widget.recordListBloc,
                );
              },
            ),
          );
        }
        return Container();
      },
    );
  }

  List<TextSpan> miggrateTextspan(
    String text,
    String query,
  ) {
    Color onSecondaryColor = Theme.of(context).colorScheme.onSecondary;
    int i = text.indexOf(query);
    List<TextSpan> textSpans = [];

    if (i != -1) {
      textSpans.add(
        TextSpan(
          text: text.substring(0, i),
          style: TextStyle(color: onSecondaryColor),
        ),
      );
      textSpans.add(
        TextSpan(
          text: query,
          style: TextStyle(
            backgroundColor: Colors.blueAccent.withOpacity(0.5),
            color: onSecondaryColor,
          ),
        ),
      );
      textSpans.add(
        TextSpan(
          text: text.substring(i + query.length),
          style: TextStyle(color: onSecondaryColor),
        ),
      );
    } else {
      // If query is not found in text, display the entire text as white.
      textSpans.add(
        TextSpan(
          text: text,
          style: TextStyle(color: onSecondaryColor),
        ),
      );
    }
    return textSpans;
  }
}
