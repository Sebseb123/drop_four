import 'package:vier_gewinnt/src/models/board.dart';

class GameController {
  GameController({Gameboard? board}) : board = board ?? Gameboard();

  final Gameboard board;
  Player _currentPlayer = Player.red;
  Player _winner = Player.none;
  bool _isDraw = false;

  Player get currentPlayer => _currentPlayer;
  Player get winner => _winner;
  bool get isDraw => _isDraw;
  bool get isGameOver => winner != Player.none || isDraw;

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

  // Checks if a specific player has 4 consecutive pieces on the board.
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
