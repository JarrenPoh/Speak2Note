import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Speak2Note/providers/recording_page_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

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
      backgroundColor:
          _selectedPage == 0 ? Colors.blueAccent : Colors.redAccent,
      onPressed: !canClick
          ? () {
              print("cant's click");
            }
          : () async {
              var microphoneStatus = await Permission.microphone.status;
              print('mircrophone statue: ${microphoneStatus}');
              if (microphoneStatus.isGranted) {
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
                  widget.recordingPageBloc.pauseRecord();
                  widget.onIconTap(0);
                  await Future.delayed(Duration(milliseconds: 1));
                  setState(() {
                    _selectedPage = 0;
                    canClick = true;
                  });
                }
              } else if (microphoneStatus.isPermanentlyDenied ||
                  microphoneStatus.isLimited ||
                  microphoneStatus.isDenied) {
                showAlert();
              }
            },
      child: Icon(
        _selectedPage == 0 ? Icons.record_voice_over : Icons.pause,
        color: Colors.white,
      ),
    );
  }

  showAlert() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('麥克風尚未授權'),
          content: const Text(
            '點擊確認前往設定->麥克風->開啟',
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text(
                '取消',
                style: TextStyle(
                  color: Colors.black26,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            CupertinoDialogAction(
              child: Text(
                '前往',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                AppSettings.openAppSettings(type: AppSettingsType.location);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
