import 'package:Speak2Note/models/recording_model.dart';
import 'package:Speak2Note/valueNotifier/recoding_list_notifier.dart';
import 'package:flutter/material.dart';

class RecordListBloc extends ChangeNotifier {
  RecordingListValueNotifier recordingListNotifier =
      RecordingListValueNotifier({"list": [], "done": false});

  void onDaySelected(List<RecordingModel>? _list, bool done) {
    recordingListNotifier.recordingListChange(_list ?? [], true);
  }
}
