import 'dart:convert';
import 'dart:io';

import 'package:neurovoice_app/core/models/face_result.dart';
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
    final response = await http.post(
      Uri.parse(backendUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': 'demo-user', // TODO: replace with real user id later
        'percentage': result.percentage,
        'level': result.level,
        'blinkRate': result.blinkRate,
        'motion': result.motion,
        'asymmetry': result.asymmetry,
      }),
    );

    if (response.statusCode != 201) {
      debugPrint('❌ Failed to send result: ${response.body}');
      throw Exception('Failed to store facial result');
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
