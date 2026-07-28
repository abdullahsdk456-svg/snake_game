import 'dart:math';

/// Direction the snake is moving
enum Direction { up, down, left, right }

extension DirectionExtension on Direction {
  /// Returns true if this direction is opposite to [other]
  bool isOpposite(Direction other) {
    if (this == Direction.up && other == Direction.down) return true;
    if (this == Direction.down && other == Direction.up) return true;
    if (this == Direction.left && other == Direction.right) return true;
    if (this == Direction.right && other == Direction.left) return true;
    return false;
  }
}

/// A single cell on the game grid
class Point {
  final int x;
  final int y;

  const Point(this.x, this.y);

  Point operator +(Point other) => Point(x + other.x, y + other.y);

  @override
  bool operator ==(Object other) =>
      other is Point && x == other.x && y == other.y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => 'Point($x, $y)';
}

/// The snake entity
class Snake {
  final int gridSize;
  late List<Point> body;
  Direction direction;
  bool _shouldGrow = false;

  Snake({required this.gridSize})
      : direction = Direction.right,
        body = [
          Point(gridSize ~/ 2, gridSize ~/ 2),
          Point(gridSize ~/ 2 - 1, gridSize ~/ 2),
          Point(gridSize ~/ 2 - 2, gridSize ~/ 2),
        ];

  Point get head => body.first;
  int get length => body.length;

  /// Advance the snake by one cell
  void move() {
    final delta = _directionDelta(direction);
    final newHead = head + delta;
    body.insert(0, newHead);
    if (_shouldGrow) {
      _shouldGrow = false;
    } else {
      body.removeLast();
    }
  }

  /// Queue a growth step (called after eating food)
  void grow() {
    _shouldGrow = true;
  }

  /// True if the head is out of bounds
  bool isOutOfBounds() {
    return head.x < 0 ||
        head.x >= gridSize ||
        head.y < 0 ||
        head.y >= gridSize;
  }

  /// True if the head collides with any body segment
  bool hasSelfCollision() {
    return body.skip(1).contains(head);
  }

  static Point _directionDelta(Direction dir) {
    switch (dir) {
      case Direction.up:
        return const Point(0, -1);
      case Direction.down:
        return const Point(0, 1);
      case Direction.left:
        return const Point(-1, 0);
      case Direction.right:
        return const Point(1, 0);
    }
  }

  /// Reset to initial state
  void reset() {
    direction = Direction.right;
    _shouldGrow = false;
    body = [
      Point(gridSize ~/ 2, gridSize ~/ 2),
      Point(gridSize ~/ 2 - 1, gridSize ~/ 2),
      Point(gridSize ~/ 2 - 2, gridSize ~/ 2),
    ];
  }
}

/// A food item on the grid
class Food {
  late Point position;
  final int gridSize;

  Food({required this.gridSize}) {
    position = _randomPosition([]);
  }

  /// Spawn food at a random position not occupied by [occupied]
  Point _randomPosition(List<Point> occupied) {
    final random = Random();
    Point candidate;
    do {
      candidate = Point(
        random.nextInt(gridSize),
        random.nextInt(gridSize),
      );
    } while (occupied.contains(candidate));
    return candidate;
  }

  /// Relocate food away from [occupied] cells
  void respawn(List<Point> occupied) {
    position = _randomPosition(occupied);
  }
}
