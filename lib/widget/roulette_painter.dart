import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../utils.dart';

class RoulettePainter extends CustomPainter {
  List cards;
  BuildContext context;

  RoulettePainter({
    @required this.cards,
    @required this.context,
  });

  void drawCircle(Canvas canvas, Size size) {
    final radius = size.width / 2;
    final center = Offset(radius, radius);
    final paint = Paint()
      ..color = Theme.of(context).textTheme.headline3.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, radius, paint);
  }

  void drawBoard(Canvas canvas, Size size, Color color, double startAngle,
      double sweepAngle) {
    final radius = size.width / 2;
    final center = Offset(radius, radius);
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    final fangPath = Path()
      ..moveTo(center.dx, center.dy)
      ..arcTo(rect, startAngle, sweepAngle, false)
      ..close();

    final paint = Paint()..color = color;
    canvas.drawPath(fangPath, paint);
  }

  void drawLine(Canvas canvas, Size size, double startAngle, double sweepAngle) {
    final radius = size.width / 2;
    final p1 = Offset(radius, radius);
    final p2 = Offset(radius + radius * sin(startAngle + pi / 2), radius + radius * cos(startAngle + pi / 2));
    final paint = Paint()
      ..color = Theme.of(context).textTheme.headline3.color
      ..strokeWidth = 3;
    canvas.drawLine(p1, p2, paint);
  }

  void drawText(Canvas canvas, Size size, String text, double startAngle,
      double sweepAngle) {
    final radius = size.width / 2;
    final textStyle = ui.TextStyle(
      color: Theme.of(context).textTheme.bodyText1.color,
      fontSize: 20,
    );
    final paragraphStyle = ui.ParagraphStyle(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.right,
    );
    final paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(textStyle)
      ..addText(text);
    final constraints = ui.ParagraphConstraints(width: radius);
    final paragraph = paragraphBuilder.build();
    paragraph.layout(constraints);

    // -5 to move the text away from the edge of circle
    // align middle for y-axis
    final offset = Offset(-5, -paragraph.height / 2);

    canvas.save();
    canvas
      ..translate(radius, radius)
      ..rotate(startAngle + sweepAngle / 2)
      ..drawParagraph(paragraph, offset);
    canvas.restore();
  }

  @override
  void paint(Canvas canvas, Size size) {
    drawCircle(canvas, size);

    final sweepingAngle = 2 * pi / cards.length;

    for (int i = 0; i < cards.length; i++) {
      final startAngle = i * sweepingAngle - pi;
      final hex = cards[i]['color'];
      if (hex == '')
        continue;

      final color = MyColor.hexToColor(cards[i]['color']);
      drawBoard(canvas, size, color, startAngle, sweepingAngle);
    }
    
    for (int i = 0; i < cards.length; i++) {
      final startAngle = i * sweepingAngle - pi;
      final text = cards[i]['text'];
      drawText(canvas, size, text, startAngle, sweepingAngle);
      drawLine(canvas, size, startAngle, sweepingAngle);
    }
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
