import 'package:flutter/material.dart';
import 'package:gemini_sample/controllers/gemini.controller.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _controller = GeminiController();

  String? advice;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          children: [
            if (loading) ...const [
              Text(
                "Please wait...",
                textAlign: TextAlign.center,
              ),
              Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator.adaptive(),
              ),
            ] else if (advice == null)
              Text(
                "Do you want me to comment on your style? Click the button below and give me your picture.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              )
            else
              Text(
                "Gemini's answer:\n$advice",
                textAlign: TextAlign.justify,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ElevatedButton(
              onPressed: getAdvice,
              child: const Text("Get Advice"),
            ),
          ],
        ),
      ),
    );
  }

  void getAdvice() async {
    setState(() {
      loading = true;
    });
    String? advice;
    try {
      advice = await _controller.getResponse();
    } catch (_) {}
    if (!mounted) return;
    setState(() {
      this.advice = advice;
      loading = false;
    });
  }
}
