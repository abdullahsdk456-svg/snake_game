import 'package:flutter/material.dart';

/// Decorative corner bracket accent used in cards and game board
class CornerAccents extends StatelessWidget {
  final double size;
  final Color color;
  final double strokeWidth;

  const CornerAccents({
    super.key,
    this.size = 24,
    this.color = const Color(0xFF4EDEA3),
    this.strokeWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    final paint = color.withValues(alpha: 0.4);
    return Stack(
      children: [
        // Top-left
        Positioned(
          top: 0,
          left: 0,
          child: _Corner(
            size: size,
            color: paint,
            strokeWidth: strokeWidth,
            top: true,
            left: true,
          ),
        ),
        // Top-right
        Positioned(
          top: 0,
          right: 0,
          child: _Corner(
            size: size,
            color: paint,
            strokeWidth: strokeWidth,
            top: true,
            left: false,
          ),
        ),
        // Bottom-left
        Positioned(
          bottom: 0,
          left: 0,
          child: _Corner(
            size: size,
            color: paint,
            strokeWidth: strokeWidth,
            top: false,
            left: true,
          ),
        ),
        // Bottom-right
        Positioned(
          bottom: 0,
          right: 0,
          child: _Corner(
            size: size,
            color: paint,
            strokeWidth: strokeWidth,
            top: false,
            left: false,
          ),
        ),
      ],
    );
  }
}

class _Corner extends StatelessWidget {
  final double size;
  final Color color;
  final double strokeWidth;
  final bool top;
  final bool left;

  const _Corner({
    required this.size,
    required this.color,
    required this.strokeWidth,
    required this.top,
    required this.left,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CornerPainter(
          color: color,
          strokeWidth: strokeWidth,
          top: top,
          left: left,
        ),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final bool top;
  final bool left;

  _CornerPainter({
    required this.color,
    required this.strokeWidth,
    required this.top,
    required this.left,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    final w = size.width;
    final h = size.height;

    if (top && left) {
      canvas.drawLine(Offset(0, h), Offset(0, 0), paint);
      canvas.drawLine(Offset(0, 0), Offset(w, 0), paint);
    } else if (top && !left) {
      canvas.drawLine(Offset(0, 0), Offset(w, 0), paint);
      canvas.drawLine(Offset(w, 0), Offset(w, h), paint);
    } else if (!top && left) {
      canvas.drawLine(Offset(0, 0), Offset(0, h), paint);
      canvas.drawLine(Offset(0, h), Offset(w, h), paint);
    } else {
      canvas.drawLine(Offset(w, 0), Offset(w, h), paint);
      canvas.drawLine(Offset(0, h), Offset(w, h), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CornerPainter old) =>
      old.color != color || old.strokeWidth != strokeWidth;
}
