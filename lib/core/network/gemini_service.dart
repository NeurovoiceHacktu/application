// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class GeminiService {
//   final String baseUrl;

//   GeminiService(this.baseUrl);

//   Future<String> ask(String prompt) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/conversation'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'prompt': prompt}),
//     );

//     if (response.statusCode != 200) {
//       throw Exception('Backend Gemini call failed');
//     }

//     final data = jsonDecode(response.body);
//     return data['text'] as String;
//   }
// }

import 'dart:math';

class FakeGeminiEngine {
  int _step = 0;
  final _rand = Random();

  final List<List<String>> _responses = [
    [
      "Hello. How are you feeling today?",
      "Hi. How have you been feeling today?",
      "Hello. How do you feel right now?",
    ],
    [
      "Can you tell me what you did earlier today?",
      "Please describe your day so far.",
      "What activities did you do earlier today?",
    ],
    [
      "Did you notice any difficulty while speaking or moving?",
      "Have you experienced any issues with speech or movement?",
    ],
    [
      "Can you describe something that made you happy recently?",
      "Tell me about something positive from recent days.",
    ],
    [
      "Thank you. The voice assessment is now complete.",
    ],
  ];

  String next() {
    if (_step >= _responses.length) return "";
    final options = _responses[_step++];
    return options[_rand.nextInt(options.length)];
  }

  bool get isFinished => _step >= _responses.length;
}