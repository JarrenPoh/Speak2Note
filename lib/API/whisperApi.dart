import 'dart:convert';
import 'dart:io';
import 'package:Speak2Note/secret.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../models/whisperMap.dart';

class whisperApi {
  Future<WhisperResult?> convert(
    audioPath,
    String language,
    String RecordingID,
  ) async {
    audioPath = await downloadAudioFile(audioPath, RecordingID);

    String apiKey = whisperApiKey;
    var url = Uri.https("api.openai.com", "/v1/audio/transcriptions");
    var request = http.MultipartRequest(
      'POST',
      url,
    );
    request.headers.addAll(({"Authorization": "Bearer $apiKey"}));
    request.fields["model"] = "whisper-1";
    request.fields["language"] = language;
    request.fields["response_format"] = "verbose_json";

    var response;
     var responseBody;
    try {
      request.files.add(await http.MultipartFile.fromPath('file', audioPath));
      response = await request.send();
      print('response code: ${response.statusCode}');
       responseBody = await response.stream.bytesToString();
      print('responseBody is $responseBody');
    } catch (e) {
      print(e.toString());
    }

    if (response.statusCode == 200) {
      WhisperResult result = WhisperResult.fromJson(jsonDecode(responseBody));
      deleteAudioFile(audioPath);
      return result;
    } else {
      return null;
    }
  }

  Future<String> downloadAudioFile(String audioUrl, String RecordingID) async {
    final response = await http.get(Uri.parse(audioUrl));
    final directory = await getApplicationDocumentsDirectory();
    final savePath = '${directory.path}/$RecordingID.wav';
    if (response.statusCode == 200) {
      final file = File(savePath);
      await file.writeAsBytes(response.bodyBytes);
      print('臨時轉文字File created: $savePath');
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
