import '../fly-game.dart';
import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flutter/gestures.dart';

/*
其他公式 mgh=1/2mv^2
 */
class Bird {
  final FlyGame game;
  final Sprite bird = new Sprite('angrybird.png');
  Rect birdRect;

  // 上一帧结束时刻的速度
  // 用于和update中的时间增量计算位移
  // 下落时速度为负数，上升时为正数
  double _lastFrameEndSpeed = 0;

  // 点击屏幕后获得的向上飞行的初速度 像素每秒
  double _flyUpSpeed = 400;

  // 重力加速度 像素/秒平方
  double _g = 980;

  Bird(this.game, Size screenSize) {
    birdRect = Rect.fromCenter(center: Offset(screenSize.width * 0.35, screenSize.height / 2), width: 50, height: 50);
  }

  void render(Canvas canvas) {
    bird.renderRect(canvas, birdRect);
  }

  void update(double t) {
    double offsetY = _gravity(t, _lastFrameEndSpeed);
    _lastFrameEndSpeed -= (_g * t);
    birdRect = birdRect.shift(Offset(0, offsetY));
  }

  void onTapDown(TapDownDetails d) {
    // 点击后给小鸟一个向上的初速度
    _lastFrameEndSpeed = _flyUpSpeed;
  }

  // 根据重力加速度以及当前速度计算t时间后移动的距离
  // time 已飞行时间
  // v 初速度
  double _gravity(double time, double v) {
    // 由于游戏的Y轴坐标的0点在顶部，所以计算出的距离应取相反数
    return -(v * time - 0.5 * _g * time * time);
  }
}
