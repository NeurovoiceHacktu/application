import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:application/core/network/voice_ml_api.dart';
import 'package:application/core/utils/audio_helper.dart';

/// ===============================
/// Test Type Registry (Extensible)
/// ===============================
class TestTypes {
  static const String voice = 'voice';
  static const String face = 'face';
  static const String tremors = 'tremors';
}

class VoiceCheckViewModel extends ChangeNotifier {
  final AudioRecorderService _audioService = AudioRecorderService();

  Timer? _recordingTimer;
  Timer? _progressTimer;

  int remainingSeconds = 12;
  String? recordedFilePath;
  double processProgress = 0.0;

  bool _isRecording = false;
  bool _navigateToProcessing = false;
  bool _navigateToResults = false;
  bool _disposed = false;

  /// ===============================
  /// ML OUTPUT
  /// ===============================
  bool isUploading = false;
  double? confidence; // risk_score (0–1)
  String? riskLevel; // risk_level
  String? errorMessage;

  /// ===============================
  /// CLINICAL INPUTS
  /// ===============================
  int? ac; // age category
  int? nth; // neurological test history
  int? htn; // hypertension
  final int updrs = 0; // fixed for current model

  /// ===============================
  /// BACKEND CONFIG
  /// ===============================
  static const String backendUrl =
      'https://neurovoice-db.onrender.com/api/voice-results';

  static const String userId = 'demo-user'; // replace after auth

  // ===============================
  // GETTERS
  // ===============================

  bool get isRecording => _isRecording;
  bool get shouldNavigateToProcessing => _navigateToProcessing;
  bool get shouldNavigateToResults => _navigateToResults;

  void resetNavigationFlags() {
    _navigateToProcessing = false;
    _navigateToResults = false;
  }

  // ===============================
  // CLINICAL INPUT SETTER
  // ===============================

  void setClinicalInputs({
    required int ac,
    required int nth,
    required int htn,
  }) {
    this.ac = ac;
    this.nth = nth;
    this.htn = htn;
  }

  // ===============================
  // RECORDING
  // ===============================

  Future<void> startRecording() async {
    if (_isRecording) return;

    if (ac == null || nth == null || htn == null) {
      errorMessage = 'Clinical information missing.';
      notifyListeners();
      return;
    }

    remainingSeconds = 12;
    errorMessage = null;
    notifyListeners();

    recordedFilePath = await _audioService.startRecording();
    _isRecording = true;

    _recordingTimer?.cancel();
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (remainingSeconds <= 0) {
        await stopRecording();
      } else {
        remainingSeconds--;
        notifyListeners();
      }
    });
  }

  Future<void> stopRecording() async {
    if (!_isRecording) return;

    _recordingTimer?.cancel();
    _recordingTimer = null;

    recordedFilePath = await _audioService.stopRecording();
    _isRecording = false;

    if (_disposed || recordedFilePath == null) return;

    _navigateToProcessing = true;
    notifyListeners();

    _uploadAndAnalyze();
  }

  // ===============================
  // BACKEND / ML
  // ===============================

  Future<void> _uploadAndAnalyze() async {
    isUploading = true;
    processProgress = 0.1;
    notifyListeners();

    try {
      // Progress animation
      _progressTimer?.cancel();
      _progressTimer = Timer.periodic(const Duration(milliseconds: 300), (
        timer,
      ) {
        if (!isUploading || _disposed) {
          timer.cancel();
          return;
        }
        if (processProgress < 0.9) {
          processProgress += 0.03;
          notifyListeners();
        }
      });

      final response = await VoiceMlApi.uploadWav(
        wavPath: recordedFilePath!,
        ac: ac!,
        nth: nth!,
        htn: htn!,
        updrs: updrs,
      );

      debugPrint('🧠 Raw ML response: $response');

      confidence = (response['risk_score'] as num).toDouble();
      riskLevel = response['risk_level'] as String;

      // ===============================
      // SEND RESULT TO BACKEND (NO HIVE)
      // ===============================
      await _sendVoiceResultToBackend();

      isUploading = false;
      processProgress = 1.0;
      _navigateToResults = true;
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Voice analysis failed: $e');
      isUploading = false;
      processProgress = 0.0;
      errorMessage = 'Unable to analyze voice.';
      notifyListeners();
    }
  }

  Future<void> _sendVoiceResultToBackend() async {
    final response = await http.post(
      Uri.parse(backendUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'riskScore': confidence, // 0–1
        'riskLevel': riskLevel,
        'features': {'ac': ac, 'nth': nth, 'htn': htn, 'updrs': updrs},
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to save voice result');
    }
  }

  // ===============================
  // UI HELPERS
  // ===============================

  String get formattedTime =>
      '00:${remainingSeconds.toString().padLeft(2, '0')}';

  // ===============================
  // CLEANUP
  // ===============================

  @override
  void dispose() {
    _disposed = true;
    _recordingTimer?.cancel();
    _progressTimer?.cancel();
    _audioService.dispose();
    super.dispose();
  }
}