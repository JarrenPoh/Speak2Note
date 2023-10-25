import 'package:Speak2Note/globals/dimension.dart';
import 'package:Speak2Note/models/positionData_model.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:just_audio/just_audio.dart';

class AudioSlider extends StatefulWidget {
  final String audioUrl;
  const AudioSlider({
    super.key,
    required this.audioUrl,
  });

  @override
  State<AudioSlider> createState() => _AudioSliderState();
}

class _AudioSliderState extends State<AudioSlider> {
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  Duration bufferedPosition = Duration.zero;
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          audioPlayer.positionStream,
          audioPlayer.bufferedPositionStream,
          audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  void initState() {
    super.initState();
    setAudio();
  }

  Future setAudio() async {
    // String newPath = widget.audioUrl + '.wav';
    // await convertMp4ToWav(widget.audioUrl, newPath);
    audioPlayer.setUrl(widget.audioUrl);
    audioPlayer.setVolume(10);
  }

  Future<void> convertMp4ToWav(String inputPath, String outputPath) async {
    final arguments = [
      '-i',
      inputPath,
      '-ac',
      '1',
      '-ar',
      '16000',
      '-acodec',
      'pcm_s16le',
      outputPath,
    ];
    await FFmpegKit.execute(arguments.join(' '));
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.width5 * 4,
        vertical: Dimensions.height5 * 2,
      ),
      color: Colors.grey[200],
      child: Column(
        children: [
          StreamBuilder(
            stream: _positionDataStream,
            builder: (context, snapshot) {
              final positionData = snapshot.data;
              return ProgressBar(
                barHeight: Dimensions.height2 * 4,
                baseBarColor: Colors.grey[300],
                bufferedBarColor: Colors.grey[500],
                progressBarColor: Color.fromARGB(255, 27, 27, 27),
                thumbColor: Color.fromARGB(255, 27, 27, 27),
                timeLabelTextStyle: const TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.w600,
                ),
                progress: positionData?.position ?? Duration.zero,
                buffered: positionData?.bufferedPosition ?? Duration.zero,
                total: positionData?.duration ?? Duration.zero,
                onSeek: audioPlayer.seek,
              );
            },
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              StreamBuilder<PlayerState>(
                stream:
                    audioPlayer.playerStateStream, // 将Stream传递给StreamBuilder
                builder: (context, snapshot) {
                  final PlayerState = snapshot.data;
                  final processingState = PlayerState?.processingState;
                  final playing = PlayerState?.playing;
                  if (processingState == ProcessingState.loading ||
                      processingState == ProcessingState.buffering) {
                    return IconButton(
                      icon: const CircularProgressIndicator.adaptive(),
                      iconSize: Dimensions.height2 * 16,
                      onPressed: () {},
                    );
                  } else if (playing != true) {
                    return IconButton(
                      icon: const Icon(
                        Icons.play_arrow_rounded,
                      ),
                      iconSize: Dimensions.height5 * 10,
                      color: Colors.black54,
                      onPressed: audioPlayer.play,
                    );
                  } else if (processingState != ProcessingState.completed) {
                    return IconButton(
                      icon: const Icon(
                        Icons.pause_rounded,
                      ),
                      iconSize: Dimensions.height5 * 10,
                      color: Colors.black54,
                      onPressed: audioPlayer.pause,
                    );
                  } else {
                    return IconButton(
                      icon: const Icon(
                        Icons.replay_rounded,
                      ),
                      iconSize: Dimensions.height5 * 10,
                      color: Colors.black54,
                      onPressed: () {
                        audioPlayer.seek(Duration.zero);
                      },
                    );
                  }
                },
              ),
              // Opens speed slider dialog
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.volume_up),
                    onPressed: () {
                      showSliderDialog(
                        context: context,
                        title: "Adjust volume",
                        divisions: 10,
                        min: 0,
                        max: 100,
                        value: audioPlayer.volume,
                        stream: audioPlayer.volumeStream,
                        onChanged: audioPlayer.setVolume,
                      );
                    },
                  ),
                  StreamBuilder<double>(
                    stream: audioPlayer.speedStream,
                    builder: (context, snapshot) => IconButton(
                      icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      onPressed: () {
                        if (snapshot.data == 1.0) {
                          audioPlayer.setSpeed(1.25);
                        } else if (snapshot.data == 1.25) {
                          audioPlayer.setSpeed(1.5);
                        } else if (snapshot.data == 1.5) {
                          audioPlayer.setSpeed(0.7);
                        } else {
                          audioPlayer.setSpeed(1.0);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showSliderDialog({
    required BuildContext context,
    required String title,
    required int divisions,
    required double min,
    required double max,
    String valueSuffix = '',
    // TODO: Replace these two by ValueStream.
    required double value,
    required Stream<double> stream,
    required ValueChanged<double> onChanged,
  }) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, textAlign: TextAlign.center),
        content: StreamBuilder<double>(
          stream: stream,
          builder: (context, snapshot) => SizedBox(
            height: 100.0,
            child: Column(
              children: [
                Text(
                  '${snapshot.data?.toInt().toString()}$valueSuffix',
                  style: const TextStyle(
                    fontFamily: 'Fixed',
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                ),
                Slider(
                  activeColor: Color.fromARGB(255, 27, 27, 27),
                  thumbColor: Color.fromARGB(255, 27, 27, 27),
                  inactiveColor: Colors.grey[500],
                  divisions: divisions,
                  min: min,
                  max: max,
                  value: snapshot.data ?? value,
                  onChanged: onChanged,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
