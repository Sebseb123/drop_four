import 'dart:io';

import 'package:vier_gewinnt/src/exceptions/game_exceptions.dart';
import 'package:vier_gewinnt/src/logic/game_controller.dart';
import 'package:vier_gewinnt/src/models/board.dart';

void main() {
  var board = Gameboard();
  stdout.writeln('Board initialized: ${board.rows}x${board.cols}');
  stdout.writeln(board);
  GameController gc = GameController();
  playGame(gc);
}

void playGame(GameController game) {
  while (!game.isGameOver) {
    stdout.writeln(game.board);
    stdout.write(
      '${game.currentPlayer.name} player, choose a column (1-${game.board.cols}): ',
    );
    final input = stdin.readLineSync();
    if (input == null || input.trim().toLowerCase() == 'q') return;

    final column = int.tryParse(input.trim());
    if (column == null) {
      stdout.writeln('Please enter a column number or q to quit.');
      continue;
    }

    try {
      game.dropCoin(column);
    } on ColumnFullException catch (error) {
      stdout.writeln(error);
    } on InvalidColumnException catch (error) {
      stdout.writeln(error);
    }
  }

  stdout.writeln(game.board);
  stdout.writeln(
    game.winner == Player.none
        ? 'The game is a draw.'
        : '${game.winner.name} wins!',
  );
}
