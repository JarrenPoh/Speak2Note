import 'dart:async';
import 'package:Speak2Note/valueNotifier/bool_value_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:Speak2Note/API/firebase_api.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:Speak2Note/valueNotifier/string_value_notifier.dart';
import 'package:uuid/uuid.dart';
import 'package:record/record.dart';

class RecordingPageBloc extends ChangeNotifier {
  int recordTime = 0;
  Timer? timer;
  VarValueNotifier timeNotifier = VarValueNotifier('00:00:00');
  BoolValueNotifier isRecordingNotifier = BoolValueNotifier(true);
  late String title = '';
  final _audioRecorder = Record();

  //全區
  DateTime now = DateTime.now();
  //

  //初始化，獲得麥克風授權
  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }
    timeNotifier.value = '00:00:00';
    isRecordingNotifier.value = true;
    await startRecord();
  }

  Future startRecord() async {
    print('開始錄音');
    now = DateTime.now();
    DateTime dateTime = DateTime.parse(now.toString());
    title = DateFormat.jm().format(dateTime);
    //mp3開始
    await _audioRecorder.start();

    isRecordingNotifier.value = true;
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      recordTime++;
      timeNotifier.varChange(formatTime(recordTime));
      print('${formatTime(recordTime)}');
    });
  }

  Future pauseRecord() async {
    print('停止錄音');
    recordTime = 0;
    timer?.cancel();
    isRecordingNotifier.value = false;

    //recorder暫停
    String? path = await _audioRecorder.stop();
    path = path!.replaceAll("file://", "");

    //上傳firestore
    String recordingID = const Uuid().v1();
    String audioUrl = await FirebaseAPI().uploadAudio(
      FirebaseAuth.instance.currentUser!.uid,
      path,
      recordingID,
    );
    isRecordingNotifier.value = false;
    FirebaseAPI().uploadRecordings(
      title,
      now,
      FirebaseAuth.instance.currentUser!.uid,
      audioUrl,
      recordingID,
    );
  }
}

String formatTime(int totalSeconds) {
  // 計算小時、分鐘、秒
  int hours = totalSeconds ~/ 3600;
  int minutes = (totalSeconds % 3600) ~/ 60;
  int seconds = totalSeconds % 60;

  // 格式化時間字串
  String formattedTime = '${hours.toString().padLeft(2, '0')}'
      ':${minutes.toString().padLeft(2, '0')}'
      ':${seconds.toString().padLeft(2, '0')}';

  return formattedTime;
}
