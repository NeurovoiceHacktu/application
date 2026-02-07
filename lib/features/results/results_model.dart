class VoiceResult {
  final bool? detected;
  final double confidence;

  VoiceResult({
    required this.detected,
    required this.confidence,
  });

  bool get isHighRisk => detected == true;
  bool get isLowRisk => detected == false;
  bool get isInconclusive => detected == null;
}
