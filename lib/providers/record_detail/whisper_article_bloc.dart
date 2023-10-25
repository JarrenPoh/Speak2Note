import 'package:Speak2Note/API/firebase_api.dart';
import 'package:Speak2Note/API/whisperApi.dart';
import 'package:Speak2Note/models/recording_model.dart';
import 'package:Speak2Note/models/whisperMap.dart';
import 'package:Speak2Note/providers/home_page/record_list_bloc.dart';
import 'package:Speak2Note/providers/record_detail/whisper_card_bloc.dart';
import 'package:Speak2Note/valueNotifier/map_value.notifier.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:flutter/material.dart';

class WhisperArticleBloc extends ChangeNotifier {
  String language = "zh";
  MapValueNotifier whisperMotifier =
      MapValueNotifier({"body": null, "done": true, "query": ''});
  WhisperCardBloc whisperCardBloc = WhisperCardBloc();
  ScrollController scrollController = ScrollController();

  void scrollToHeight(index, cardHeight) {
    double height = 0;
    height = cardHeight * (index-3);
    scrollController.jumpTo(height);
  }

  WhisperResult? whisperResult;
  //mp3
  Future<void> callWhisperApi(
    String audioPath,
    String language,
    String recordingID,
    RecordListBloc recordListBloc,
  ) async {
    try {
      whisperMotifier.mapChange(null, false, '');
      String newPath = audioPath + '.wav';
      print('正在轉換m4a為wav檔..');
      await convertMp4ToWav(audioPath, newPath);
      print('正在申請whisperAPI..');
      whisperResult = await whisperApi().uploadMp3(
        newPath,
        language,
        recordingID,
      );
      whisperMotifier.mapChange(whisperResult!.segments, true, '');

      //更新recordList路由的資料
      updateFather(recordingID, recordListBloc, whisperResult!.segments!);
      // widget.recordListBloc.recordingListNotifier
      //     .recordingListChange(list, true);

      if (whisperResult != null) {
        await FirebaseAPI().updateWhisperSegments(
          recordingID,
          whisperResult!.segments!,
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

Future<void> convertMp4ToWav(String inputPath, String outputPath) async {
  final arguments = [
    '-i',
    inputPath,
    '-ac',
    '1',
    '-ar',
    '16000',
    '-acodec',
    'pcm_s16le',
    outputPath,
  ];
  await FFmpegKit.execute(arguments.join(' '));
}

//轉換玩whisper後更新首頁
void updateFather(
  String recordingID,
  RecordListBloc recordListBloc,
  List<WhisperSegment> segments,
) {
  List<RecordingModel> _list = [];
  _list = recordListBloc.recordingListNotifier.value['list'];
  int index = _list.indexWhere((element) => element.recordingID == recordingID);
  _list[index].whisperSegments = segments;
  recordListBloc.recordingListNotifier.recordingListChange(_list, true);
}
