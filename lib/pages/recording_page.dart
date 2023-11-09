import 'package:flutter/material.dart';
import 'package:Speak2Note/globals/dimension.dart';
import 'package:Speak2Note/providers/recording_page_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
    Color appBarColor = Theme.of(context).appBarTheme.backgroundColor!;
    Color firstColor = Theme.of(context).colorScheme.primary;
    Color onSecondaryColor = Theme.of(context).colorScheme.onSecondary;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ValueListenableBuilder(
              valueListenable: widget.bloc.timeNotifier,
              builder: (context, value, child) {
                value as String;
                return Text(
                  value,
                  style: TextStyle(color: onSecondaryColor),
                );
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
                : LoadingAnimationWidget.newtonCradle(
                    color: firstColor,
                    size: Dimensions.height5 * 20,
                  ),
          );
        },
      ),
    );
  }
}
