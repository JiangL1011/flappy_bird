import 'dart:ui';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'component/bird.dart';
import 'package:flame/sprite.dart';
import 'component/game-border.dart';
import 'util/tool.dart';
import 'util/barrier-rect.dart';

class FlyGame extends Game {
  Size screenSize;
  Rect background;
  Paint bgPainter = Paint();
  Bird bird;
  bool start = false;
  GameBorder gameBorder;

  /*
  由于小鸟不会产生X方向的位移，并且小鸟的位置在屏幕中间偏左，所以靠屏幕右侧的方块无需计算是否会发生碰撞，
  根据小鸟右边界的坐标除以障碍方块宽度可以计算出左侧具体多少个方块会有碰撞可能，这个值会在 _init 方法中被初始化，
  这里赋值为0是因为有时候第一帧update方法会在resize方法之前执行，这时候该参数还未初始化，防止出现空指针错误所以
  先赋值为0
   */
  int _maybeCrashedBarrier = 0;

  // 开始按钮
  Sprite startSprite = Sprite('start.png');
  Rect startRect;

  @override
  void render(Canvas canvas) {
    // 绘制背景
    bgPainter.color = Color(0xff87CEEB);
    canvas.drawRect(background, bgPainter);

    // 绘制小鸟
    bird.render(canvas);
    // 绘制障碍物
    gameBorder.render(canvas);
    if (!start) {
      startSprite.renderRect(canvas, startRect);
    }
  }

  @override
  void update(double t) {
    if (bird == null) return;
    if (start) {
      bird.update(t);
      gameBorder.update(t);

      // 如果小鸟触碰到屏幕边界则游戏也结束
      if (bird.birdRect.top <= 0 || bird.birdRect.bottom >= screenSize.height) {
        start = false;
        return;
      }

      // 处理上边界碰撞
      for (int i = 0; i < Tool.min(gameBorder.top.length, _maybeCrashedBarrier); i++) {
        Barrier barrier = gameBorder.top[i];
        if (!barrier.visibility) continue;
        if (Tool.crashed(bird.birdRect, barrier.rect)) {
          start = false;
          return;
        }
      }
      // 处理下边界碰撞
      for (int i = 0; i < Tool.min(gameBorder.bottom.length, _maybeCrashedBarrier); i++) {
        Barrier barrier = gameBorder.bottom[i];
        if (!barrier.visibility) continue;
        if (Tool.crashed(bird.birdRect, gameBorder.bottom[i].rect)) {
          start = false;
          return;
        }
      }
    }
  }

  @override
  void resize(Size size) {
    screenSize = size;

    _init();

    super.resize(size);
  }

  _init() {
    // 初始化游戏背景
    background = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
    // 初始化开始游戏按钮
    startRect = Rect.fromCenter(center: Offset(screenSize.width / 2, screenSize.height * 0.3), height: 80, width: 190);
    // 初始化小鸟
    bird = new Bird(this, screenSize);
    // 初始化游戏上下边界
    gameBorder = GameBorder(screenSize);
    // 初始化可能碰撞的障碍物数量，防止边界的特殊情况，所以多计算一个，并不会太影响性能
    _maybeCrashedBarrier = bird.birdRect.right ~/ gameBorder.singleBorderWidth + 1;
  }

  void onTapDown(TapDownDetails d) {
    if (!start) {
      if (startRect.contains(d.globalPosition)) {
        _init();
        start = true;
      }
    } else {
      bird.onTapDown(d);
    }
  }
}
