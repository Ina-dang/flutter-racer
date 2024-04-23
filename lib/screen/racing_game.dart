import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter_racer/components/life_heart.dart';
import 'package:flutter_racer/components/obstacle.dart';

import '../components/player.dart';

class RacingGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  /// 게임 로직에 사용될 오브젝트 클래스 선언
  late Player player; // late => 늦게 하겠다
  // late MoveButton leftMoveBtn, rightMoveBtn;
  List<LifeHeart> lifeHeartList = [];

  /// 로드 될 이미지 변수 선언
  late Sprite playerSprite;
  late Sprite obstacleSprite;
  late Sprite leftMoveButtonSprite;
  late Sprite rightMoveButtonSprite;

  double nextSpawnSeconds = 0; // 다음 장애물 생성까지의 시간
  int currentScore = 0; // 현재 점수
  // Function onGameOver; // 게임오버가 된걸 알려주는 콜백함수

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

    // 3. player 생성 size. 은 디바이스 사이즈의 x, y
    player = Player(
      position: Vector2(size.x * 0.25, size.y - 20),
      playerSprite: playerSprite,
      damageCallback: onDamage,
    );

    // 플레이어 컴포넌트 추가
    add(player);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // 장애물 랜덤 생성
    nextSpawnSeconds -= dt;
    if (nextSpawnSeconds < 0) {
      add(Obstacle(
          position: Vector2(size.x * Random().nextDouble() * 1, 0),
          obstacleSprite: obstacleSprite));
    }
    // 장애물생성 시간 랜덤
    nextSpawnSeconds = 0.3 * Random().nextDouble() * 2;
  }

  void onDamage() {
    // 플레이어가 데미지를 입었을 때 하트가 감소하는 메서드
    print('onDamage');
  }
}
