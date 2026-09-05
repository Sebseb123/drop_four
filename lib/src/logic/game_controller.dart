import 'package:vier_gewinnt/src/models/board.dart';

/// Coordinates turns, moves, wins, and draws for a Connect Four game.
class GameController {
  /// Creates a controller using [board], or a new empty board by default.
  GameController({Gameboard? board}) : board = board ?? Gameboard();

  /// The board used by this game.
  final Gameboard board;
  Player _currentPlayer = Player.red;
  Player _winner = Player.none;
  bool _isDraw = false;

  /// The player whose turn it currently is.
  Player get currentPlayer => _currentPlayer;

  /// The winning player, or [Player.none] while there is no winner.
  Player get winner => _winner;

  /// Whether the game ended without a winner because the board is full.
  bool get isDraw => _isDraw;

  /// Whether no further moves can be made.
  bool get isGameOver => winner != Player.none || isDraw;

  /// Places a coin for the current player and advances the game state.
  ///
  /// Moves are ignored after the game has ended. Board validation errors are
  /// passed through from [Gameboard.dropCoin].
  void dropCoin(int column) {
    if (isGameOver) return;

    board.dropCoin(column, currentPlayer);

    if (checkWinCondition(currentPlayer)) {
      _winner = currentPlayer;
      return;
    }
    if (board.isFull) {
      _isDraw = true;
      return;
    }

    _currentPlayer = currentPlayer.getOpposite();
  }

  /// Whether [player] has four consecutive pieces in any direction.
  bool checkWinCondition(Player player) {
    if (player == Player.none) return false;

    const int rows = 6;
    const int cols = 7;
    final grid = board.grid;

    // 1. Check Horizontal (-)
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c <= cols - 4; c++) {
        if (grid[r][c] == player &&
            grid[r][c + 1] == player &&
            grid[r][c + 2] == player &&
            grid[r][c + 3] == player) {
          return true;
        }
      }
    }

    // 2. Check Vertical (|)
    for (int r = 0; r <= rows - 4; r++) {
      for (int c = 0; c < cols; c++) {
        if (grid[r][c] == player &&
            grid[r + 1][c] == player &&
            grid[r + 2][c] == player &&
            grid[r + 3][c] == player) {
          return true;
        }
      }
    }

    // 3. Check Diagonal (Down-Right: \)
    for (int r = 0; r <= rows - 4; r++) {
      for (int c = 0; c <= cols - 4; c++) {
        if (grid[r][c] == player &&
            grid[r + 1][c + 1] == player &&
            grid[r + 2][c + 2] == player &&
            grid[r + 3][c + 3] == player) {
          return true;
        }
      }
    }

    // 4. Check Diagonal (Up-Right: /)
    for (int r = 3; r < rows; r++) {
      for (int c = 0; c <= cols - 4; c++) {
        if (grid[r][c] == player &&
            grid[r - 1][c + 1] == player &&
            grid[r - 2][c + 2] == player &&
            grid[r - 3][c + 3] == player) {
          return true;
        }
      }
    }

    return false;
  }
}
