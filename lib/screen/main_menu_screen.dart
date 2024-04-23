import 'package:flutter/material.dart';
import 'package:flutter_racer/screen/game_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /// 화면을 그리는곳
    return Scaffold(

      /// Stack: 배열 배치 순서에 따라 쌓아 올리는 위젯
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/racing_main.png',
            fit: BoxFit.cover,
            opacity: AlwaysStoppedAnimation(0.4),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              /// 제목 텍스트
              Text(
                'Flutter Racer',
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                ),
              ),

              /// 시작 (Start) 버튼
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // 버튼을 클릭하면 게임화면으로 이동
                  Navigator.push(context, MaterialPageRoute(builder: (
                      context) => GameScreen(),
                  ));
                },
                child: Text(
                  'GAME START',
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
