import 'package:flutter_test/flutter_test.dart';
import 'package:vier_gewinnt/src/logic/game_controller.dart';
import 'package:vier_gewinnt/src/models/board.dart';

GameController controllerWithTiles(List<List<int>> positions, Player player) {
  final grid = List.generate(6, (_) => List<Player>.filled(7, Player.none));
  for (final position in positions) {
    grid[position[0]][position[1]] = player;
  }
  return GameController(board: Gameboard.fromGrid(grid));
}

void main() {
  group('checkWinCondition', () {
    test('detects four horizontal pieces', () {
      final controller = controllerWithTiles([
        [0, 3],
        [0, 4],
        [0, 5],
        [0, 6],
      ], Player.red);

      expect(controller.checkWinCondition(Player.red), isTrue);
    });

    test('detects four vertical pieces', () {
      final controller = controllerWithTiles([
        [2, 6],
        [3, 6],
        [4, 6],
        [5, 6],
      ], Player.yellow);

      expect(controller.checkWinCondition(Player.yellow), isTrue);
    });

    test('detects a down-right diagonal', () {
      final controller = controllerWithTiles([
        [0, 0],
        [1, 1],
        [2, 2],
        [3, 3],
      ], Player.red);

      expect(controller.checkWinCondition(Player.red), isTrue);
    });

    test('detects an up-right diagonal', () {
      final controller = controllerWithTiles([
        [5, 0],
        [4, 1],
        [3, 2],
        [2, 3],
      ], Player.yellow);

      expect(controller.checkWinCondition(Player.yellow), isTrue);
    });

    test('does not count fewer than four pieces', () {
      final controller = controllerWithTiles([
        [5, 0],
        [5, 1],
        [5, 2],
      ], Player.red);

      expect(controller.checkWinCondition(Player.red), isFalse);
    });

    test('does not count another player pieces', () {
      final controller = controllerWithTiles([
        [5, 0],
        [5, 1],
        [5, 2],
        [5, 3],
      ], Player.red);

      expect(controller.checkWinCondition(Player.yellow), isFalse);
    });

    test('does not count empty tiles as a win', () {
      final controller = GameController();

      expect(controller.checkWinCondition(Player.none), isFalse);
    });
  });

  test('detects a win immediately after a move', () {
    final controller = GameController();
    controller.dropCoin(1);
    controller.dropCoin(2);
    controller.dropCoin(1);
    controller.dropCoin(2);
    controller.dropCoin(1);
    controller.dropCoin(2);
    controller.dropCoin(1);

    expect(controller.winner, Player.red);
    expect(controller.isGameOver, isTrue);
  });

  test('rejects invalid columns', () {
    final controller = GameController();

    expect(() => controller.dropCoin(0), throwsA(isA<Exception>()));
    expect(() => controller.dropCoin(8), throwsA(isA<Exception>()));
  });

  test('does not allow a coin in a full column', () {
    final board = Gameboard();
    for (var turn = 0; turn < 6; turn++) {
      board.dropCoin(1, turn.isEven ? Player.red : Player.yellow);
    }

    expect(() => board.dropCoin(1, Player.red), throwsA(isA<Exception>()));
  });
}
