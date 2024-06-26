import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/text.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter_racer/components/life_heart.dart';
import 'package:flutter_racer/components/obstacle.dart';

import '../components/move_button.dart';
import '../components/player.dart';

class RacingGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  /// 게임 로직에 사용될 오브젝트 클래스 선언
  late Player player; // late => 늦게 하겠다
  late MoveButton leftMoveBtn, rightMoveBtn;
  List<LifeHeart> lifeHeartList = [];

  /// 로드 될 이미지 변수 선언
  late Sprite playerSprite;
  late Sprite obstacleSprite;
  late Sprite leftMoveButtonSprite;
  late Sprite rightMoveButtonSprite;

  int currentScore = 0; // 현재 점수
  late TextComponent scoreText;

  double nextSpawnSeconds = 0; // 다음 장애물 생성까지의 시간
  Function onGameOver; // 게임오버가 된걸 알려주는 콜백함수
  int playerDirection = 0; // 플레이어 이동 방향 상태 변수 (0: 정지, 1: 오른쪽, -1: 왼쪽)

  // 생성자 추가 해서 뒤 화면으로 보낼수 있도록 gameOver callback 만들기
  RacingGame({required this.onGameOver});

  @override
  Color backgroundColor() {
    return Color(0xffa2a2a2);
  }

  /// 게임개발 생명주기
  @override
  Future<void> onLoad() async {
    // 1. 스프라이트 이미지 로드
    Image playerImg = await images.load('racing_car.png');
    Image obstacleImg = await images.load('barrier.png');
    Image heartImg = await images.load('heart.png');
    Image leftMoveImg = await images.load('left.png');
    Image rightMoveImg = await images.load('right.png');

    // 2. 스프라이트 오브젝트 생성
    playerSprite = Sprite(playerImg);
    obstacleSprite = Sprite(obstacleImg);
    leftMoveButtonSprite = Sprite(leftMoveImg);
    rightMoveButtonSprite = Sprite(rightMoveImg);

    lifeHeartList.add(LifeHeart(
      position: Vector2(30, 60),
      heartSprite: Sprite(heartImg),
    ));
    lifeHeartList.add(LifeHeart(
      position: Vector2(60, 60),
      heartSprite: Sprite(heartImg),
    ));
    lifeHeartList.add(LifeHeart(
      position: Vector2(90, 60),
      heartSprite: Sprite(heartImg),
    ));

    //  스코어 텍스트 컴포넌트
    scoreText = TextComponent(
      text: "0",
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: 32,
          color: Color(0xff000000),
          fontWeight: FontWeight.bold,
        ),
      ),
      anchor: Anchor.topRight,
      position: Vector2(size.x - 60, 50),
    );

    // 3. player 생성 size. 은 디바이스 사이즈의 x, y
    player = Player(
      position: Vector2(size.x * 0.25, size.y - 20),
      playerSprite: playerSprite,
      damageCallback: onDamage,
    );

    // 4. movebutton 생성
    leftMoveBtn = MoveButton(
      direction: 'left',
      position: Vector2(30, size.y - 80),
      moveButtonSprite: leftMoveButtonSprite,
      onTabMoveButton: (isTapping) {
        if (isTapping) {
          playerDirection = -1;
        } else {
          playerDirection = 0;
        }
      },
    );

    rightMoveBtn = MoveButton(
      direction: 'right',
      position: Vector2(size.x - 30, size.y - 80),
      moveButtonSprite: rightMoveButtonSprite,
      onTabMoveButton: (isTapping) {
        if (isTapping) {
          playerDirection = 1;
        } else {
          playerDirection = 0;
        }
      },
    );

    // 5. 플레이어 컴포넌트 추가
    add(player);
    add(leftMoveBtn);
    add(rightMoveBtn);
    for (LifeHeart lifeHeart in lifeHeartList) {
      add(lifeHeart);
    }
    add(scoreText);

    // 6. 배경음악 재생
    startBgmMusic();
  }

  // 종료되었을 때 생명주기
  @override
  void onDispose() {
    stopBgmMusic();
    super.onDispose();
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (paused) {
      // 일시정지 == 게임오버 상황일 때 내부 로직 수행
      onGameOver.call();
    }
    super.onTapUp(event);
  }

  @override
  void update(double dt) {
    super.update(dt);

    /// 장애물 랜덤 생성
    nextSpawnSeconds -= dt;
    if (nextSpawnSeconds < 0) {
      add(Obstacle(
          position: Vector2(size.x * Random().nextDouble() * 1, 0),
          obstacleSprite: obstacleSprite));
    }
    // 장애물생성 시간 랜덤
    nextSpawnSeconds = 0.3 * Random().nextDouble() * 2;

    /// 스코어 증가 로직
    if (!paused) {
      currentScore++;
      scoreText.text = currentScore.toString();
    }

    /// player move 로직
    if (playerDirection == 1) {
      // 오른쪽 이동
      player.position = Vector2(
          player.position.x >= size.x - 30
              ? player.position.x
              : player.position.x + 7,
          player.position.y);
    } else if (playerDirection == -1) {
      // 왼쪽 이동
      player.position = Vector2(
          player.position.x <= 30 ? player.position.x : player.position.x - 7,
          player.position.y);
    } else {
      // 아무 버튼도 조작하고 있지 않을 때
      player.position = Vector2(player.position.x, player.position.y);
    }
  }

  void onDamage() {
    // 플레이어가 데미지를 입었을 때 하트가 감소하는 메서드
    print('onDamage');
    print(lifeHeartList.isNotEmpty);
    if (lifeHeartList.isNotEmpty) {
      FlameAudio.play('sfx/car_crash.ogg'); // 일회성 사운드
      remove(lifeHeartList[lifeHeartList.length - 1]);
      lifeHeartList.removeLast();
      return;
    }

    // 게임오버 표시
    add(
      TextComponent(
        text: "  GAME OVER \nTouch To Main",
        textRenderer: TextPaint(
          style: TextStyle(
            fontSize: 32,
            color: Color(0xff000000),
            fontWeight: FontWeight.bold,
          ),
        ),
        anchor: Anchor.center,
        position: Vector2(size.x / 2, size.y / 2),
      ),
    );

    // 일정 딜레이 이후에 게임 일시정지
    Future.delayed(Duration(milliseconds: 500), () {
      paused = true;
    });
  }

  void startBgmMusic() {
    // 배경음악 재생 (실기기로 해야 노래나옴)
    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play('music/level2.wav');
  }

  void stopBgmMusic() {
    // 배경음악 정지
    FlameAudio.bgm.stop();
    FlameAudio.bgm.dispose();
  }
}
