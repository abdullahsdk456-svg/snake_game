import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/snake.dart';

/// The main 20×20 game grid rendered via CustomPainter.
/// Draws: grid background, snake segments with glow, food with pulsing glow, corner accents.
class GameBoard extends StatefulWidget {
  final int gridSize;
  final List<Point> snakeBody;
  final Point foodPosition;

  const GameBoard({
    super.key,
    required this.gridSize,
    required this.snakeBody,
    required this.foodPosition,
  });

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard>
    with SingleTickerProviderStateMixin {
  late AnimationController _foodPulseController;
  late Animation<double> _foodPulse;

  @override
  void initState() {
    super.initState();
    _foodPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _foodPulse = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _foodPulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _foodPulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final boardSize = constraints.maxWidth;
          return AnimatedBuilder(
            animation: _foodPulse,
            builder: (context, _) {
              return CustomPaint(
                size: Size(boardSize, boardSize),
                painter: _GameBoardPainter(
                  gridSize: widget.gridSize,
                  snakeBody: widget.snakeBody,
                  foodPosition: widget.foodPosition,
                  foodPulse: _foodPulse.value,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _GameBoardPainter extends CustomPainter {
  final int gridSize;
  final List<Point> snakeBody;
  final Point foodPosition;
  final double foodPulse;

  _GameBoardPainter({
    required this.gridSize,
    required this.snakeBody,
    required this.foodPosition,
    required this.foodPulse,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cellSize = size.width / gridSize;

    _drawBackground(canvas, size, cellSize);
    _drawGrid(canvas, size, cellSize);
    _drawCornerAccents(canvas, size);
    _drawFood(canvas, cellSize);
    _drawSnake(canvas, cellSize);
  }

  void _drawBackground(Canvas canvas, Size size, double cellSize) {
    final paint = Paint()
      ..color = NeonColors.surfaceContainerLowest.withValues(alpha: 0.8);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(12),
      ),
      paint,
    );
  }

  void _drawGrid(Canvas canvas, Size size, double cellSize) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..strokeWidth = 1;

    // Vertical lines
    for (int i = 0; i <= gridSize; i++) {
      final x = i * cellSize;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    // Horizontal lines
    for (int i = 0; i <= gridSize; i++) {
      final y = i * cellSize;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  void _drawCornerAccents(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = NeonColors.primary.withValues(alpha: 0.35)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    const accentSize = 20.0;

    // Top-left
    canvas.drawLine(Offset(0, accentSize), const Offset(0, 0), paint);
    canvas.drawLine(const Offset(0, 0), Offset(accentSize, 0), paint);

    // Top-right
    canvas.drawLine(Offset(size.width - accentSize, 0), Offset(size.width, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, accentSize), paint);

    // Bottom-left
    canvas.drawLine(Offset(0, size.height - accentSize), Offset(0, size.height), paint);
    canvas.drawLine(Offset(0, size.height), Offset(accentSize, size.height), paint);

    // Bottom-right
    canvas.drawLine(Offset(size.width - accentSize, size.height), Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height - accentSize), Offset(size.width, size.height), paint);
  }

  void _drawFood(Canvas canvas, double cellSize) {
    final center = Offset(
      foodPosition.x * cellSize + cellSize / 2,
      foodPosition.y * cellSize + cellSize / 2,
    );
    final radius = (cellSize / 2 - 2) * foodPulse;

    // Glow
    final glowPaint = Paint()
      ..color = NeonColors.secondaryPink.withValues(alpha: 0.25 * foodPulse)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawCircle(center, radius + 6, glowPaint);

    // Inner food
    final foodPaint = Paint()..color = NeonColors.secondaryPink;
    canvas.drawCircle(center, radius, foodPaint);
  }

  void _drawSnake(Canvas canvas, double cellSize) {
    final totalSegments = snakeBody.length;
    const segmentGap = 1.5;
    const segmentRadius = Radius.circular(3);

    for (int i = 0; i < totalSegments; i++) {
      final seg = snakeBody[i];
      final isHead = i == 0;

      // Opacity fades toward tail
      final opacityFactor = 1.0 - (i / totalSegments) * 0.65;
      final color = NeonColors.primary.withValues(alpha: opacityFactor);

      final rect = Rect.fromLTWH(
        seg.x * cellSize + segmentGap,
        seg.y * cellSize + segmentGap,
        cellSize - segmentGap * 2,
        cellSize - segmentGap * 2,
      );

      if (isHead) {
        // Head glow
        final glowPaint = Paint()
          ..color = NeonColors.primaryGlow.withValues(alpha: 0.5)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect.inflate(4), segmentRadius),
          glowPaint,
        );
      }

      final segPaint = Paint()..color = color;
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, segmentRadius),
        segPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GameBoardPainter old) {
    return old.snakeBody != snakeBody ||
        old.foodPosition != foodPosition ||
        old.foodPulse != foodPulse;
  }
}
