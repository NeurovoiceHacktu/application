import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TremorCheckViewModel extends ChangeNotifier {
  // Backend URLs
  static const String backendUrl =
      'https://backend-h5ha.onrender.com'; // UPDATE WITH YOUR IP
  // For Android emulator: 'http://10.0.2.2:5000'
  // For iOS simulator: 'http://localhost:5000'
  // For real device: 'http://YOUR_COMPUTER_IP:5000'

  // Database backend for storing results (same as voice and face)
  static const String databaseBackendUrl =
      'https://neurovoice-db.onrender.com/api/tremor-results';

  static const String userId =
      'demo-user'; // Replace with real user ID after auth

  bool isRecording = false;
  bool isProcessing = false;
  int countdown = 10;
  List<Map<String, dynamic>> sensorData = [];
  Timer? recordingTimer;
  Timer? countdownTimer;

  // Results
  String? riskLevel;
  double? confidence;
  double? tremorFrequency;
  int? severityScore;
  List<String> recommendations = [];
  String? modelUsed; // Track which model was used

  // Simulate sensor data collection with realistic tremor patterns
  void startTremorTest() {
    isRecording = true;
    countdown = 10;
    sensorData.clear();
    notifyListeners();

    // Generate a random tremor pattern for this test (varies each time)
    final random = Random();
    final baseAmplitude = random.nextDouble() * 0.5 + 0.1; // 0.1 to 0.6
    final tremorFreq =
        random.nextDouble() * 3 + 4; // 4-7 Hz (typical PD tremor)
    final noiseLevel = random.nextDouble() * 0.1; // Random noise
    var timestamp = 0.0;

    // Start countdown
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        countdown--;
        notifyListeners();
      } else {
        timer.cancel();
        stopRecording();
      }
    });

    // Simulate sensor data collection (collect data every 10ms for 100Hz sampling)
    recordingTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (isRecording) {
        // Generate realistic accelerometer data with tremor pattern
        // Gravity component + tremor oscillation + noise
        final t = timestamp;

        // Gravity components (phone held in hand, slight variations)
        final gravityX = 0.15 + (random.nextDouble() - 0.5) * 0.05;
        final gravityY = -9.75 + (random.nextDouble() - 0.5) * 0.1;
        final gravityZ = 0.23 + (random.nextDouble() - 0.5) * 0.05;

        // Tremor oscillations at tremor frequency
        final tremorX = baseAmplitude * sin(2 * pi * tremorFreq * t);
        final tremorY =
            baseAmplitude * 0.7 * sin(2 * pi * tremorFreq * t + 0.5);
        final tremorZ = baseAmplitude * 0.5 * cos(2 * pi * tremorFreq * t);

        // Random noise
        final noiseX = (random.nextDouble() - 0.5) * noiseLevel;
        final noiseY = (random.nextDouble() - 0.5) * noiseLevel;
        final noiseZ = (random.nextDouble() - 0.5) * noiseLevel;

        sensorData.add({
          'timestamp': timestamp,
          'x': gravityX + tremorX + noiseX,
          'y': gravityY + tremorY + noiseY,
          'z': gravityZ + tremorZ + noiseZ,
        });

        timestamp += 0.01; // Increment by 10ms
      }
    });
  }

  void stopRecording() {
    isRecording = false;
    countdownTimer?.cancel();
    recordingTimer?.cancel();
    notifyListeners();

    // Analyze the collected data
    analyzeTremorData();
  }

  Future<void> analyzeTremorData() async {
    if (sensorData.isEmpty) {
      print('No sensor data collected');
      return;
    }

    isProcessing = true;
    notifyListeners();

    try {
      // Send data to backend for analysis
      final response = await http
          .post(
            Uri.parse('$backendUrl/api/tremor/analyze'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'sensor_data': sensorData}),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw TimeoutException('Request timeout');
            },
          );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        riskLevel = data['risk_level'];
        confidence = (data['confidence'] as num).toDouble();
        tremorFrequency = (data['tremor_frequency'] as num).toDouble();
        severityScore = data['severity_score'] as int;
        recommendations = List<String>.from(data['recommendations'] ?? []);
        modelUsed = data['model_used'] ?? 'Unknown';

        print('✅ Analysis complete: $riskLevel with ${confidence.toString()}% confidence',
        );
        print('   Model used: $modelUsed');

        // Save results to database backend
        await _saveTremorResultToDatabase();
      } else {
        throw Exception(
          'Failed to analyze tremor data: ${response.statusCode}',
        );
      }
    } on TimeoutException catch (e) {
      print('Timeout error: $e');
      // Use fallback fake data if backend is not available
      _useFallbackData();
      // Still try to save fallback results to database
      await _saveTremorResultToDatabase();
    } catch (e) {
      print('Error analyzing tremor data: $e');
      // Use fallback fake data if backend is not available
      _useFallbackData();
      // Still try to save fallback results to database
      await _saveTremorResultToDatabase();
    } finally {
      isProcessing = false;
      notifyListeners();
    }
  }

  Future<void> _saveTremorResultToDatabase() async {
    if (riskLevel == null || confidence == null) {
      print('⚠️ No tremor results to save');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(databaseBackendUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'type': 'tremor',
          'level': riskLevel,
          'score': confidence,
          'riskLevel': riskLevel,
          'confidence': confidence,
          'tremorFrequency': tremorFrequency ?? 0.0,
          'severityScore': severityScore ?? 0,
          'recommendations': recommendations,
          'modelUsed': modelUsed ?? 'Unknown',
          'timestamp': DateTime.now().toIso8601String(),
        }),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('✅ Tremor results saved to database');
      } else {
        print('⚠️ Failed to save to database: ${response.statusCode}');
      }
    } catch (e) {
      print('⚠️ Error saving to database: $e');
      // Don't throw - saving to database is optional
    }
  }

  void _useFallbackData() {
    // Fallback data when backend is unavailable
    // Generate varied results based on sensor data variance for realism
    final random = Random();

    // Calculate variance from collected sensor data
    if (sensorData.isNotEmpty) {
      final xValues = sensorData.map((d) => d['x'] as double).toList();
      final variance = _calculateVariance(xValues);

      // Map variance to confidence (higher variance = higher tremor risk)
      confidence = (55 + variance * 150).clamp(50.0, 95.0);
    } else {
      confidence = 60.0 + random.nextDouble() * 30; // 60-90
    }

    // Determine risk level based on confidence
    if (confidence! >= 75) {
      riskLevel = 'High';
    } else if (confidence! >= 60) {
      riskLevel = 'Medium';
    } else {
      riskLevel = 'Low';
    }

    tremorFrequency = 4.0 + random.nextDouble() * 4; // 4-8 Hz
    severityScore = (confidence! * 0.85).toInt();
    recommendations = _getRecommendations(riskLevel!);
    modelUsed = 'Fallback (Backend Unavailable)';

    print(
      '⚠️ Using fallback data: $riskLevel (${confidence!.toStringAsFixed(1)}%)',
    );
  }

  double _calculateVariance(List<double> values) {
    if (values.isEmpty) return 0.0;
    final mean = values.reduce((a, b) => a + b) / values.length;
    final sumSquaredDiff = values
        .map((x) => pow(x - mean, 2))
        .reduce((a, b) => a + b);
    return sumSquaredDiff / values.length;
  }

  List<String> _getRecommendations(String risk) {
    switch (risk) {
      case 'High':
        return [
          'Immediate consultation recommended',
          'Review medication with doctor',
          'Avoid activities requiring fine motor control',
        ];
      case 'Medium':
        return [
          'Schedule follow-up with neurologist',
          'Monitor symptoms closely',
          'Ensure medication compliance',
        ];
      default:
        return [
          'Continue regular monitoring',
          'Maintain healthy lifestyle',
          'Practice hand exercises daily',
        ];
    }
  }

  void reset() {
    isRecording = false;
    isProcessing = false;
    countdown = 10;
    sensorData.clear();
    riskLevel = null;
    confidence = null;
    tremorFrequency = null;
    severityScore = null;
    recommendations.clear();
    recordingTimer?.cancel();
    countdownTimer?.cancel();
    notifyListeners();
  }

  @override
  void dispose() {
    recordingTimer?.cancel();
    countdownTimer?.cancel();
    super.dispose();
  }
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);

  @override
  String toString() => message;
}
