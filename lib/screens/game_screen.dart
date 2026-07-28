import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../constants/typography.dart';
import '../models/game_state.dart';
import '../models/snake.dart';
import '../services/game_engine.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/d_pad_control.dart';
import '../widgets/game_board.dart';
import '../widgets/hud_bar.dart';
import '../widgets/pause_modal.dart';
import '../widgets/scanline_overlay.dart';

/// Main gameplay screen — wraps the game board, HUD, D-pad, and bottom nav.
/// Supports swipe gestures and keyboard arrow keys in addition to D-pad.
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Offset? _swipeStart;

  @override
  Widget build(BuildContext context) {
    return Consumer<GameEngine>(
      builder: (context, engine, _) {
        return KeyboardListener(
          focusNode: FocusNode()..requestFocus(),
          autofocus: true,
          onKeyEvent: (event) => _handleKeyEvent(event, engine),
          child: Scaffold(
            backgroundColor: NeonColors.background,
            body: Stack(
              children: [
                // Full game body
                Column(
                  children: [
                    HudBar(
                      currentScore: engine.score,
                      highScore: engine.highScore,
                      multiplier: engine.multiplier,
                      onPause: engine.togglePause,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onPanStart: (d) => _swipeStart = d.globalPosition,
                        onPanEnd: (d) => _handleSwipe(d, engine),
                        child: Column(
                          children: [
                            // Score HUD card
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                              child: _ScoreRow(engine: engine),
                            ),
                            const SizedBox(height: 12),
                            // Game grid
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: GameBoard(
                                  gridSize: GameEngine.gridSize,
                                  snakeBody: engine.snake.body,
                                  foodPosition: engine.food.position,
                                ),
                              ),
                            ),
                            // D-pad area
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Column(
                                children: [
                                  DPadControl(
                                    onDirection: (dir) =>
                                        engine.changeDirection(dir),
                                  ),
                                  const SizedBox(height: 8),
                                  // Stat pills
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _StatPill(
                                        color: NeonColors.primary,
                                        label:
                                            'LENGTH: ${engine.snakeLength}',
                                      ),
                                      const SizedBox(width: 24),
                                      _StatPill(
                                        color: NeonColors.secondary,
                                        label: 'SPEED: ${_speedLabel(engine.score)}',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const NeonBottomNavBar(activeTab: NavTab.game),
                  ],
                ),
                // Scanline
                const ScanlineOverlay(),
                // Pause modal overlay
                if (engine.phase == GamePhase.paused)
                  PauseModal(
                    onResume: engine.togglePause,
                    onRestart: engine.restart,
                    onExit: engine.goToStart,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleKeyEvent(KeyEvent event, GameEngine engine) {
    if (event is! KeyDownEvent) return;
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowUp:
        engine.changeDirection(Direction.up);
        break;
      case LogicalKeyboardKey.arrowDown:
        engine.changeDirection(Direction.down);
        break;
      case LogicalKeyboardKey.arrowLeft:
        engine.changeDirection(Direction.left);
        break;
      case LogicalKeyboardKey.arrowRight:
        engine.changeDirection(Direction.right);
        break;
      case LogicalKeyboardKey.escape:
      case LogicalKeyboardKey.space:
        engine.togglePause();
        break;
      default:
        break;
    }
  }

  void _handleSwipe(DragEndDetails details, GameEngine engine) {
    if (_swipeStart == null) return;
    final dx = details.velocity.pixelsPerSecond.dx;
    final dy = details.velocity.pixelsPerSecond.dy;
    if (dx.abs() > dy.abs()) {
      engine.changeDirection(
          dx > 0 ? Direction.right : Direction.left);
    } else {
      engine.changeDirection(
          dy > 0 ? Direction.down : Direction.up);
    }
    _swipeStart = null;
  }

  String _speedLabel(int score) {
    final boosts = (score ~/ 50).clamp(0, 12);
    final names = ['1x', '1.2x', '1.5x', '1.8x', '2x', '2.5x', '3x'];
    return boosts < names.length ? names[boosts] : '3x+';
  }
}

class _ScoreRow extends StatelessWidget {
  final GameEngine engine;

  const _ScoreRow({required this.engine});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
              Text('CURRENT_SCORE',
                  style: NeonTextStyles.labelCaps(color: NeonColors.outline)),
              Text('${engine.score}',
                  style: NeonTextStyles.headlineLg(color: NeonColors.primary)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('MULTIPLIER',
                  style: NeonTextStyles.labelCaps(color: NeonColors.outline)),
              Text('x${engine.multiplier.toStringAsFixed(1)}',
                  style: NeonTextStyles.headlineLg(color: NeonColors.tertiary)),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final Color color;
  final String label;

  const _StatPill({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 6),
        Text(label,
            style: NeonTextStyles.labelSmall(color: NeonColors.outline)),
      ],
    );
  }
}
