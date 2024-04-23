import 'package:flame/components.dart';

class LifeHeart extends SpriteComponent {
  Sprite heartSprite; // onload에서 맞물리기위해 전역변수 설정

  // 플레이어 (레이싱카) 최초 생성 시 초기화 되는 값 (위치, 사이즈, 앵커)
  LifeHeart({
    required position,
    required this.heartSprite,
  }) : super(
          position: position,
          size: Vector2.all(24),
          anchor: Anchor.topLeft, // 기본 배치 위치 지정
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // 스프라이트 이미지 적용
    sprite = heartSprite;
  }
}
