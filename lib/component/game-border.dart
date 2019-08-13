import 'dart:ui';
import 'bird.dart';
import '../util/barrier-rect.dart';
import 'dart:math';

/*
游戏上下边界，小鸟触碰到则游戏结束
 */
class GameBorder {
  final Size screenSize;
  List<Barrier> top = new List();
  List<Barrier> bottom = new List();
  double singleBorderWidth = 100;

  // 描边障碍物的画笔
  Paint borderStrokePainter = Paint()
    ..color = Color(0xFF000000)
    ..strokeWidth = 1
    ..style = PaintingStyle.stroke;

  // 填充障碍物的画笔
  Paint borderBackgroundPainter = Paint()
    ..color = Color(0xFFEE7942)
    ..style = PaintingStyle.fill;

  // 透明填充画笔
  Paint transparentPainter = Paint()
    ..color = Color(0x00ffffff)
    ..style = PaintingStyle.fill;

  // 初始可飞行区域高度
  double space = Bird.flyHeight * 4;

  // 初始上边界或下边界产生障碍物的概率
  double generateRate = 0.2;

  Random _random = Random();

  GameBorder(this.screenSize);

  void render(Canvas canvas) {
    top.forEach((barrier) {
      _drawBarrier(canvas, barrier);
    });

    bottom.forEach((barrier) {
      _drawBarrier(canvas, barrier);
    });
  }

  void update(double t) {
    // 移动场景
    for (int i = 0; i < top.length; i++) {
      if (top[i] != null) {
        top[i].shift(Offset(-1, 0));
      }
    }

    for (int i = 0; i < bottom.length; i++) {
      if (bottom[i] != null) {
        bottom[i].shift(Offset(-1, 0));
      }
    }

    // 移动之后根据上下边界障碍物的位置，移除超出屏幕的障碍物或者增加不足的障碍物
    changeBorder(top, true);
    changeBorder(bottom, false);
  }

  Barrier generateBorder(bool isTopBarrier) {
    Barrier barrier =
        Barrier(Rect.fromLTWH(screenSize.width, isTopBarrier ? 0 : (screenSize.height - 80), singleBorderWidth, 80));
    barrier.visibility = _random.nextBool();
    return barrier;
  }

  void changeBorder(List<Barrier> list, bool isTopBarrier) {
    if (list.length == 0) {
      list.add(generateBorder(isTopBarrier));
      return;
    }

    Barrier first = list[0];
    Barrier last = list[list.length - 1];

    // 产生的边界方块移入屏幕后再产生一个，移出屏幕后从集合中删除
    if (last.rect.right <= screenSize.width) {
      list.add(generateBorder(isTopBarrier));
    }
    if (first.rect.right <= 0) {
      list.removeAt(0);
    }
  }

  void _drawBarrier(Canvas canvas, Barrier barrier) {
    if (barrier.visibility) {
      // 画一个实体障碍物
      canvas.drawRect(barrier.rect, borderBackgroundPainter);
      canvas.drawRect(barrier.rect, borderStrokePainter);
    } else {
      // 画一个不可见的障碍物
      canvas.drawRect(barrier.rect, transparentPainter);
    }
  }

}
