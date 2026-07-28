import 'package:flutter/material.dart';
import '../constants/colors.dart';

/// Animated scanline effect — a thin horizontal line sweeping top-to-bottom
class ScanlineOverlay extends StatefulWidget {
  const ScanlineOverlay({super.key});

  @override
  State<ScanlineOverlay> createState() => _ScanlineOverlayState();
}

class _ScanlineOverlayState extends State<ScanlineOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Positioned(
          top: MediaQuery.of(context).size.height * _animation.value,
          left: 0,
          right: 0,
          child: Container(
            height: 2,
            color: NeonColors.primary.withValues(alpha: 0.08),
          ),
        );
      },
    );
  }
}
