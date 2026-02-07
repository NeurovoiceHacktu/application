import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

class FaceApi {
  final String baseUrl;
  FaceApi(this.baseUrl);

  Future<double> analyzeFace(String videoPath) async {
  final uri = Uri.parse('$baseUrl/face/analyze');
  final request = http.MultipartRequest('POST', uri);

  request.files.add(
    await http.MultipartFile.fromPath(
      'video',
      videoPath,
    ),
  );

  debugPrint('➡️ Uploading face video to $uri');

  final streamedResponse = await request.send();
  final responseBody = await streamedResponse.stream.bytesToString();

  debugPrint('⬅️ Status code: ${streamedResponse.statusCode}');
  debugPrint('⬅️ Response body: $responseBody');

  if (streamedResponse.statusCode != 200) {
    throw Exception(
      'Face analysis failed '
      '(status ${streamedResponse.statusCode}): $responseBody',
    );
  }

  final json = jsonDecode(responseBody);
  return (json['face_risk'] as num).toDouble();
}

}
