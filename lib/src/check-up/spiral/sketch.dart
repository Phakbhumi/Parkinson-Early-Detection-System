import 'package:flutter/material.dart';

class SketchArea extends StatelessWidget {
  const SketchArea({
    super.key,
    required this.points,
    required this.onDraw,
    required this.onEndDraw,
  });

  final List<Offset?> points;
  final ValueChanged<Offset> onDraw;
  final VoidCallback onEndDraw;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      margin: const EdgeInsets.all(1),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          RenderBox renderBox = context.findRenderObject() as RenderBox;
          Offset point = renderBox.globalToLocal(details.globalPosition);
          onDraw(point);
        },
        onPanEnd: (DragEndDetails details) => onEndDraw(),
        child: Stack(
          children: [
            CustomPaint(
              painter: Sketcher(points),
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}

class Sketcher extends CustomPainter {
  Sketcher(this.points);

  final List<Offset?> points;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant Sketcher oldDelegate) {
    return oldDelegate.points != points;
  }
}
