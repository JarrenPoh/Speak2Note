import 'package:flutter/material.dart';
import 'package:Speak2Note/providers/recording_page_bloc.dart';

class CustomActionButton extends StatefulWidget {
  final Function onIconTap;
  final RecordingPageBloc recordingPageBloc;
  const CustomActionButton({
    super.key,
    required this.onIconTap,
    required this.recordingPageBloc,
  });

  @override
  State<CustomActionButton> createState() => _CustomActionButtonState();
}

class _CustomActionButtonState extends State<CustomActionButton> {
  int _selectedPage = 0;
  bool canClick = true;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.blueAccent,
      onPressed: !canClick
          ? () {}
          : () async {
              if (_selectedPage == 0) {
                setState(() {
                  canClick = false;
                });
                widget.onIconTap(1);
                await Future.delayed(Duration(milliseconds: 1));
                setState(() {
                  _selectedPage = 1;
                  canClick = true;
                });
              } else {
                setState(() {
                  canClick = false;
                });
                await widget.recordingPageBloc.pauseRecord();
                widget.onIconTap(0);
                setState(() {
                  _selectedPage = 0;
                  canClick = true;
                });
              }
            },
      child: Icon(
        _selectedPage == 0 ? Icons.record_voice_over : Icons.pause,
        color: Colors.white,
      ),
    );
  }
}
