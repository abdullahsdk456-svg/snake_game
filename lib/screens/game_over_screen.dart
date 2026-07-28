import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../constants/typography.dart';
import '../services/game_engine.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/corner_accent.dart';
import '../widgets/neon_button.dart';
import '../widgets/scanline_overlay.dart';

/// Game Over screen — pixel-perfect recreation of the NEON_SYNAPSE v1.0 game over design.
/// Shows: CRITICAL ERROR header, SYSTEM HALTED title, final score, NEW HIGH SCORE badge,
/// session stats, REBOOT SESSION button, and secondary actions.
class GameOverScreen extends StatefulWidget {
  final VoidCallback onRestart;
  final VoidCallback onExit;

  const GameOverScreen({
    super.key,
    required this.onRestart,
    required this.onExit,
  });

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryController;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
    _fadeAnim = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOut,
    );
    _scaleAnim = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameEngine>(
      builder: (context, engine, _) {
        return Scaffold(
          backgroundColor: NeonColors.background,
          body: Stack(
            children: [
              // Blurred/darkened background
              Positioned.fill(
                child: _BackgroundLayer(),
              ),
              const ScanlineOverlay(),
              // Top bar
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _GameOverTopBar(),
              ),
              // Main centered card
              SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 64),
                    Expanded(
                      child: Center(
                        child: FadeTransition(
                          opacity: _fadeAnim,
                          child: ScaleTransition(
                            scale: _scaleAnim,
                            child: _GameOverCard(
                              engine: engine,
                              onRestart: widget.onRestart,
                              onExit: widget.onExit,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const NeonBottomNavBar(activeTab: NavTab.game),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BackgroundLayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        NeonColors.background.withValues(alpha: 0.85),
        BlendMode.srcOver,
      ),
      child: CustomPaint(
        painter: _GridBgPainter(),
        size: Size.infinite,
      ),
    );
  }
}

class _GridBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = NeonColors.background;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bg);

    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..strokeWidth = 1;
    const step = 32.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GameOverTopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64 + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: BoxDecoration(
        color: NeonColors.surface.withValues(alpha: 0.5),
        border: Border(
          bottom: BorderSide(color: NeonColors.glassBorder),
        ),
        boxShadow: [
          BoxShadow(
            color: NeonColors.primaryGlow.withValues(alpha: 0.15),
            blurRadius: 20,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.grid_view_rounded,
                    color: NeonColors.primary, size: 22),
                const SizedBox(width: 12),
                Text(
                  'NEON_SYNAPSE_v1.0',
                  style: NeonTextStyles.headlineLgMobile(
                      color: NeonColors.primary),
                ),
              ],
            ),
            const Icon(Icons.pause, color: NeonColors.primary, size: 22),
          ],
        ),
      ),
    );
  }
}

class _GameOverCard extends StatelessWidget {
  final GameEngine engine;
  final VoidCallback onRestart;
  final VoidCallback onExit;

  const _GameOverCard({
    required this.engine,
    required this.onRestart,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: NeonColors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: NeonColors.glassBorder),
        boxShadow: [
          BoxShadow(
            color: NeonColors.primaryGlow.withValues(alpha: 0.1),
            blurRadius: 40,
            spreadRadius: 5,
          ),
        ],
      ),
      padding: const EdgeInsets.all(32),
      child: Stack(
        children: [
          // Corner accents
          Positioned.fill(child: CornerAccents()),
          // Card content
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Text(
                'CRITICAL ERROR',
                style: NeonTextStyles.labelCaps(
                  color: NeonColors.secondaryPink,
                ).copyWith(letterSpacing: 4),
              ),
              const SizedBox(height: 8),
              Text(
                'SYSTEM HALTED',
                style: NeonTextStyles.headlineLgMobile(
                  color: NeonColors.secondaryPink,
                ).copyWith(
                  fontWeight: FontWeight.w700,
                  shadows: [
                    Shadow(
                      color: NeonColors.secondaryPink.withValues(alpha: 0.7),
                      blurRadius: 20,
                    ),
                    Shadow(
                      color: NeonColors.secondaryPink.withValues(alpha: 0.4),
                      blurRadius: 40,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              // Final score
              Text(
                'FINAL SCORE',
                style: NeonTextStyles.labelCaps(color: NeonColors.outline),
              ),
              const SizedBox(height: 4),
              Text(
                '${engine.score}',
                style: NeonTextStyles.displayScore(color: NeonColors.onSurface),
              ),
              const SizedBox(height: 16),
              // High score badge (conditional)
              if (engine.isNewHighScore) ...[
                _HighScoreBadge(),
                const SizedBox(height: 20),
              ],
              // Stats row
              Container(
                padding: const EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: NeonColors.glassBorder),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _StatBlock(
                        label: 'SESSION_TIME',
                        value: engine.formattedSessionTime,
                      ),
                    ),
                    Expanded(
                      child: _StatBlock(
                        label: 'DATA_NODES',
                        value: '${engine.snakeLength} UNITS',
                        align: CrossAxisAlignment.end,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              // REBOOT SESSION button
              NeonButton(
                label: 'REBOOT SESSION',
                icon: Icons.restart_alt,
                onPressed: onRestart,
                width: double.infinity,
              ),
              const SizedBox(height: 20),
              // Secondary actions
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SecondaryButton(
                    icon: Icons.leaderboard_outlined,
                    label: 'RANKINGS',
                    onTap: () {},
                  ),
                  const SizedBox(width: 32),
                  _SecondaryButton(
                    icon: Icons.share_outlined,
                    label: 'EXPORT LOG',
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HighScoreBadge extends StatefulWidget {
  @override
  State<_HighScoreBadge> createState() => _HighScoreBadgeState();
}

class _HighScoreBadgeState extends State<_HighScoreBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 1.0).animate(_pulse);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
                color: NeonColors.primary.withValues(alpha: _anim.value)),
            color: NeonColors.primary.withValues(alpha: 0.1 * _anim.value),
            boxShadow: [
              BoxShadow(
                color: NeonColors.primaryGlow
                    .withValues(alpha: 0.3 * _anim.value),
                blurRadius: 12,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.workspace_premium,
                  color: NeonColors.primary, size: 16),
              const SizedBox(width: 8),
              Text(
                'NEW HIGH SCORE!',
                style:
                    NeonTextStyles.labelCaps(color: NeonColors.primary),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatBlock extends StatelessWidget {
  final String label;
  final String value;
  final CrossAxisAlignment align;

  const _StatBlock({
    required this.label,
    required this.value,
    this.align = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(label,
            style: NeonTextStyles.labelSmall(color: NeonColors.outline)),
        const SizedBox(height: 2),
        Text(value,
            style: NeonTextStyles.labelCaps(color: NeonColors.onSurface)),
      ],
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SecondaryButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: NeonColors.outline, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: NeonTextStyles.labelCaps(color: NeonColors.outline),
          ),
        ],
      ),
    );
  }
}
