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

class TremorResult {
  final String riskLevel;
  final double confidence;
  final double tremorFrequency;
  final int severityScore;
  final List<String> recommendations;
  final DateTime timestamp;

  TremorResult({
    required this.riskLevel,
    required this.confidence,
    required this.tremorFrequency,
    required this.severityScore,
    required this.recommendations,
    required this.timestamp,
  });

  factory TremorResult.fromJson(Map<String, dynamic> json) {
    return TremorResult(
      riskLevel: json['risk_level'] ?? json['riskLevel'] ?? 'Medium',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      tremorFrequency: (json['tremor_frequency'] as num?)?.toDouble() ?? 0.0,
      severityScore: json['severity_score'] ?? json['severityScore'] ?? 0,
      recommendations: List<String>.from(json['recommendations'] ?? []),
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'risk_level': riskLevel,
      'confidence': confidence,
      'tremor_frequency': tremorFrequency,
      'severity_score': severityScore,
      'recommendations': recommendations,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}