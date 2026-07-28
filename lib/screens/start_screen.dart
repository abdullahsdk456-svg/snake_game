import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/typography.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/neon_button.dart';
import '../widgets/scanline_overlay.dart';

/// Start / Main Menu screen
class StartScreen extends StatefulWidget {
  final VoidCallback onPlay;

  const StartScreen({super.key, required this.onPlay});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _glowAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeonColors.background,
      body: Stack(
        children: [
          // Grid background
          Positioned.fill(child: _GridBackground()),
          // Scanline effect
          const ScanlineOverlay(),
          // Content
          SafeArea(
            child: Column(
              children: [
                // Top bar
                _TopBar(),
                const Spacer(),
                // Center content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo / title area
                      AnimatedBuilder(
                        animation: _glowAnim,
                        builder: (context, _) {
                          return Text(
                            'NEON_SYNAPSE',
                            style: NeonTextStyles.headlineLg(
                              color: NeonColors.primary,
                            ).copyWith(
                              shadows: [
                                Shadow(
                                  color: NeonColors.primaryGlow
                                      .withValues(alpha: _glowAnim.value),
                                  blurRadius: 20,
                                ),
                                Shadow(
                                  color: NeonColors.primaryGlow
                                      .withValues(alpha: _glowAnim.value * 0.5),
                                  blurRadius: 40,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'v1.0',
                        style: NeonTextStyles.labelCaps(
                          color: NeonColors.outline,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Subtitle
                      Text(
                        'AUTONOMOUS NEURAL PATHFINDING PROTOCOL',
                        textAlign: TextAlign.center,
                        style: NeonTextStyles.labelSmall(
                          color: NeonColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 48),
                      // Snake preview decoration
                      _SnakePreview(),
                      const SizedBox(height: 48),
                      // Play button
                      NeonButton(
                        label: 'INITIALIZE PROGRAM',
                        icon: Icons.play_arrow,
                        onPressed: widget.onPlay,
                        width: double.infinity,
                      ),
                      const SizedBox(height: 16),
                      // Secondary info
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _StatChip(label: 'GRID', value: '20×20'),
                          const SizedBox(width: 24),
                          _StatChip(label: 'PROTOCOL', value: 'SNAKE'),
                          const SizedBox(width: 24),
                          _StatChip(label: 'MODE', value: 'SOLO'),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Bottom nav
                const NeonBottomNavBar(activeTab: NavTab.game),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: NeonColors.surface.withValues(alpha: 0.5),
        border: Border(
          bottom: BorderSide(color: NeonColors.glassBorder),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.grid_view_rounded,
                  color: NeonColors.primary, size: 22),
              const SizedBox(width: 12),
              Text(
                'NEON_SYNAPSE_v1.0',
                style: NeonTextStyles.headlineLgMobile(
                  color: NeonColors.primary,
                ),
              ),
            ],
          ),
          Icon(Icons.pause, color: NeonColors.primary, size: 22),
        ],
      ),
    );
  }
}

class _GridBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GridPainter(),
      size: Size.infinite,
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..strokeWidth = 1;

    const cellSize = 32.0;
    for (double x = 0; x < size.width; x += cellSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += cellSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SnakePreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Food
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: NeonColors.secondaryPink,
            boxShadow: [
              BoxShadow(
                color: NeonColors.secondaryPink.withValues(alpha: 0.6),
                blurRadius: 12,
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        // Snake segments
        ...List.generate(6, (i) {
          final opacity = 1.0 - i * 0.15;
          return Padding(
            padding: const EdgeInsets.only(left: 3),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: NeonColors.primary.withValues(alpha: opacity),
                boxShadow: i == 0
                    ? [
                        BoxShadow(
                          color: NeonColors.primaryGlow.withValues(alpha: 0.6),
                          blurRadius: 12,
                        ),
                      ]
                    : [],
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;

  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: NeonTextStyles.labelSmall(color: NeonColors.outline)),
        const SizedBox(height: 2),
        Text(value,
            style: NeonTextStyles.labelCaps(color: NeonColors.tertiary)),
      ],
    );
  }
}
