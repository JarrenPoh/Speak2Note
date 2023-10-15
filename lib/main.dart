import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:renote/requests/whisperApi.dart';
import 'models/whisperMap.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black54,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.light(),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black54,
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //初始化，獲得麥克風授權
  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }
  }

  @override
  void initState() {
    super.initState();
    initRecorder();
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  //創造路徑
  int i = 3;
  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return sdPath + "/test_${i++}.mp3";
  }

  //錄音輸出mp3
  String? recordFilePath;
  Future startRecord() async {
    recordFilePath = await getFilePath();
    RecordMp3.instance.start(recordFilePath!, (type) {});

    recordTime = 0; //重置时间为0
    startTimer(); //开始计时器
    ready = false;
    //測試 暫停錄音
    // await Future.delayed(Duration(seconds: recordingTime)); //global
    // //停止计时器，并将录音时间重置为0
    // recordTime = 0;
    // timer?.cancel();

    // RecordMp3.instance.pause();
    // print('recordFilePath is $recordFilePath');
  }

  //測試 暫停錄音
  bool ready = true;
  Future pauseRecord() async {
    recordTime = 0;
    timer?.cancel();

    RecordMp3.instance.pause();
    print('recordFilePath is $recordFilePath');
    ready = true;
    await Future.delayed(const Duration(seconds: 1));

    String result = await uploadMp3();
    print(result);
  }

  bool isLoading = false;
  WhisperResult? whisperResult;
  //mp3
  Future<String> uploadMp3() async {
    String res = '成功上傳到python api並拿回結果';
    setState(() {
      isLoading = true;
    });

    try {
      whisperResult = await whisperApi().uploadMp3(recordFilePath!);
    } catch (e) {
      res = '成功上傳到python api，結果發生錯誤，錯誤訊息:${e.toString()}';
    }

    setState(() {
      isLoading = false;
    });
    return res;
  }

  void _incrementCounter() async {
    if (ready == true) {
      if (recordFilePath != null) {
        resetRecord();
      }
      await startRecord();

      //測試
      // await Future.delayed(const Duration(seconds: 1));

      // String result = await uploadMp3();
      // print(result);
    } else {
      pauseRecord();
    }
  }

  int recordTime = 0;
  Timer? timer;
  //添加计时器函数
  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        recordTime++;
        print(recordTime);
      });
    });
  }

  //重製錄音
  void resetRecord() {
    setState(() {
      recordTime = 0;
      recordFilePath = null;
      whisperResult = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        centerTitle: true,
        title: const Text('24-HR'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          isLoading
              ? Center(
                  child: Column(
                    children: const [
                      CircularProgressIndicator(
                        color: Colors.orange,
                      ),
                      Text('等待轉換語音為文字')
                    ],
                  ),
                )
              : whisperResult != null
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: whisperResult?.segments?.length,
                      itemBuilder: ((context, index) {
                        List<WhisperiSegment> segments =
                            whisperResult!.segments!;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '${segments[index].start?.toStringAsFixed(1)} ~ ${segments[index].end?.toStringAsFixed(1)}',
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [],
                                    ),
                                  ),
                                  Text(
                                    '${segments[index].text}',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                    )
                  : Center(child: Text('Record Time: $recordTime seconds')),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
