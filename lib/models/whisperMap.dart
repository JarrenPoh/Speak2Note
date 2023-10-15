class WhisperResult {
  String language;
  List<WhisperiSegment>? segments;
  String text;

  WhisperResult({
    required this.language,
    required this.segments,
    required this.text,
  });

  factory WhisperResult.fromJson(Map<String, dynamic> json) {
    var segmentsJson = json['segments'] as List;
    List<WhisperiSegment> segments =
        segmentsJson.map((s) => WhisperiSegment.fromJson(s)).toList();
    return WhisperResult(
      text: json['text'],
      language: json['language'],
      segments: segments,
    );
  }
}

class WhisperiSegment {
  double? avgLogProb;
  double? compressionRatio;
  double? end;
  int? id;
  double? noSpeechProb;
  int? seek;
  double? start;
  double? temperature;
  String? text;
  List<dynamic>? tokens;

  WhisperiSegment({
    this.avgLogProb,
    this.compressionRatio,
    this.end,
    this.id,
    this.noSpeechProb,
    this.seek,
    this.start,
    this.temperature,
    this.text,
    this.tokens,
  });

  factory WhisperiSegment.fromJson(Map<String, dynamic> json) {
    List<dynamic>? tokensJson =json['tokens'] ?? [];
    List<dynamic>? tokens =tokensJson!=null? tokensJson.map((t) => t).toList():[];
    return WhisperiSegment(
      avgLogProb: json['avg_logprob'] ?? '',
      compressionRatio: json['compression_ratio'] ?? '',
      end: json['end'] ?? '',
      id: json['id'] ?? '',
      noSpeechProb: json['no_speech_prob'] ?? '',
      seek: json['seek'] ?? '',
      start: json['start'] ?? '',
      temperature: json['temperature'] ?? '',
      text: json['text'] ?? '',
      tokens: tokens,
    );
  }
}
