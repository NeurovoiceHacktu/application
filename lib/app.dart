import 'package:flutter/material.dart';
import 'shared/navigation/app_router.dart';

class NeuroVoiceApp extends StatelessWidget {
  const NeuroVoiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeuroVoice',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: '/',
    );
  }
}