import 'package:flutter/material.dart';
import 'package:Speak2Note/models/recording_model.dart';

class RecordingListValueNotifier extends ValueNotifier {
  RecordingListValueNotifier(super.value);

  void recordingListChange(List<RecordingModel> list, bool isLoading) {
    value = {
      "list": list,
      "done": isLoading,
    };
  }
}
