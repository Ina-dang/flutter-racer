import 'package:flutter/material.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 화면을 그리는곳
    return Scaffold(
      body: Stack(children: [Image.asset('assets/images/racing_main.png')]),
    );
  }
}
