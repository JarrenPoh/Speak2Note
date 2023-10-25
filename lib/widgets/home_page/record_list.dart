import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Speak2Note/globals/dimension.dart';
import 'package:Speak2Note/models/recording_model.dart';
import 'package:Speak2Note/providers/home_page/home_page_bloc.dart';
import 'package:Speak2Note/widgets/record_detail/record_detail.dart';

class RecordList extends StatefulWidget {
  final HomePageBloc bloc;
  const RecordList({
    super.key,
    required this.bloc,
  });

  @override
  State<RecordList> createState() => _RecordListState();
}

class _RecordListState extends State<RecordList> {
  List<RecordingModel> _list = [];
  @override
  void initState() {
    super.initState();
    DateTime _now = DateTime.now();
    _list = widget.bloc.events[DateTime.utc(
          _now.year,
          _now.month,
          _now.day,
        )] ??
        [];
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.bloc.recordListBloc.recordingListNotifier,
      builder: (context, value, child) {
        value as Map;
        bool _done = value['done'];
        if (!_done) {
          return Container(
            margin: EdgeInsets.only(top: Dimensions.height5 * 25),
            child: CircularProgressIndicator.adaptive(),
          );
        } else {
          _list = value['list'];
          return Column(
            children: List.generate(
              _list.length,
              (index) {
                return CupertinoButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecordDetail(
                          detail: _list[index],
                          recordListBloc: widget.bloc.recordListBloc,
                          query:'',
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
                      horizontal: Dimensions.width5 * 0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _list[index].title,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        SizedBox(height: Dimensions.height5),
                        Text(
                          '無',
                          style: TextStyle(color: Colors.grey.shade600),
                          maxLines: 4,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
