import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/typography.dart';

/// Pause modal overlay shown over the gameplay screen
class PauseModal extends StatelessWidget {
  final VoidCallback onResume;
  final VoidCallback onRestart;
  final VoidCallback onExit;

  const PauseModal({
    super.key,
    required this.onResume,
    required this.onRestart,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.7),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          decoration: BoxDecoration(
            color: NeonColors.surface.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: NeonColors.glassBorder),
            boxShadow: [
              BoxShadow(
                color: NeonColors.primaryGlow.withValues(alpha: 0.15),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'SESSION_PAUSED',
                style: NeonTextStyles.labelCaps(color: NeonColors.tertiary),
              ),
              const SizedBox(height: 8),
              Text(
                'SYSTEM HOLD',
                style: NeonTextStyles.headlineLgMobile(color: NeonColors.onSurface),
              ),
              const SizedBox(height: 32),
              _PauseButton(
                label: 'RESUME',
                icon: Icons.play_arrow,
                color: NeonColors.primary,
                onTap: onResume,
              ),
              const SizedBox(height: 12),
              _PauseButton(
                label: 'RESTART',
                icon: Icons.restart_alt,
                color: NeonColors.cyanButton,
                onTap: onRestart,
              ),
              const SizedBox(height: 12),
              _PauseButton(
                label: 'EXIT',
                icon: Icons.logout,
                color: NeonColors.outline,
                onTap: onExit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PauseButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _PauseButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: color.withValues(alpha: 0.4)),
          borderRadius: BorderRadius.circular(8),
          color: color.withValues(alpha: 0.08),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 10),
            Text(label, style: NeonTextStyles.buttonText(color: color)),
          ],
        ),
      ),
    );
  }
}
