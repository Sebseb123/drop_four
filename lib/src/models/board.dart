import '../exceptions/game_exceptions.dart';

enum Player {
  red,
  yellow,
  none;

  Player getOpposite() {
    if (this == Player.none) {
      return Player.none;
    }
    return this == Player.red ? Player.yellow : Player.red;
  }
}

class Gameboard {
  late final List<List<Player>> _grid;
  final int rows = 6;
  final int cols = 7;

  Gameboard() {
    _grid = List.generate(
      rows,
      (rowIndex) => List.generate(cols, (colIndex) => Player.none),
    );
  }

  //Named Constructor to create Gameboard from griven grid
  Gameboard.fromGrid(List<List<Player>> grid) {
    if (grid.length != rows || grid.any((row) => row.length != cols)) {
      throw ArgumentError('Grid must have $rows rows and $cols columns.');
    }
    _grid = grid.map(List<Player>.from).toList(growable: false);
  }

  List<List<Player>> get grid => List<List<Player>>.unmodifiable(
    _grid.map((row) => List<Player>.unmodifiable(row)),
  );

  bool get isFull =>
      _grid.every((row) => row.every((tile) => tile != Player.none));

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
