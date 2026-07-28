import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/typography.dart';

/// Reusable neon cyan primary button with fill-animation on press
class NeonButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final double? width;

  const NeonButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.width,
  });

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fillAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _fillAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails _) {
    _controller.reverse();
    widget.onPressed?.call();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _fillAnimation,
        builder: (context, child) {
          final filled = _fillAnimation.value;
          return Container(
            width: widget.width,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: NeonColors.cyanButton,
                width: 2,
              ),
              color: NeonColors.cyanButton.withValues(alpha: filled * 0.9),
              boxShadow: [
                BoxShadow(
                  color: NeonColors.cyanButton.withValues(alpha: 0.3 + filled * 0.1),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: NeonColors.cyanButton.withValues(alpha: 0.1),
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset.zero,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  Icon(
                    widget.icon,
                    color: filled > 0.5
                        ? NeonColors.background
                        : NeonColors.cyanButton,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                ],
                Text(
                  widget.label,
                  style: NeonTextStyles.buttonText(
                    color: filled > 0.5
                        ? NeonColors.background
                        : NeonColors.cyanButton,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
