import '../fly-game.dart';
import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flutter/gestures.dart';
import 'package:flame/flare_animation.dart';

class Bird {
  final FlyGame game;
  final Sprite bird = new Sprite('angrybird.png');
  Rect birdRect;
  FlareAnimation helicopterFlare;
  bool helicopterLoaded = false;

  // 上一帧结束时刻的速度
  // 用于和update中的时间增量计算位移
  // 下落时速度为负数，上升时为正数
  double _lastFrameEndSpeed = 0;

  // 点击屏幕后获得的向上飞行的初速度 像素每秒
  static double _flyUpSpeed = 450;

  // 重力加速度 像素/秒平方
  static double _g = 1200;

  // 点击屏幕后可以飞行的最大高度，根据公式 mgh=1/2mv^2  =>  h=(0.5v^2)/g 得到
  static double flyHeight = (0.5 * _flyUpSpeed * _flyUpSpeed) / _g;

  Bird(this.game, Size screenSize) {
    birdRect = Rect.fromCenter(center: Offset(screenSize.width * 0.35, screenSize.height / 2), width: 50, height: 50);
    loadHelicopterFlare(screenSize);
  }

  void render(Canvas canvas) {
//    bird.renderRect(canvas, birdRect);
    if (helicopterLoaded) {
      helicopterFlare.render(canvas);
    }
  }

  void update(double t) {
    double offsetY = _gravity(t, _lastFrameEndSpeed);
    _lastFrameEndSpeed -= (_g * t);
//    birdRect = birdRect.shift(Offset(0, offsetY));
    if (helicopterLoaded) {
      helicopterFlare.y += offsetY;
      helicopterFlare.update(t);
    }
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

  // 使用flare动画
  void loadHelicopterFlare(Size screenSize) async {
    helicopterFlare = await FlareAnimation.load("assets/flare/helicopter.flr");
    helicopterFlare.updateAnimation("fly");

    helicopterFlare.x = screenSize.width * 0.35;
    helicopterFlare.y = screenSize.height / 2;

    helicopterFlare.width = 180;
    helicopterFlare.height = 180;

    helicopterLoaded = true;
  }
}
