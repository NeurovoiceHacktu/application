import 'package:application/features/voice_check/voice_check_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => VoiceCheckViewModel())],
      child: const NeuroVoiceApp(),
    ),
  );
}
