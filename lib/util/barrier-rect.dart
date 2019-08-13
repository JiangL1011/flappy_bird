import 'dart:ui';

class Barrier {
  // 这个代表这个障碍物的矩形
  Rect rect;

  // 可见即为真实障碍物，撞到则游戏结束，不可见则不是障碍物，可以触碰
  bool visibility = true;

  Barrier(this.rect);

  // 移动矩形
  void shift(Offset offset) {
    rect = rect.shift(offset);
  }
}
