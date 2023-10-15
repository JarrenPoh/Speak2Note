import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/whisperMap.dart';

class whisperApi {
  Future<WhisperResult> uploadMp3(file) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.31.5:5000/upload'),
    );

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        file,
      ),
    );

    request.fields['username'] = 'my_username'; // 添加额外字段

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

  // Future<String> transcribeAudio(file) async {
  //   print('file is $file');
  //   final request = http.MultipartRequest(
  //     'POST',
  //     Uri.parse('https://transcribe.whisperapi.com'),
  //     // Uri.parse('https://api.openai.com/v1/audio/transcriptions'),
  //   )
  //     ..fields['model'] = 'whisper-1'
  //     ..fields['language'] = 'zh'
  //     ..files.add(
  //       await http.MultipartFile.fromPath(
  //         'file',
  //         file,
  //         contentType: MediaType('audio', 'mp3'),
  //       ),
  //     );

  //   request.headers['Authorization'] = myApiKey;

  //   final response = await request.send();
  //   final responseBody = await response.stream.bytesToString();
  //   print(responseBody);
  //   final answer = jsonDecode(responseBody);

  //   return answer['text'];
  // }
}
