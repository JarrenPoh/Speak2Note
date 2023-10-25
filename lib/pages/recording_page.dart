import 'package:flutter/material.dart';
import 'package:Speak2Note/globals/dimension.dart';
import 'package:Speak2Note/providers/recording_page_bloc.dart';

class RecordingPage extends StatefulWidget {
  final RecordingPageBloc bloc;
  const RecordingPage({
    super.key,
    required this.bloc,
  });

  @override
  State<RecordingPage> createState() => _RecordingPageState();
}

class _RecordingPageState extends State<RecordingPage> {
  @override
  void initState() {
    super.initState();
    widget.bloc.initRecorder();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 86, 86, 86),
        elevation: 0,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ValueListenableBuilder(
              valueListenable: widget.bloc.timeNotifier,
              builder: (context, value, child) {
                value as String;
                return Text(value);
              },
            ),
          ],
        ),
        toolbarHeight: Dimensions.height5 * 20,
      ),
      body: ValueListenableBuilder(
        valueListenable: widget.bloc.isRecordingNotifier,
        builder: (context, value, child) {
          value as bool;
          bool _isRecording = value;
          return Center(
            child: !_isRecording
                ? CircularProgressIndicator.adaptive()
                : Text('錄音中'),
          );
        },
      ),
    );
  }
}
