import 'dart:ui';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'component/bird.dart';
import 'package:flame/sprite.dart';
import 'component/game-border.dart';

class FlyGame extends Game {
  Size screenSize;
  Rect background;
  Paint bgPainter = Paint();
  Bird bird;
  bool start = false;
  GameBorder gameBorder;

  // 开始按钮
  Sprite startSprite = Sprite('start.png');
  Rect startRect;

  @override
  void render(Canvas canvas) {
    // 绘制背景
    bgPainter.color = Color(0xff87CEEB);
    canvas.drawRect(background, bgPainter);

    if (start) {
      // 绘制小鸟
//      bird.render(canvas);
      gameBorder.render(canvas);
    } else {
      startSprite.renderRect(canvas, startRect);
    }
  }

  @override
  void update(double t) {
    if (bird == null) return;
    if (start) {
//      bird.update(t);
      gameBorder.update(t);
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
  }

  void onTapDown(TapDownDetails d) {
    if (!start) {
      if (startRect.contains(d.globalPosition)) {
        start = true;
      }
    } else {
      bird.onTapDown(d);
    }
  }
}
