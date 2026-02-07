import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'caregiver_model.dart';

class CaregiverViewModel extends ChangeNotifier {
  static const String backendUrl = 'http://localhost:5000';
  
  CaregiverDashboardModel? dashboardData;
  bool isLoading = false;
  String? error;

  Future<void> loadDashboardData() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('$backendUrl/api/caregiver/dashboard'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        dashboardData = CaregiverDashboardModel.fromJson(data);
      } else {
        throw Exception('Failed to load dashboard data');
      }
    } catch (e) {
      error = e.toString();
      print('Error loading caregiver dashboard: $e');
      // Use fallback data
      _loadFallbackData();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _loadFallbackData() {
    // Fallback fake data when backend is unavailable
    dashboardData = CaregiverDashboardModel.fromJson({
      'patient_name': 'Arthur Morgan',
      'patient_id': 'P12345',
      'emotional_health': {
        'mood_score': 78,
        'stress_level': 'Low',
        'recent_entries': [
          {'date': '2026-02-08', 'mood': 'Happy', 'score': 85},
          {'date': '2026-02-07', 'mood': 'Calm', 'score': 80},
          {'date': '2026-02-06', 'mood': 'Anxious', 'score': 65},
          {'date': '2026-02-05', 'mood': 'Tired', 'score': 70},
        ]
      },
      'medication': {
        'next_reminder': '04:00 PM',
        'today_taken': ['Levodopa 8:00 AM', 'Carbidopa 12:00 PM'],
        'today_pending': ['Levodopa 6:00 PM'],
        'compliance_rate': 94
      },
      'speech_stability': {
        'daily_score': 82,
        'trend': 'Improving',
        'last_7_days': [75, 78, 80, 82, 85, 83, 82]
      },
      'emergency_alerts': [
        {
          'type': 'Fall Detection',
          'status': 'Resolved',
          'time': '2026-02-06 14:30',
          'severity': 'Medium'
        },
        {
          'type': 'Missed Medication',
          'status': 'Active',
          'time': '2026-02-08 09:00',
          'severity': 'Low'
        }
      ],
      'last_updated': DateTime.now().toIso8601String(),
    });
  }

  void refresh() {
    loadDashboardData();
  }
}
