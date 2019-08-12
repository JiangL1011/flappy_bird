import 'dart:ui';
import 'bird.dart';
import '../util/barrier-rect.dart';

/*
游戏上下边界，小鸟触碰到则游戏结束
 */
class GameBorder {
  final Size screenSize;
  List<BarrierRect> top = new List();
  List<BarrierRect> bottom = new List();
  double singleBorderWidth = 100;
  Paint borderStrokePainter = Paint()
    ..color = Color(0xFF000000)
    ..strokeWidth = 1
    ..style = PaintingStyle.stroke;
  Paint borderBackgroundPainter = Paint()
    ..color = Color(0xFFEE7942)
    ..style = PaintingStyle.fill;
  // 初始可飞行区域高度
  double space = Bird.flyHeight * 4;
  // 初始上边界或下边界产生障碍物的概率
  double generateRate = 0.2;

  GameBorder(this.screenSize);

  void render(Canvas canvas) {
    top.forEach((rect) {
      canvas.drawRect(rect, borderBackgroundPainter);
      canvas.drawRect(rect, borderStrokePainter);
    });

    bottom.forEach((rect) {
      canvas.drawRect(rect, borderBackgroundPainter);
      canvas.drawRect(rect, borderStrokePainter);
    });
  }

  void update(double t) {
    // 移动场景
    for (int i = 0; i < top.length; i++) {
      if (top[i] != null) {
        top[i] = top[i].shift(Offset(-1, 0));
      }
    }

    for (int i = 0; i < bottom.length; i++) {
      if (bottom[i] != null) {
        bottom[i] = bottom[i].shift(Offset(-1, 0));
      }
    }

    // 移动之后根据上下边界障碍物的位置，移除超出屏幕的障碍物或者增加不足的障碍物
    changeBorder(top, true);
    changeBorder(bottom, false);
  }

  BarrierRect generateBorder(bool isTopBarrier) {
    return BarrierRect.fromLTWH(screenSize.width, isTopBarrier ? 0 : (screenSize.height - 80), singleBorderWidth, 80);
  }

  void changeBorder(List<BarrierRect> list, bool isTopBarrier) {
    if (list.length == 0) {
      list.add(generateBorder(isTopBarrier));
      return;
    }

    BarrierRect first = list[0];
    BarrierRect last = list[list.length - 1];

    // 产生的边界方块移入屏幕后再产生一个，移出屏幕后从集合中删除
    if (last.right <= screenSize.width) {
      list.add(generateBorder(isTopBarrier));
    }
    if (first.right <= 0) {
      list.removeAt(0);
    }
  }
}
