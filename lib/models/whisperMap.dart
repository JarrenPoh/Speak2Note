class WhisperResult {
  String language;
  List<WhisperSegment>? segments;
  String text;

  WhisperResult({
    required this.language,
    required this.segments,
    required this.text,
  });

  factory WhisperResult.fromJson(Map<String, dynamic> json) {
    var segmentsJson = json['segments'] as List;
    List<WhisperSegment> segments =
        segmentsJson.map((s) => WhisperSegment.fromJson(s)).toList();
    return WhisperResult(
      text: json['text'],
      language: json['language'],
      segments: segments,
    );
  }
}

class WhisperSegment {
  // double? avgLogProb;
  // double? compressionRatio;
  int end;
  int? id;
  // double? noSpeechProb;
  // int? seek;
  int start;
  // double? temperature;
  String? text;
  // List<dynamic>? tokens;

  WhisperSegment({
    // this.avgLogProb,
    // this.compressionRatio,
    required this.end,
    this.id,
    // this.noSpeechProb,
    // this.seek,
    required this.start,
    // this.temperature,
    this.text,
    // this.tokens,
  });

  factory WhisperSegment.fromJson(Map<String, dynamic> json) {
    // List<dynamic>? tokensJson =json['tokens'] ?? [];
    // List<dynamic>? tokens =tokensJson!=null? tokensJson.map((t) => t).toList():[];
    return WhisperSegment(
      // avgLogProb: json['avg_logprob'] ?? '',
      // compressionRatio: json['compression_ratio'] ?? '',
      end: json['end'].toInt() ?? '',
      id: json['id'] ?? '',
      // noSpeechProb: json['no_speech_prob'] ?? '',
      // seek: json['seek'] ?? '',
      start: json['start'].toInt() ?? '',
      // temperature: json['temperature'] ?? '',
      text: json['text'] ?? '',
      // tokens: tokens,
    );
  }

  static Map<String, dynamic> toMap(WhisperSegment segment) {
    return {
      "end": segment.end,
      "id": segment.id,
      "start": segment.start,
      "text": segment.text,
    };
  }
}
