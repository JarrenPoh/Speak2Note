import 'dart:async';
import 'package:Speak2Note/globals/format.dart';
import 'package:Speak2Note/valueNotifier/bool_value_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:Speak2Note/API/firebase_api.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:Speak2Note/valueNotifier/var_value_notifier.dart';
import 'package:uuid/uuid.dart';
import 'package:record/record.dart';

class RecordingPageBloc extends ChangeNotifier {
  int recordTime = 0;
  Timer? timer;
  VarValueNotifier timeNotifier = VarValueNotifier('00:00:00');
  BoolValueNotifier isRecordingNotifier = BoolValueNotifier(true);
  VarValueNotifier uploadListNotifier = VarValueNotifier([]);

  late String time = '';
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
    isRecordingNotifier.value = false;
    await startRecord();
  }

  Future startRecord() async {
    print('開始錄音');
    now = DateTime.now();
    DateTime dateTime = DateTime.parse(now.toString());
    time = DateFormat.jm().format(dateTime);
    //mp3開始
    final directory = await getApplicationDocumentsDirectory();
    final savePath = '${directory.path}/jj${Uuid().v1()}.m4a';
    await _audioRecorder.start(path: savePath, encoder: AudioEncoder.aacLc);

    isRecordingNotifier.value = true;
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      recordTime++;
      timeNotifier.varChange(secondToTime(recordTime));
    });
  }

  Future pauseRecord() async {
    print('停止錄音');
    timer?.cancel();
    isRecordingNotifier.value = false;
    String recordingID = const Uuid().v1();

    //recorder暫停
    String? path = await _audioRecorder.stop();
    path = path!.replaceAll("file://", "");
    //update upload List
    List _list = uploadListNotifier.value;
    _list.add({
      "title": '',
      "time": time,
      "uploadProgress": 0.0,
      "recordingID": recordingID,
    });
    uploadListNotifier.varChange(_list);

    //上傳firestore
    FirebaseAPI().uploadRecordings(
      '',
      time,
      now,
      FirebaseAuth.instance.currentUser!.uid,
      path,
      recordingID,
      uploadListNotifier,
      recordTime,
    );
    recordTime = 0;
  }
}
