import 'package:Speak2Note/models/recording_model.dart';
import 'package:flutter/material.dart';

class EventValueNotifier extends ValueNotifier {
  EventValueNotifier(super.value);

  void eventChange(Map<DateTime, List<RecordingModel>>? e,) {
    value = e;
  }
}