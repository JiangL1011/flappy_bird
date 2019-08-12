import 'dart:ui';

class BarrierRect extends Rect {
  BarrierRect.fromLTWH(double left, double top, double width, double height) : super.fromLTWH(left, top, width, height);


  bool _barrier = true;

  bool get isBarrier {
    return this._barrier;
  }

  set isBarrier(bool isBarrier) {
    this._barrier = isBarrier;
  }

  BarrierRect shift(Offset offset) {
    Rect rect = super.shift(offset);
    return rect as BarrierRect;
  }
}
