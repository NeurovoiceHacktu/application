import 'package:flutter/services.dart';

class FaceMeshChannel {
  static const MethodChannel _channel = MethodChannel('facemesh_channel');

  static Future<Map<String, dynamic>> start() async {
    final result = await _channel.invokeMethod<Map>('startFaceAnalysis');
    return Map<String, dynamic>.from(result ?? {});
  }
}
