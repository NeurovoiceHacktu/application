import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class ConversationRecorder {
  final AudioRecorder _recorder = AudioRecorder();
  String? _path;

  Future<void> start() async {
    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) throw Exception("Mic permission denied");

    final dir = await getApplicationDocumentsDirectory();
    final audioDir = Directory('${dir.path}/conversation');
    if (!audioDir.existsSync()) {
      audioDir.createSync(recursive: true);
    }

    _path =
        '${audioDir.path}/conversation_${DateTime.now().millisecondsSinceEpoch}.wav';

    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.wav,
        sampleRate: 16000, // IMPORTANT for speech analysis
        bitRate: 256000,
      ),
      path: _path!,
    );
  }

  Future<String?> stop() async {
    await _recorder.stop();
    return _path;
  }
}