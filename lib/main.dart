import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/util.dart';
import 'package:flutter/gestures.dart';
import 'fly-game.dart';
import 'package:flame/flame.dart';

void main() async {
  Util gameUtil = Util();
  await gameUtil.setOrientation(DeviceOrientation.portraitUp);
  await gameUtil.fullScreen();

  Flame.images.loadAll(<String>['angrybird.png', 'start.png']);

  FlyGame fly = FlyGame();

  runApp(fly.widget);

  TapGestureRecognizer gesture = TapGestureRecognizer();
  gesture.onTapDown = fly.onTapDown;

  gameUtil.addGestureRecognizer(gesture);
}
