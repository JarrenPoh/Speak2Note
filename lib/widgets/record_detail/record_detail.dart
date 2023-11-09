import 'dart:io';

import 'package:Speak2Note/globals/format.dart';
import 'package:Speak2Note/providers/home_page/record_list_bloc.dart';
import 'package:Speak2Note/providers/record_detail/whisper_article_bloc.dart';
import 'package:Speak2Note/widgets/SearchWidget.dart';
import 'package:Speak2Note/widgets/record_detail/audio_slider.dart';
import 'package:Speak2Note/widgets/record_detail/whisper_article.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Speak2Note/globals/dimension.dart';
import 'package:Speak2Note/models/recording_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class RecordDetail extends StatefulWidget {
  final RecordingModel detail;
  final RecordListBloc recordListBloc;
  final String query;
  const RecordDetail({
    super.key,
    required this.detail,
    required this.recordListBloc,
    required this.query,
  });

  @override
  State<RecordDetail> createState() => _RecordDetailState();
}

class _RecordDetailState extends State<RecordDetail>
    with AutomaticKeepAliveClientMixin {
  @override
  final bool wantKeepAlive = true;
  final WhisperArticleBloc whisperBloc = WhisperArticleBloc();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color appBarColor = Theme.of(context).appBarTheme.backgroundColor!;
    super.build(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onVerticalDragDown: (details) {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: Dimensions.height5 * 20,
          automaticallyImplyLeading: false,
          backgroundColor: appBarColor,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.navigate_before_rounded,
                      size: Dimensions.height2 * 20,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: Dimensions.width5 * 2),
                  Expanded(
                    child: SearchWidget(
                      text: widget.query,
                      hintText: '搜尋你想搜尋的內容',
                      onChanged: (s) {
                        if (s.runes.every((rune) =>
                                (rune >= 0x4e00 && rune <= 0x9fff) ||
                                rune == 0x3002) ||
                            s == '') {
                          whisperBloc.whisperMotifier.mapChange(
                            widget.detail.whisperSegments ?? [],
                            true,
                            s,
                          );
                        }
                      },
                      autoFocus: false,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showPopup(widget.detail);
                    },
                    child: Icon(
                      Icons.more_vert,
                      size: Dimensions.height2 * 15,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(bottom: Dimensions.height2 * 6),
                child: Text(
                  widget.detail.title,
                  style: TextStyle(
                    fontSize: Dimensions.height2 * 9,
                    color: Colors.grey[200],
                  ),
                ),
              ),
            ],
          ),
        ),
        body: WhisperArticle(
          detail: widget.detail,
          recordListBloc: widget.recordListBloc,
          whisperBloc: whisperBloc,
          query: widget.query,
        ),
        bottomNavigationBar: Container(
          height: Dimensions.height5 * 30,
          child: AudioSlider(
            audioUrl: widget.detail.audioUrl,
          ),
        ),
      ),
    );
  }

  shareTextFile(RecordingModel detail) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/${detail.title}.txt');
    String article = '';
    if (detail.whisperSegments!.isEmpty || detail.whisperSegments == null) {
      article = "無";
    } else {
      for (var i = 0; i < detail.whisperSegments!.length; i++) {
        article +=
            '# ${formatTimeRange(detail.whisperSegments![i].start.toInt(), detail.whisperSegments![i].end.toInt())}'
            "\n";
        article += "${detail.whisperSegments![i].text}" "\n\n";
      }
    }

    await file.writeAsString(article);

    final result =
        await Share.shareXFiles([XFile(file.path)], text: 'Great picture');

    if (result.status == ShareResultStatus.success) {
      print('Thank you for sharing the picture!');
    }

    await file.delete();
  }

  showPopup(RecordingModel detail) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text('功能選單'),
        message: Text('如果你還想要我們為您增添其他功能，歡迎聯絡官方'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
              shareTextFile(detail);
            },
            child: const Text(
              '分享文檔',
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            '返回',
            style: TextStyle(
              color: Colors.black26,
            ),
          ),
        ),
      ),
    );
  }
}
