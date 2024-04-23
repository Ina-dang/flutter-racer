import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter_racer/components/obstacle.dart';

// 레이싱 카 오브젝트
class Player extends SpriteComponent with CollisionCallbacks {
  Sprite playerSprite; // onload에서 맞물리기위해 전역변수 설정
  final VoidCallback damageCallback;

  // 플레이어 (레이싱카) 최초 생성 시 초기화 되는 값 (위치, 사이즈, 앵커)
  Player(
      {required position,
      required this.playerSprite,
      required this.damageCallback})
      : super(
          position: position,
          size: Vector2.all(48),
          anchor: Anchor.bottomCenter, // 기본 배치 위치 지정
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // 스프라이트 이미지 적용
    sprite = playerSprite;

    // 충돌 감지 컴포넌트를 레이싱카에 적용
    add(RectangleHitbox());
  }

  // 충돌 시작 시 하고싶은 처리
  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    // 부딪쳤을때 other를 통해 정보를 가져옴 (충돌 대상이 장애물인 경우에만 데미지 입었다는 처리를 게임 전체에 알림)
    if (other is Obstacle) {
      damageCallback.call();
    } else {
      super.onCollisionStart(intersectionPoints, other);
    }
  }
}
