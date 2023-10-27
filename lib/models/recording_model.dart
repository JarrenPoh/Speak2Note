import 'package:Speak2Note/models/whisperMap.dart';

class RecordingModel {
  String title;
  String time;
  DateTime recordAt;
  String uid;
  String audioUrl;
  List<WhisperSegment>? whisperSegments;
  String recordingID;
  int duration;

  RecordingModel({
    required this.recordAt,
    required this.title,
    required this.time,
    required this.uid,
    required this.audioUrl,
    required this.whisperSegments,
    required this.recordingID,
    required this.duration,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "time":time,
      "recordAt": recordAt,
      "uid": uid,
      "audioUrl": audioUrl,
      "whisperSegments": whisperSegments,
      "recordingID": recordingID,
      "duration":duration,
    };
  }

  static RecordingModel fromJson(dynamic map) {
    List<WhisperSegment> list = [];
    for(var i in map["whisperSegments"]){
      list.add(WhisperSegment.fromJson(i));
    }
    return RecordingModel(
      recordAt: map['recordAt'].toDate(),
      time:map['time'],
      title: map["title"],
      uid: map["uid"],
      audioUrl: map["audioUrl"],
      whisperSegments: (map["whisperSegments"] as List).isEmpty
          ? null
          : list,
      recordingID: map["recordingID"],
      duration:map["duration"],
    );
  }

  static Map<DateTime, List<RecordingModel>> toEvent(List list) {
    Map<DateTime, List<RecordingModel>> transformedMap = {};
    for (var i in list) {
      RecordingModel r = RecordingModel.fromJson(i);
      DateTime utcDateTime = DateTime.utc(
        r.recordAt.year,
        r.recordAt.month,
        r.recordAt.day,
      );
      if (transformedMap.containsKey(utcDateTime)) {
        transformedMap[utcDateTime]!.add(r);
      } else {
        transformedMap[utcDateTime] = [r];
      }
    }
    return transformedMap;
  }
}

String dateTimeToUTCString(DateTime dateTime) {
  // Format DateTime to 'yyyy, MM, dd' UTC format
  String formattedDate = '${dateTime.year}, ${dateTime.month}, ${dateTime.day}';
  return formattedDate;
}
