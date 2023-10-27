import 'dart:async';
import 'package:Speak2Note/globals/dimension.dart';
import 'package:Speak2Note/models/recording_model.dart';
import 'package:Speak2Note/models/whisperMap.dart';
import 'package:Speak2Note/providers/home_page/record_list_bloc.dart';
import 'package:Speak2Note/widgets/SearchWidget.dart';
import 'package:Speak2Note/widgets/record_detail/record_detail.dart';
import 'package:flutter/material.dart';

class CustomSearchPage extends StatefulWidget {
  final List<RecordingModel> recordings;
  final RecordListBloc recordListBloc;
  const CustomSearchPage({
    super.key,
    required this.recordings,
    required this.recordListBloc,
  });

  @override
  State<CustomSearchPage> createState() => _CustomSearchPageState();
}

class _CustomSearchPageState extends State<CustomSearchPage>
    with AutomaticKeepAliveClientMixin {
  @override
  final bool wantKeepAlive = true;
  @override
  void initState() {
    super.initState();
  }

  Timer? debouncer;
  String query = '';
  List<RecordingModel> books = [];
  void debounce(VoidCallback callback,
      {Duration duration = const Duration(microseconds: 500)}) {
    if (debouncer != null) {
      debouncer!.cancel();
    }
    debouncer = Timer(duration, callback);
  }

  void searchBook(String query) {
    if (query.runes.every(
            (rune) => (rune >= 0x4e00 && rune <= 0x9fff) || rune == 0x3002) ||
        query == '') {
      if (query != '') {
        return debounce(() async {
          print('search for:$query');
          List<RecordingModel> book = widget.recordings.where((e) {
            if (e.whisperSegments == null) {
              return false;
            }
            for (WhisperSegment segment in e.whisperSegments!) {
              if (segment.text!.contains(query)) {
                return true;
              }
            }
            return false;
          }).toList();

          setState(() {
            this.query = query;
            this.books = book;
          });
        });
      }
    }
  }

  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
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
          title: SearchWidget(
            text: query,
            hintText: '輸入想搜尋的內容或標題',
            onChanged: searchBook,
            autoFocus: true,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: Dimensions.height5 * 2),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: books.length,
                  itemBuilder: ((context, index) {
                    RecordingModel model = books[index];
                    List<String> display = extractContext(model, query);
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecordDetail(
                              detail: model,
                              recordListBloc: widget.recordListBloc,
                              query: query,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: Dimensions.screenWidth,
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.width5 * 3,
                          vertical: Dimensions.height5 * 3,
                        ),
                        margin: EdgeInsets.symmetric(
                            horizontal: Dimensions.width5 * 2,
                            vertical: Dimensions.height5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black26),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              model.title,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                            SizedBox(height: Dimensions.height5),
                            ListTile(
                              title: RichText(
                                text: TextSpan(
                                  children: display.fold<List<InlineSpan>>([],
                                      (previousValue, str) {
                                    if (str.contains(query)) {
                                      int index = 0;
                                      List<InlineSpan> spans = [];
                                      while (index < str.length) {
                                        int start = str.indexOf(query, index);
                                        if (start == -1) {
                                          spans.add(TextSpan(
                                            text: str.substring(index),
                                            style: TextStyle(
                                              backgroundColor: Colors.white,
                                              color: Colors.black,
                                            ),
                                          ));
                                          break;
                                        } else {
                                          if (start > index) {
                                            spans.add(TextSpan(
                                              text: str.substring(index, start),
                                              style: TextStyle(
                                                backgroundColor: Colors.white,
                                                color: Colors.black,
                                              ),
                                            ));
                                          }
                                          int end = start + query.length;
                                          spans.add(TextSpan(
                                            text: str.substring(start, end),
                                            style: TextStyle(
                                              backgroundColor: Colors.blueAccent
                                                  .withOpacity(0.5),
                                              color: Colors.black,
                                            ),
                                          ));
                                          index = end;
                                        }
                                      }
                                      previousValue.addAll(spans);
                                    } else {
                                      previousValue.add(TextSpan(
                                        text: str,
                                        style: TextStyle(
                                          backgroundColor: Colors.white,
                                          color: Colors.black,
                                        ),
                                      ));
                                    }
                                    return previousValue;
                                  }),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> extractContext(RecordingModel recording, String query) {
    List<String> context = [];
    for (WhisperSegment segment in recording.whisperSegments!) {
      if (segment.text!.contains(query)) {
        int segmentIndex = recording.whisperSegments!.indexOf(segment);
        context.add(recording.whisperSegments![segmentIndex].text! + '\n');
      }
    }
    return context;
  }
}
