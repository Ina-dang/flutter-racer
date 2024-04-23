import 'package:flame/components.dart';
import 'package:flame/events.dart';

class MoveButton extends SpriteComponent with TapCallbacks {
  Sprite moveButtonSprite; // onload에서 맞물리기위해 전역변수 설정
  Function(bool) onTabMoveButton; // 클릭 이벤트 전달 함수

  // 이동버튼 최초 생성 시 초기화 되는 값 (위치, 사이즈, 앵커)
  MoveButton({
    required String direction, // 왼쪽인지 오른쪽인지 결정하기위한 방향 매개변수
    required position,
    required this.moveButtonSprite,
    required this.onTabMoveButton,
  }) : super(
          position: position,
          size: Vector2.all(64),
          anchor: direction == 'left' ? Anchor.bottomLeft : Anchor.bottomRight,
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = moveButtonSprite;
  }

  @override
  void onTapDown(TapDownEvent event) {
    // 버튼을 누르고 있을때
    onTabMoveButton.call(true);
  }

  @override
  void onTapUp(TapUpEvent event) {
    // 버튼을 뗐을 때
    onTabMoveButton.call(false);
  }
}
