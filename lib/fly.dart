import 'dart:ui';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:flame/sprite.dart';

class Fly extends Game {
  Size screenSize;
  Sprite bird = new Sprite('angrybird.png');
  Rect birdRect;

  @override
  void render(Canvas canvas) {
    Rect background = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
    Paint bgPainter = Paint();
    bgPainter.color = Color(0xffAEEEEE);
    canvas.drawRect(background, bgPainter);

    bird.renderRect(canvas, birdRect);
  }

  @override
  void update(double t) {}

  @override
  void resize(Size size) {
    screenSize = size;
    birdRect = Rect.fromLTWH(screenSize.width / 2, screenSize.height / 2, 200, 200);
    super.resize(size);
  }

  void onTapDown(TapDownDetails d) {}
}
