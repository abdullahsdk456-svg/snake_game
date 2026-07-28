import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_state.dart';
import '../models/snake.dart';

/// Central game engine using ChangeNotifier for reactive UI updates.
/// Manages the game loop, score, snake, food, and state transitions.
class GameEngine extends ChangeNotifier {
  static const int gridSize = 20;
  static const int _baseIntervalMs = 200;
  static const String _highScoreKey = 'neon_synapse_high_score';

  // Entities
  late Snake _snake;
  late Food _food;

  // State
  GamePhase _phase = GamePhase.start;
  int _score = 0;
  int _highScore = 0;
  double _multiplier = 1.0;
  int _sessionSeconds = 0;
  Timer? _gameTimer;
  Timer? _sessionTimer;

  // Pending direction change (buffered to prevent 180-degree turns mid-tick)
  Direction? _pendingDirection;

  GameEngine() {
    _snake = Snake(gridSize: gridSize);
    _food = Food(gridSize: gridSize);
    _food.respawn(_snake.body);
    _loadHighScore();
  }

  // ─── Getters ─────────────────────────────────────────────────────────────

  GamePhase get phase => _phase;
  Snake get snake => _snake;
  Food get food => _food;
  int get score => _score;
  int get highScore => _highScore;
  double get multiplier => _multiplier;
  int get snakeLength => _snake.length;
  int get sessionSeconds => _sessionSeconds;
  bool get isNewHighScore => _score > 0 && _score >= _highScore;

  String get formattedSessionTime {
    final m = _sessionSeconds ~/ 60;
    final s = _sessionSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}.00';
  }

  // ─── Public API ────────────────────────────────────────────────────────

  /// Start a fresh game
  void startGame() {
    _snake.reset();
    _food.respawn(_snake.body);
    _score = 0;
    _multiplier = 1.0;
    _sessionSeconds = 0;
    _pendingDirection = null;
    _phase = GamePhase.playing;
    _startTimers();
    notifyListeners();
  }

  /// Queue a direction change (buffered; 180° turns ignored)
  void changeDirection(Direction newDir) {
    if (_phase != GamePhase.playing) return;
    if (newDir.isOpposite(_snake.direction)) return;
    _pendingDirection = newDir;
  }

  /// Toggle pause / resume
  void togglePause() {
    if (_phase == GamePhase.playing) {
      _phase = GamePhase.paused;
      _stopTimers();
    } else if (_phase == GamePhase.paused) {
      _phase = GamePhase.playing;
      _startTimers();
    }
    notifyListeners();
  }

  /// Restart from game over or pause
  void restart() {
    _stopTimers();
    startGame();
  }

  /// Go back to the start screen
  void goToStart() {
    _stopTimers();
    _phase = GamePhase.start;
    notifyListeners();
  }

  // ─── Private ─────────────────────────────────────────────────────────────

  void _startTimers() {
    _stopTimers();
    _scheduleGameTick();
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _sessionSeconds++;
      notifyListeners();
    });
  }

  void _stopTimers() {
    _gameTimer?.cancel();
    _sessionTimer?.cancel();
    _gameTimer = null;
    _sessionTimer = null;
  }

  void _scheduleGameTick() {
    final interval = _currentInterval();
    _gameTimer = Timer(Duration(milliseconds: interval), _tick);
  }

  int _currentInterval() {
    // Speed increases every 5 food eaten (every 50 score), capped at 80ms
    final speedBoosts = (_score ~/ 50).clamp(0, 12);
    final interval = (_baseIntervalMs - speedBoosts * 10).clamp(80, _baseIntervalMs);
    return interval;
  }

  void _tick() {
    if (_phase != GamePhase.playing) return;

    // Apply buffered direction
    if (_pendingDirection != null) {
      _snake.direction = _pendingDirection!;
      _pendingDirection = null;
    }

    _snake.move();

    // Collision detection
    if (_snake.isOutOfBounds() || _snake.hasSelfCollision()) {
      _endGame();
      return;
    }

    // Food consumption
    if (_snake.head == _food.position) {
      _snake.grow();
      _updateScore();
      _food.respawn(_snake.body);
    }

    notifyListeners();
    _scheduleGameTick(); // re-schedule with potentially new interval
  }

  void _updateScore() {
    // Multiplier increases every 5 food eaten
    final foodEaten = _snake.length - 3; // initial length was 3
    _multiplier = 1.0 + (foodEaten ~/ 5) * 0.5;
    _multiplier = _multiplier.clamp(1.0, 5.0);
    _score += (10 * _multiplier).round();
    if (_score > _highScore) {
      _highScore = _score;
      _saveHighScore();
    }
  }

  void _endGame() {
    _stopTimers();
    _phase = GamePhase.gameOver;
    notifyListeners();
  }

  Future<void> _loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    _highScore = prefs.getInt(_highScoreKey) ?? 0;
    notifyListeners();
  }

  Future<void> _saveHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_highScoreKey, _highScore);
  }

  @override
  void dispose() {
    _stopTimers();
    super.dispose();
  }
}
