class DoctorDashboardModel {
  final String patientName;
  final String patientId;
  final int age;
  final RiskSeverity riskSeverity;
  final AIClinicalSummary aiClinicalSummary;
  final DiseaseProgression diseaseProgression;
  final String lastUpdated;

  DoctorDashboardModel({
    required this.patientName,
    required this.patientId,
    required this.age,
    required this.riskSeverity,
    required this.aiClinicalSummary,
    required this.diseaseProgression,
    required this.lastUpdated,
  });

  factory DoctorDashboardModel.fromJson(Map<String, dynamic> json) {
    return DoctorDashboardModel(
      patientName: json['patient_name'],
      patientId: json['patient_id'],
      age: json['age'],
      riskSeverity: RiskSeverity.fromJson(json['risk_severity']),
      aiClinicalSummary: AIClinicalSummary.fromJson(json['ai_clinical_summary']),
      diseaseProgression: DiseaseProgression.fromJson(json['disease_progression']),
      lastUpdated: json['last_updated'],
    );
  }
}

class RiskSeverity {
  final String currentLevel;
  final int score;
  final String date;
  final TremorLevels tremorLevels;

  RiskSeverity({
    required this.currentLevel,
    required this.score,
    required this.date,
    required this.tremorLevels,
  });

  factory RiskSeverity.fromJson(Map<String, dynamic> json) {
    return RiskSeverity(
      currentLevel: json['current_level'],
      score: json['score'],
      date: json['date'],
      tremorLevels: TremorLevels.fromJson(json['tremor_levels']),
    );
  }
}

class TremorLevels {
  final int voice;
  final int facial;
  final int tremor;

  TremorLevels({
    required this.voice,
    required this.facial,
    required this.tremor,
  });

  factory TremorLevels.fromJson(Map<String, dynamic> json) {
    return TremorLevels(
      voice: json['voice'],
      facial: json['facial'],
      tremor: json['tremor'],
    );
  }
}

class AIClinicalSummary {
  final String generatedAt;
  final String summary;
  final List<String> keyFindings;

  AIClinicalSummary({
    required this.generatedAt,
    required this.summary,
    required this.keyFindings,
  });

  factory AIClinicalSummary.fromJson(Map<String, dynamic> json) {
    return AIClinicalSummary(
      generatedAt: json['generated_at'],
      summary: json['summary'],
      keyFindings: List<String>.from(json['key_findings']),
    );
  }
}

class DiseaseProgression {
  final List<String> months;
  final List<int> tremorScores;
  final List<int> voiceScores;
  final List<int> motorScores;

  DiseaseProgression({
    required this.months,
    required this.tremorScores,
    required this.voiceScores,
    required this.motorScores,
  });

  factory DiseaseProgression.fromJson(Map<String, dynamic> json) {
    return DiseaseProgression(
      months: List<String>.from(json['months']),
      tremorScores: List<int>.from(json['tremor_scores']),
      voiceScores: List<int>.from(json['voice_scores']),
      motorScores: List<int>.from(json['motor_scores']),
    );
  }
}
