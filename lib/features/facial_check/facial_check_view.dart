import 'dart:convert';
import 'dart:io';
import 'package:application/core/models/face_result.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class FacialCheckView extends StatefulWidget {
  const FacialCheckView({super.key});

  @override
  State<FacialCheckView> createState() => _FacialCheckViewState();
}

class _FacialCheckViewState extends State<FacialCheckView> {
  late final WebViewController _controller;
  bool _isLoading = true;

  // 🔗 React app
  static const String facialCheckUrl =
      'https://level2-mediapipe-website.onrender.com';

  // 🔗 Backend API (CHANGE TO YOUR RENDER URL)
  static const String backendUrl =
      'https://neurovoice-db.onrender.com/api/face-results';
  
  // 🔗 Local backend for dashboard data aggregation
  static const String localBackendUrl =
      'http://192.168.1.100:5000/api/facial/result'; // UPDATE WITH YOUR IP

  @override
  void initState() {
    super.initState();

    // ---------- PLATFORM CREATION PARAMS ----------
    final PlatformWebViewControllerCreationParams params =
        (!kIsWeb && Platform.isIOS)
            ? WebKitWebViewControllerCreationParams(
                allowsInlineMediaPlayback: true,
                mediaTypesRequiringUserAction:
                    const <PlaybackMediaTypes>{},
              )
            : const PlatformWebViewControllerCreationParams();

    _controller =
        WebViewController.fromPlatformCreationParams(params)
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(Colors.white)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (_) {
                setState(() => _isLoading = true);
              },
              onPageFinished: (_) {
                setState(() => _isLoading = false);
              },
              onWebResourceError: (error) {
                debugPrint('WebView error: $error');
              },
            ),
          )
          ..addJavaScriptChannel(
            'assessmentResult',
            onMessageReceived: (message) async {
              debugPrint('🧠 Facial result received: ${message.message}');
              debugPrint('🔥 JS MESSAGE RECEIVED');
              debugPrint('RAW MESSAGE: ${message.message}');

              final decoded = jsonDecode(message.message);
              final result = FacialResult.fromJson(decoded);

              await _sendFaceResultToBackend(result);

              debugPrint('✅ Result sent to backend');
            },
          )
          ..loadRequest(Uri.parse(facialCheckUrl));

    // ---------- ANDROID AUTOPLAY ----------
    if (!kIsWeb && Platform.isAndroid) {
      final androidController =
          _controller.platform as AndroidWebViewController;
      androidController.setMediaPlaybackRequiresUserGesture(false);
    }
  }

  // ---------- SEND RESULT TO BACKEND ----------
  Future<void> _sendFaceResultToBackend(FacialResult result) async {
    final resultData = {
      'userId': 'demo-user', // TODO: replace with real user id later
      'percentage': result.percentage,
      'level': result.level,
      'blinkRate': result.blinkRate,
      'motion': result.motion,
      'asymmetry': result.asymmetry,
      'timestamp': DateTime.now().toIso8601String(),
    };

    // Send to original backend (for record keeping)
    try {
      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(resultData),
      );

      if (response.statusCode != 201) {
        debugPrint('⚠️ Original backend save failed: ${response.statusCode}');
      } else {
        debugPrint('✅ Saved to original backend');
      }
    } catch (e) {
      debugPrint('⚠️ Original backend error: $e');
    }

    // ALSO send to local backend (for dashboard data)
    try {
      final localResponse = await http.post(
        Uri.parse(localBackendUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'percentage': result.percentage,
          'level': result.level,
          'blinkRate': result.blinkRate,
          'motion': result.motion,
          'asymmetry': result.asymmetry,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      ).timeout(const Duration(seconds: 3));

      if (localResponse.statusCode == 200) {
        debugPrint('✅ Saved to local backend for dashboards');
      }
    } catch (e) {
      debugPrint('⚠️ Local backend not reachable (dashboards may show old data): $e');
      // Don't throw - local backend is optional for core functionality
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Facial Assessment'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),

          if (_isLoading)
            Container(
              color: Colors.white,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Initializing camera & facial analysis…',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
