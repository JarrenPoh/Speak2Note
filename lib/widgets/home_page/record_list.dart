import 'package:Speak2Note/API/firebase_api.dart';
import 'package:Speak2Note/globals/format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Speak2Note/globals/dimension.dart';
import 'package:Speak2Note/models/recording_model.dart';
import 'package:Speak2Note/providers/home_page/home_page_bloc.dart';
import 'package:Speak2Note/widgets/record_detail/record_detail.dart';
import 'package:Speak2Note/globals/global_key.dart' as globals;

class RecordList extends StatefulWidget {
  final HomePageBloc bloc;
  RecordList({
    Key? key,
    required this.bloc,
  }) : super(key: globals.globalRecordList ?? key);

  @override
  State<RecordList> createState() => RecordListState();
}

class RecordListState extends State<RecordList> {
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
    Color onSecondaryColor = Theme.of(context).colorScheme.onSecondary;
    Color firstColor = Theme.of(context).colorScheme.primary;
    Color secondColor = Theme.of(context).colorScheme.secondary;
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
                          query: '',
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
                      border: Border.all(color: secondColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _list[index].time,
                              style: TextStyle(color: onSecondaryColor),
                              maxLines: 4,
                            ),
                            GestureDetector(
                              onTap: () {
                                showPopup(_list[index].recordingID);
                              },
                              child: Icon(
                                Icons.keyboard_control,
                                color: firstColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Dimensions.height5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              _list[index].title == ''
                                  ? '無'
                                  : _list[index].title,
                              style: TextStyle(
                                  color: onSecondaryColor, fontSize: 16),
                            ),
                            Expanded(child: Column(children: [])),
                            Icon(
                              Icons.timer_outlined,
                              color: secondColor,
                              size: Dimensions.height2 * 11,
                            ),
                            Text(
                              ' ${secondToTime(_list[index].duration)}',
                              style: TextStyle(
                                color: secondColor,
                                fontSize: Dimensions.height2 * 8,
                              ),
                            ),
                          ],
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

  showAlert(String recordingID) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('刪除錄音'),
          content: const Text(
            '點擊確定將永久刪除',
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text(
                '取消',
                style: TextStyle(
                  color: Colors.black26,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            CupertinoDialogAction(
              child: Text(
                '刪除',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                FirebaseAPI().deleteRecording(recordingID);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  showEdit(String recordingID) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        TextEditingController controller = TextEditingController();
        return CupertinoAlertDialog(
          title: const Text('更改標題'),
          content: CupertinoTextField(
            controller: controller,
            autofocus: true,
            cursorColor: Color.fromARGB(255, 86, 86, 86),
            style: TextStyle(color: Color.fromARGB(255, 86, 86, 86)),
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text(
                '取消',
                style: TextStyle(
                  color: Colors.black26,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            CupertinoDialogAction(
              child: Text(
                '更改',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                FirebaseAPI().updateTitle(recordingID, controller.text);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  showPopup(String recordingID) {
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
              showEdit(recordingID);
            },
            child: const Text(
              '更改標題',
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              showAlert(recordingID);
            },
            child: const Text(
              '刪除',
              style: TextStyle(
                color: Colors.redAccent,
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
