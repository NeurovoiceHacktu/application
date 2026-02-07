class CaregiverDashboardModel {
  final String patientName;
  final String patientId;
  final EmotionalHealth emotionalHealth;
  final Medication medication;
  final SpeechStability speechStability;
  final List<EmergencyAlert> emergencyAlerts;
  final String lastUpdated;

  CaregiverDashboardModel({
    required this.patientName,
    required this.patientId,
    required this.emotionalHealth,
    required this.medication,
    required this.speechStability,
    required this.emergencyAlerts,
    required this.lastUpdated,
  });

  factory CaregiverDashboardModel.fromJson(Map<String, dynamic> json) {
    return CaregiverDashboardModel(
      patientName: json['patient_name'],
      patientId: json['patient_id'],
      emotionalHealth: EmotionalHealth.fromJson(json['emotional_health']),
      medication: Medication.fromJson(json['medication']),
      speechStability: SpeechStability.fromJson(json['speech_stability']),
      emergencyAlerts: (json['emergency_alerts'] as List)
          .map((e) => EmergencyAlert.fromJson(e))
          .toList(),
      lastUpdated: json['last_updated'],
    );
  }
}

class EmotionalHealth {
  final int moodScore;
  final String stressLevel;
  final List<MoodEntry> recentEntries;

  EmotionalHealth({
    required this.moodScore,
    required this.stressLevel,
    required this.recentEntries,
  });

  factory EmotionalHealth.fromJson(Map<String, dynamic> json) {
    return EmotionalHealth(
      moodScore: json['mood_score'],
      stressLevel: json['stress_level'],
      recentEntries: (json['recent_entries'] as List)
          .map((e) => MoodEntry.fromJson(e))
          .toList(),
    );
  }
}

class MoodEntry {
  final String date;
  final String mood;
  final int score;

  MoodEntry({required this.date, required this.mood, required this.score});

  factory MoodEntry.fromJson(Map<String, dynamic> json) {
    return MoodEntry(
      date: json['date'],
      mood: json['mood'],
      score: json['score'],
    );
  }
}

class Medication {
  final String nextReminder;
  final List<String> todayTaken;
  final List<String> todayPending;
  final int complianceRate;

  Medication({
    required this.nextReminder,
    required this.todayTaken,
    required this.todayPending,
    required this.complianceRate,
  });

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      nextReminder: json['next_reminder'],
      todayTaken: List<String>.from(json['today_taken']),
      todayPending: List<String>.from(json['today_pending']),
      complianceRate: json['compliance_rate'],
    );
  }
}

class SpeechStability {
  final int dailyScore;
  final String trend;
  final List<int> last7Days;

  SpeechStability({
    required this.dailyScore,
    required this.trend,
    required this.last7Days,
  });

  factory SpeechStability.fromJson(Map<String, dynamic> json) {
    return SpeechStability(
      dailyScore: json['daily_score'],
      trend: json['trend'],
      last7Days: List<int>.from(json['last_7_days']),
    );
  }
}

class EmergencyAlert {
  final String type;
  final String status;
  final String time;
  final String severity;

  EmergencyAlert({
    required this.type,
    required this.status,
    required this.time,
    required this.severity,
  });

  factory EmergencyAlert.fromJson(Map<String, dynamic> json) {
    return EmergencyAlert(
      type: json['type'],
      status: json['status'],
      time: json['time'],
      severity: json['severity'],
    );
  }
}
