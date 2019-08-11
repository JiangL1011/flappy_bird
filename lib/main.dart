import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/util.dart';
import 'package:flutter/gestures.dart';
import 'fly.dart';
import 'package:flame/flame.dart';

void main() async {
  Util gameUtil = Util();
  gameUtil.setOrientation(DeviceOrientation.portraitUp);
  gameUtil.fullScreen();

  Flame.images.loadAll(<String>['angrybird.png']);

  Fly fly = Fly();

  runApp(fly.widget);

  TapGestureRecognizer gesture = TapGestureRecognizer();
  gesture.onTapDown = fly.onTapDown;

  gameUtil.addGestureRecognizer(gesture);
}
