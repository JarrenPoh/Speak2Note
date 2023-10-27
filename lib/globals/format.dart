String secondToTime(int totalSeconds) {
  // 計算小時、分鐘、秒
  int hours = totalSeconds ~/ 3600;
  int minutes = (totalSeconds % 3600) ~/ 60;
  int seconds = totalSeconds % 60;

  // 格式化時間字串
  String formattedTime = '${hours.toString().padLeft(2, '0')}'
      ':${minutes.toString().padLeft(2, '0')}'
      ':${seconds.toString().padLeft(2, '0')}';

  return formattedTime;
}

String formatTimeRange(int seconds1, int seconds2) {
  String unit = seconds2 >= 60
      ? '分'
      : seconds2 >= 3600
          ? '小時'
          : '秒';
  String formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainingSeconds = seconds % 60;

    String formattedTime = '';
    if (hours > 0) {
      formattedTime += '$hours:';
    }
    if (minutes > 0 || hours > 0) {
      formattedTime += '$minutes:';
    }
    formattedTime += remainingSeconds.toString().padLeft(2, '0');

    return formattedTime;
  }

  final formattedTime1 = formatTime(seconds1);
  final formattedTime2 = formatTime(seconds2);

  return '$formattedTime1 ~ $formattedTime2 ' + unit;
}
