import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/typography.dart';

/// Top HUD bar showing title, scores, and pause button
class HudBar extends StatelessWidget implements PreferredSizeWidget {
  final int currentScore;
  final int highScore;
  final double multiplier;
  final VoidCallback? onPause;

  const HudBar({
    super.key,
    required this.currentScore,
    required this.highScore,
    required this.multiplier,
    this.onPause,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64 + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: BoxDecoration(
        color: NeonColors.surface.withValues(alpha: 0.5),
        border: Border(
          bottom: BorderSide(color: NeonColors.glassBorder, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: NeonColors.primaryGlow.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left: System status + title
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SYSTEM_STATUS',
                  style: NeonTextStyles.labelSmall(
                    color: NeonColors.primary.withValues(alpha: 0.7),
                  ),
                ),
                Text(
                  'NEON_SYNAPSE_v1.0',
                  style: NeonTextStyles.headlineLgMobile(
                    color: NeonColors.primary,
                  ),
                ),
              ],
            ),
            // Right: High score + pause
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'HIGH_SCORE',
                      style: NeonTextStyles.labelSmall(
                        color: NeonColors.outline,
                      ),
                    ),
                    Text(
                      '$highScore',
                      style: NeonTextStyles.buttonText(
                        color: NeonColors.secondaryPink,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                // Pause button
                GestureDetector(
                  onTap: onPause,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: NeonColors.glassBorder),
                    ),
                    child: const Icon(
                      Icons.pause,
                      color: NeonColors.primary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact score + multiplier HUD card below the app bar
class ScoreHudCard extends StatelessWidget {
  final int score;
  final double multiplier;

  const ScoreHudCard({
    super.key,
    required this.score,
    required this.multiplier,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: NeonColors.primary.withValues(alpha: 0.4),
            width: 2,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CURRENT_SCORE',
                style: NeonTextStyles.labelCaps(color: NeonColors.outline),
              ),
              Text(
                '$score',
                style: NeonTextStyles.headlineLg(color: NeonColors.primary),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'MULTIPLIER',
                style: NeonTextStyles.labelCaps(color: NeonColors.outline),
              ),
              Text(
                'x${multiplier.toStringAsFixed(1)}',
                style: NeonTextStyles.headlineLg(color: NeonColors.tertiary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
