import 'dart:ui';

class Tool {
  // 判断小鸟和障碍物是否发生碰撞
  static bool crashed(Rect bird, Rect barrier) {
    double birdWidth = bird.width;
    double birdHeight = bird.height;
    double birdCenterX = bird.left + birdWidth / 2;
    double birdCenterY = bird.top + birdHeight / 2;

    double barrierWidth = barrier.width;
    double barrierHeight = barrier.height;
    double barrierCenterX = barrier.left + barrierWidth / 2;
    double barrierCenterY = barrier.top + barrierHeight / 2;

    double dx = (birdCenterX - barrierCenterX).abs();
    double dy = (birdCenterY - barrierCenterY).abs();

    if (dx >= (birdWidth + barrierWidth) / 2 || dy >= (birdHeight + barrierHeight) / 2) {
      return false;
    } else {
      return true;
    }
  }

  // 取两个整数的较小值
  static int min(int a, int b) {
    return a < b ? a : b;
  }
}
