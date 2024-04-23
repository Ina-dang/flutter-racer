import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Obstacle extends SpriteComponent with HasGameRef, CollisionCallbacks {
  Sprite obstacleSprite; // onload에서 맞물리기위해 전역변수 설정

  // 플레이어 (레이싱카) 최초 생성 시 초기화 되는 값 (위치, 사이즈, 앵커)
  Obstacle({
    required position,
    required this.obstacleSprite,
  }) : super(
    position: position,
    size: Vector2.all(64),
    anchor: Anchor.bottomCenter, // 기본 배치 위치 지정
  );

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // sprite 적용
    sprite = obstacleSprite;
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    // 자동으로 장애물이 이동되도록 포지션 세팅
    position.y = position.y + 5;

    // 화면바깥으로 벗어나면 자동으로 오브젝트 삭제
    if (position.y - size.y > gameRef.size.y) {
      removeFromParent();
    }
  }
}
