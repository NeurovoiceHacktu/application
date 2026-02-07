// import 'package:application/core/network/gemini_service.dart';
// import 'package:application/core/utils/conversation_recorder.dart';
// import 'package:application/core/utils/conversation_tts.dart';
// import 'package:flutter/material.dart';
// import 'gemini_script.dart';
// import '../../core/network/gemini_service.dart';

// final GeminiService gemini = GeminiService('https://gemini-backend-h3nu.onrender.com');

// enum ConversationState {
//   idle,
//   speaking,
//   listening,
//   finished,
// }

// class ConversationViewModel extends ChangeNotifier {
//   final ConversationTts tts = ConversationTts();
//   final ConversationRecorder recorder = ConversationRecorder();

//   ConversationState state = ConversationState.idle;
//   String currentText = '';

//   Future<void> startConversation() async {
//   await tts.init();
//   await recorder.start();

//   await _askGemini(
//     "You are a calm medical conversational assistant. "
//     "Ask one simple question to the user."
//   );
// }

//   Future<void> _askGemini(String prompt) async {
//   state = ConversationState.speaking;
//   notifyListeners();

//   final reply = await gemini.ask(prompt);
//   currentText = reply;

//   await tts.speak(reply);

//   state = ConversationState.listening;
//   notifyListeners();
// }

//   Future<void> next() async {
//   if (state != ConversationState.listening) return;

//   await _askGemini(
//     "Ask the next simple follow-up question. "
//     "Keep it short and clear."
//   );
// }

//   Future<void> finish() async {
//     state = ConversationState.finished;
//     notifyListeners();

//     final path = await recorder.stop();
//     debugPrint("Conversation audio saved at $path");
//   }
// }

import 'package:application/core/network/gemini_service.dart';
import 'package:application/core/utils/conversation_recorder.dart';
import 'package:application/core/utils/conversation_tts.dart';
import 'package:flutter/material.dart';

enum ConversationState { idle, speaking, listening, finished }

class ConversationDemoViewModel extends ChangeNotifier {
  final FakeGeminiEngine engine = FakeGeminiEngine();
  final ConversationTts tts = ConversationTts();
  final ConversationRecorder recorder = ConversationRecorder();

  ConversationState state = ConversationState.idle;
  String currentText = "";

  Future<void> start() async {
    await tts.init();
    await recorder.start();
    _speakNext();
  }

  Future<void> _speakNext() async {
    final text = engine.next();
    if (text.isEmpty) {
      await finish();
      return;
    }

    currentText = text;
    state = ConversationState.speaking;
    notifyListeners();

    await tts.speak(text);

    state = ConversationState.listening;
    notifyListeners();
  }

  Future<void> next() async {
    if (state == ConversationState.listening) {
      await _speakNext();
    }
  }

  Future<void> finish() async {
    state = ConversationState.finished;
    notifyListeners();
    await recorder.stop();
  }
}