import 'package:Speak2Note/API/firebase_api.dart';
import 'package:Speak2Note/API/whisperApi.dart';
import 'package:Speak2Note/models/recording_model.dart';
import 'package:Speak2Note/models/whisperMap.dart';
import 'package:Speak2Note/providers/home_page/record_list_bloc.dart';
import 'package:Speak2Note/providers/record_detail/whisper_card_bloc.dart';
import 'package:Speak2Note/valueNotifier/map_value.notifier.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WhisperArticleBloc extends ChangeNotifier {
  String language = "zh";
  MapValueNotifier whisperMotifier =
      MapValueNotifier({"body": null, "done": true, "query": ''});
  WhisperCardBloc whisperCardBloc = WhisperCardBloc();
  ScrollController scrollController = ScrollController();

  void scrollToHeight(index, cardHeight) {
    double height = 0;
    height = cardHeight * (index - 3);
    scrollController.jumpTo(height);
  }

  List<WhisperSegment>? whisperSegments;
  //mp3
  Future<void> callWhisperApi(
    RecordingModel detail,
    String language,
    String recordingID,
    RecordListBloc recordListBloc,
  ) async {
    try {
      whisperMotifier.mapChange(null, false, '');
      String newPath = detail.audioUrl + '.wav';
      await convertMp4ToWav(detail.audioUrl, newPath);
      print('正在申請whisperAPI..');
      whisperSegments = await whisperApi().convert(
        newPath,
        language,
        recordingID,
        detail.duration,
      );
      if (whisperSegments == null) {
        Get.snackbar(
          '生成失敗',
          '請再嘗試生成一次，如果仍然錯誤請回報官方',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(
            seconds: 2,
          ),
        );
        whisperMotifier.mapChange(null, true, '');
      } else {
        whisperMotifier.mapChange(whisperSegments, true, '');
      }

      //更新recordList路由的資料
      updateFather(recordingID, recordListBloc, whisperSegments!);
      // widget.recordListBloc.recordingListNotifier
      //     .recordingListChange(list, true);

      if (whisperSegments != null) {
        await FirebaseAPI().uploadWhisperSegments(
          recordingID,
          whisperSegments!,
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

Future<void> convertMp4ToWav(String inputPath, String outputPath) async {
  print('正在轉換高職音檔');
  final arguments = [
    '-i',
    inputPath,
    '-ac',
    '2',
    '-ar',
    '16000',
    '-acodec',
    'pcm_s16le',
    outputPath,
  ];
  await FFmpegKit.execute(arguments.join(' '));
  print('完成音檔轉換');
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
