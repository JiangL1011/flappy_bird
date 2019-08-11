import 'dart:ui';

/*
游戏上下边界，小鸟触碰到则游戏结束
 */
class GameBorder {
  final Size screenSize;
  List<Rect> top = new List();
  List<Rect> bottom = new List();
  double singleBorderWidth = 40;
  int maxBorderRectMount;
  Paint borderPainter = Paint()
    ..color = Color(0xFFCD9B1D)
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke;

  GameBorder(this.screenSize) {
    this.maxBorderRectMount = screenSize.width ~/ singleBorderWidth + 1;
  }

  void render(Canvas canvas) {
    top.forEach((rect) {
      canvas.drawRect(rect, borderPainter);
    });

    bottom.forEach((rect) {
      canvas.drawRect(rect, borderPainter);
    });
  }

  void update(double t) {
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

    changeBorder(top, true);
    changeBorder(bottom, false);
  }

  Rect generateBorder(bool top) {
    return Rect.fromLTWH(screenSize.width, top ? 0 : (screenSize.height - 80), singleBorderWidth, 80);
  }

  void changeBorder(List<Rect> list, bool top) {
    if (list.length == 0) {
      list.add(generateBorder(top));
      return;
    }

    Rect first = list[0];
    Rect last = list[list.length - 1];

    // 产生的边界方块移入屏幕后再产生一个，移出屏幕后从集合中删除
    if (last.right <= screenSize.width) {
      list.add(generateBorder(top));
    }
    if (first.right <= 0) {
      list.removeAt(0);
    }
  }
}
