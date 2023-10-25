import 'package:Speak2Note/API/firebase_api.dart';
import 'package:Speak2Note/providers/home_page/record_list_bloc.dart';
import 'package:Speak2Note/valueNotifier/event_value.notifier.dart';
import 'package:flutter/material.dart';
import 'package:Speak2Note/models/recording_model.dart';

class HomePageBloc extends ChangeNotifier {
  EventValueNotifier eventValueNotifier = EventValueNotifier(null);
  DateTime focusedDay = DateTime.now();
  Map<DateTime, List<RecordingModel>> events = {};
  RecordListBloc recordListBloc = RecordListBloc();

  Future getEvents() async {
    List list = await FirebaseAPI().fetchAllRecodings();
    events = RecordingModel.toEvent(list);
    eventValueNotifier.eventChange(events);
    recordListBloc.onDaySelected(
      events[DateTime.utc(
        focusedDay.year,
        focusedDay.month,
        focusedDay.day,
      )],
      true,
    );
  }
}
