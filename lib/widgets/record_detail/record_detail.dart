import 'package:Speak2Note/providers/home_page/record_list_bloc.dart';
import 'package:Speak2Note/providers/record_detail/whisper_article_bloc.dart';
import 'package:Speak2Note/widgets/SearchWidget.dart';
import 'package:Speak2Note/widgets/record_detail/audio_slider.dart';
import 'package:Speak2Note/widgets/record_detail/whisper_article.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Speak2Note/globals/dimension.dart';
import 'package:Speak2Note/models/recording_model.dart';

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
    super.build(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onVerticalDragDown: (details) {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color.fromARGB(255, 86, 86, 86),
          title: SearchWidget(
            text: widget.query,
            hintText: '搜尋你想搜尋的內容',
            onChanged: (s) {
              if (s.runes.every((rune) =>
                      (rune >= 0x4e00 && rune <= 0x9fff) || rune == 0x3002) ||
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
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                toolbarHeight: Dimensions.height5 * 8,
                title: Text(
                  widget.detail.title,
                  style: TextStyle(fontSize: Dimensions.height2 * 9),
                ),
                automaticallyImplyLeading: false, //隱藏drawer預設icon
                backgroundColor: Color.fromARGB(255, 86, 86, 86),
                centerTitle: true,
                pinned: true,
                elevation: 0,
              ),
            ];
          },
          body: WhisperArticle(
            detail: widget.detail,
            recordListBloc: widget.recordListBloc,
            whisperBloc: whisperBloc,
            query: widget.query,
          ),
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
}
