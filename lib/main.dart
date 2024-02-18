import 'package:flutter/material.dart';
import 'package:gemini_sample/screens/home.dart';

void main() async {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Gemini Sample Project",
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
