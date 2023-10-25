import 'dart:convert';
import 'dart:io';
import 'package:Speak2Note/secret.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../models/whisperMap.dart';

class whisperApi {
  Future<WhisperResult> uploadMp3(
    audioPath,
    String language,
    String RecordingID,
  ) async {
    audioPath =  await downloadAudioFile(audioPath, RecordingID);

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
    try {
      request.files.add(await http.MultipartFile.fromPath('file', audioPath));
    } catch (e) {
      print(e.toString());
    }
    var response = await request.send();
    var responseBody = await response.stream.bytesToString();
    print('responseBody is $responseBody');
    WhisperResult result = WhisperResult.fromJson(jsonDecode(responseBody));

    if (response.statusCode == 200) {
      return result;
    } else {
      throw Exception('Failed to upload mp3 file');
    }
  }

  Future<String> downloadAudioFile(String audioUrl, String RecordingID) async {
    final response = await http.get(Uri.parse(audioUrl));
    final directory = await getApplicationDocumentsDirectory();
    final savePath = '${directory.path}/$RecordingID.mp3';
    if (response.statusCode == 200) {
      final file = File(savePath);
      await file.writeAsBytes(response.bodyBytes);
      return savePath;
    } else {
      throw Exception('Failed to download audio file');
    }
  }
}
