import 'package:flutter/services.dart';

class FaceSdkChannel {
  static const _channel = MethodChannel('presage_face_sdk');

  static Future<double> analyzeFace(String videoPath) async {
    final result = await _channel.invokeMethod<double>(
      'analyzeFace',
      {'videoPath': videoPath},
    );
    return result!;
  }
}
