class FacialResult {
  final int percentage;
  final String level;
  final double blinkRate;
  final double motion;
  final double asymmetry;
  final DateTime timestamp;

  FacialResult({
    required this.percentage,
    required this.level,
    required this.blinkRate,
    required this.motion,
    required this.asymmetry,
    required this.timestamp,
  });

  factory FacialResult.fromJson(Map<String, dynamic> json) {
    return FacialResult(
      percentage: json['percentage'],
      level: json['level'],
      blinkRate: json['details']['blinkRate'].toDouble(),
      motion: json['details']['motion'].toDouble(),
      asymmetry: json['details']['asymmetry'].toDouble(),
      timestamp: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'percentage': percentage,
        'level': level,
        'blinkRate': blinkRate,
        'motion': motion,
        'asymmetry': asymmetry,
        'timestamp': timestamp.toIso8601String(),
      };
}
