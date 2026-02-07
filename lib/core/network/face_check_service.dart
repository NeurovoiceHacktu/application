// import 'dart:io';
// import 'package:camera/camera.dart';

// class FaceCameraService {
//   late CameraController controller;

//   Future<void> initialize(CameraDescription camera) async {
//     controller = CameraController(
//       camera,
//       ResolutionPreset.medium,
//       enableAudio: false,
//     );
//     await controller.initialize();
//   }

//   Future<String> recordFaceVideo({int seconds = 25}) async {
//     await controller.startVideoRecording();
//     await Future.delayed(Duration(seconds: seconds));
//     final file = await controller.stopVideoRecording();
//     return file.path;
//   }

//   void dispose() {
//     controller.dispose();
//   }
// }
