// Source - https://stackoverflow.com/a/78708567
// Posted by Mahmoud AL-Bndkji
// Retrieved 2026-06-05, License - CC BY-SA 4.0

import 'package:flutter/material.dart';
import 'package:roam_and_rate/core/themes/custom_colours.dart';

class DashedBorderContainer extends StatelessWidget {
  final Widget child;
  final Color borderColour;
  const DashedBorderContainer({super.key, required this.child, required this.borderColour});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashedBorderPainter(borderColour: borderColour),
      child: child,
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color borderColour;
  DashedBorderPainter({required this.borderColour});
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = borderColour
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    const double dashWidth = 5.0;
    const double dashSpace = 5.0;
    double startX = 3;

    // Top side
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    // Right side
    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width, startY),
        Offset(size.width, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }

    // Bottom side
    startX = 3;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height),
        Offset(startX + dashWidth, size.height),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    // Left side
    startY = 3;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
