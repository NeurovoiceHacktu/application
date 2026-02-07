class VoiceResult {
  final double riskScore;
  final String riskLevel;
  final DateTime timestamp;

  VoiceResult({
    required this.riskScore,
    required this.riskLevel,
    required this.timestamp,
  });
}