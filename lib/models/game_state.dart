/// Overall state of the game session
enum GamePhase {
  /// App just launched, showing start screen
  start,

  /// Game is actively running
  playing,

  /// Game is paused (pause modal visible)
  paused,

  /// Snake died — game over screen shown
  gameOver,
}
