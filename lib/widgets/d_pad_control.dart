import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/snake.dart';

/// Circular D-Pad controller matching the cyberpunk design.
/// Features a glassmorphic circular background, directional arrow buttons,
/// a glowing center core, and haptic-like press feedback.
class DPadControl extends StatelessWidget {
  final ValueChanged<Direction> onDirection;

  const DPadControl({super.key, required this.onDirection});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 192,
      height: 192,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer ring — glassmorphic
          Container(
            width: 192,
            height: 192,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF1E293B).withValues(alpha: 0.5),
              border: Border.all(color: NeonColors.glassBorder, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ],
            ),
          ),
          // Inner ring decoration
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.04),
                width: 1,
              ),
            ),
          ),
          // Center core
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: NeonColors.surfaceContainerHighest,
              border: Border.all(color: NeonColors.glassBorder),
            ),
            child: Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: NeonColors.primary,
                  boxShadow: [
                    BoxShadow(
                      color: NeonColors.primaryGlow.withValues(alpha: 0.8),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // UP button
          Positioned(
            top: 8,
            child: _DPadButton(
              direction: Direction.up,
              icon: Icons.keyboard_arrow_up_rounded,
              onTap: () => onDirection(Direction.up),
            ),
          ),
          // DOWN button
          Positioned(
            bottom: 8,
            child: _DPadButton(
              direction: Direction.down,
              icon: Icons.keyboard_arrow_down_rounded,
              onTap: () => onDirection(Direction.down),
            ),
          ),
          // LEFT button
          Positioned(
            left: 8,
            child: _DPadButton(
              direction: Direction.left,
              icon: Icons.keyboard_arrow_left_rounded,
              onTap: () => onDirection(Direction.left),
            ),
          ),
          // RIGHT button
          Positioned(
            right: 8,
            child: _DPadButton(
              direction: Direction.right,
              icon: Icons.keyboard_arrow_right_rounded,
              onTap: () => onDirection(Direction.right),
            ),
          ),
        ],
      ),
    );
  }
}

class _DPadButton extends StatefulWidget {
  final Direction direction;
  final IconData icon;
  final VoidCallback onTap;

  const _DPadButton({
    required this.direction,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_DPadButton> createState() => _DPadButtonState();
}

class _DPadButtonState extends State<_DPadButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _pressed = true);
        widget.onTap();
      },
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.88 : 1.0,
        duration: const Duration(milliseconds: 80),
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: _pressed
                ? NeonColors.cyanButton.withValues(alpha: 0.15)
                : Colors.transparent,
          ),
          child: Icon(
            widget.icon,
            color: NeonColors.cyanButton,
            size: 32,
          ),
        ),
      ),
    );
  }
}
