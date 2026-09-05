import '../exceptions/game_exceptions.dart';

/// Represents a player or an empty board position.
enum Player {
  red,
  yellow,
  none;

  /// Returns the other player, or [Player.none] for an empty position.
  Player getOpposite() {
    if (this == Player.none) {
      return Player.none;
    }
    return this == Player.red ? Player.yellow : Player.red;
  }
}

/// Stores the 6-by-7 playing field and applies Connect Four placement rules.
class Gameboard {
  late final List<List<Player>> _grid;
  final int rows = 6;
  final int cols = 7;

  /// Creates an empty game board.
  Gameboard() {
    _grid = List.generate(
      rows,
      (rowIndex) => List.generate(cols, (colIndex) => Player.none),
    );
  }

  /// Creates a board from an existing 6-by-7 grid.
  ///
  /// The supplied grid is copied so later changes to it do not modify this
  /// board. Throws [ArgumentError] when the dimensions are invalid.
  Gameboard.fromGrid(List<List<Player>> grid) {
    if (grid.length != rows || grid.any((row) => row.length != cols)) {
      throw ArgumentError('Grid must have $rows rows and $cols columns.');
    }
    _grid = grid.map(List<Player>.from).toList(growable: false);
  }

  /// Returns an unmodifiable view of the current board.
  List<List<Player>> get grid => List<List<Player>>.unmodifiable(
    _grid.map((row) => List<Player>.unmodifiable(row)),
  );

  /// Whether every position on the board contains a coin.
  bool get isFull =>
      _grid.every((row) => row.every((tile) => tile != Player.none));

  /// Drops a coin into the selected column.
  ///
  /// Columns are numbered from 1 to [cols]. Throws [InvalidColumnException]
  /// for an invalid column, [ColumnFullException] for a full column, and
  /// [ArgumentError] when [player] is empty.
  void dropCoin(int colIndex, Player player) {
    if (colIndex < 1 || colIndex > cols) {
      throw InvalidColumnException(colIndex);
    }
    if (player == Player.none) {
      throw ArgumentError.value(
        player,
        'player',
        'A coin must belong to a player.',
      );
    }

    bool coinPlaced = false;

    for (int rowIndex = rows - 1; rowIndex >= 0; rowIndex--) {
      if (_grid[rowIndex][colIndex - 1] == Player.none) {
        _grid[rowIndex][colIndex - 1] = player;
        coinPlaced = true;
        break;
      }
    }
    if (!coinPlaced) {
      throw ColumnFullException(colIndex);
    }
  }

  @override
  String toString() {
    final buffer = StringBuffer();

    for (var row in _grid) {
      for (var tile in row) {
        switch (tile) {
          case Player.red:
            buffer.write('[R]');
          case Player.yellow:
            buffer.write('[Y]');
          case Player.none:
            buffer.write('[ ]');
        }
      }
      buffer.writeln();
    }
    return buffer.toString().trimRight();
  }
}
