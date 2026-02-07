import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'doctor_model.dart';

class DoctorViewModel extends ChangeNotifier {
  static const String backendUrl = 'http://localhost:5000';
  
  DoctorDashboardModel? dashboardData;
  bool isLoading = false;
  String? error;

  Future<void> loadDashboardData() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('$backendUrl/api/doctor/dashboard'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        dashboardData = DoctorDashboardModel.fromJson(data);
      } else {
        throw Exception('Failed to load dashboard data');
      }
    } catch (e) {
      error = e.toString();
      print('Error loading doctor dashboard: $e');
      // Use fallback data
      _loadFallbackData();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _loadFallbackData() {
    // Fallback fake data when backend is unavailable
    dashboardData = DoctorDashboardModel.fromJson({
      'patient_name': 'Arthur Morgan',
      'patient_id': 'P12345',
      'age': 67,
      'risk_severity': {
        'current_level': 'Medium Risk',
        'score': 68,
        'date': '2026-02-08',
        'tremor_levels': {
          'voice': 65,
          'facial': 58,
          'tremor': 72,
        }
      },
      'ai_clinical_summary': {
        'generated_at': '2026-02-08 10:30',
        'summary': '''Patient shows moderate progression of tremor symptoms over the past 3 months. 
Voice stability has improved with current medication regimen, showing 15% improvement. 
Tremor episodes are most frequent in morning hours (6-10 AM).
Recommend: Consider adjusting evening medication dosage. Schedule follow-up in 2 weeks.''',
        'key_findings': [
          'Morning tremor frequency increased by 12%',
          'Medication compliance excellent at 94%',
          'Speech clarity improved significantly',
          'Recommend gait analysis in next visit'
        ]
      },
      'disease_progression': {
        'months': ['Sep', 'Oct', 'Nov', 'Dec', 'Jan', 'Feb'],
        'tremor_scores': [45, 52, 48, 55, 60, 58],
        'voice_scores': [60, 58, 62, 65, 70, 72],
        'motor_scores': [55, 58, 54, 60, 62, 59]
      },
      'last_updated': DateTime.now().toIso8601String(),
    });
  }

  void refresh() {
    loadDashboardData();
  }
}
