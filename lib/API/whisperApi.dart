import 'dart:convert';
import 'dart:io';
import 'package:Speak2Note/secret.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../models/whisperMap.dart';

class whisperApi {
  Future<List<WhisperSegment>?> convert(
    audioPath,
    String language,
    String RecordingID,
    int totalDuration,
  ) async {
    String downloadPath = await downloadAudioFile(audioPath, RecordingID);
    String apiKey = whisperApiKey;
    var url = Uri.https("api.openai.com", "/v1/audio/transcriptions");

    var response;
    var responseBody;
    int splitIntervalSeconds = 360; //6 min
    final numSplits = (totalDuration / splitIntervalSeconds).ceil();
    final directory = await getApplicationDocumentsDirectory();
    String _path = directory.path;
    if (!await Directory(_path).exists()) {
      await Directory(_path).create(recursive: true);
    }
    List<WhisperSegment>? finalResult = [];
    // 执行切割並上傳
    for (int i = 0; i < numSplits; i++) {
      var request = http.MultipartRequest(
        'POST',
        url,
      );
      request.headers.addAll(({"Authorization": "Bearer $apiKey"}));
      request.fields["model"] = "whisper-1";
      request.fields["language"] = language;
      request.fields["response_format"] = "verbose_json";
      final startTime = i * splitIntervalSeconds;
      final endTime = (i + 1) * splitIntervalSeconds;
      final outputFilePath = '$_path/${Uuid().v1()}$i.wav'; // 生成不同文件名
      // 确保目录存在，如果不存在则创建
      var cmd =
          "-y -i \"$downloadPath\" -vn -ss $startTime -to $endTime -ar 16k -ac 2 -b:a 96k -acodec copy $outputFilePath";

      print('正在裁減第 $i 份');
      await FFmpegKit.execute(cmd);

      //上傳
      print('正在上傳第 $i 份');
      request.files.clear();
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        outputFilePath,
      ));
      response = await request.send();
      responseBody = await response.stream.bytesToString();
      print('responseBody is $responseBody');
      if (response.statusCode == 200) {
        List<WhisperSegment> _result =
            WhisperResult.fromJson(jsonDecode(responseBody)).segments!.map((e) {
          e.start += splitIntervalSeconds * i;
          e.end += splitIntervalSeconds * i;
          return e;
        }).toList();
        finalResult.addAll(_result);
      } else {
        print('發生錯誤');
        return null;
      }
    }

    deleteAudioFile(_path);
    return finalResult;
  }

  Future<String> downloadAudioFile(String audioUrl, String RecordingID) async {
    final response = await http.get(Uri.parse(audioUrl));
    final directory = await getApplicationDocumentsDirectory();
    final savePath = '${directory.path}/$RecordingID.wav';
    if (response.statusCode == 200) {
      final file = File(savePath);
      await file.writeAsBytes(response.bodyBytes);
      return savePath;
    } else {
      throw Exception('Failed to download audio file');
    }
  }

  Future<void> deleteAudioFile(String filePath) async {
    final file = File(filePath);

    if (await file.exists()) {
      await file.delete();
      print('臨時轉文字File deleted: $filePath');
    } else {
      print('File does not exist: $filePath');
    }
  }
}
