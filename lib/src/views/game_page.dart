import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../exceptions/game_exceptions.dart';
import '../logic/game_controller.dart';
import '../models/board.dart';
import 'drop_coin_box.dart';
import 'tile.dart';

/// Displays the board and handles user moves.
class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  GameController _gameController = GameController(Player.red);

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: orientation == Orientation.landscape
              ? _buildLandscapeLayout()
              : _buildPortraitLayout(),
        );
      },
    );
  }

  Widget _buildPortraitLayout() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final widthForBoard = constraints.maxWidth - 30;
        final heightForBoard = constraints.maxHeight - 20;
        final widthBasedTileSize = widthForBoard / _gameController.board.cols;
        final heightBasedTileSize =
            heightForBoard / (_gameController.board.rows + 1);
        final tileSize = math.min(widthBasedTileSize, heightBasedTileSize);
        final boardWidth = tileSize * _gameController.board.cols + 30;

        return SizedBox(
          width: boardWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [_buildStatusPanel(), _buildBoardSection(tileSize)],
          ),
        );
      },
    );
  }

  Widget _buildLandscapeLayout() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const statusWidth = 220.0;
        final widthForBoard = constraints.maxWidth - statusWidth - 30;
        final heightForBoard = constraints.maxHeight - 20;
        final widthBasedTileSize = widthForBoard / _gameController.board.cols;
        final heightBasedTileSize =
            heightForBoard / (_gameController.board.rows + 1);
        final tileSize = math.min(widthBasedTileSize, heightBasedTileSize);
        final boardWidth = tileSize * _gameController.board.cols + 30;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: boardWidth, child: _buildBoardSection(tileSize)),
            const SizedBox(width: 24),
            SizedBox(width: statusWidth, child: _buildStatusPanel()),
          ],
        );
      },
    );
  }

  Widget _buildBoardSection(double tileSize) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < _gameController.board.cols; i++)
              DropCoinBox(
                size: tileSize,
                enabled: !_gameController.isGameOver,
                onDropCoin: () => _dropCoin(i + 1),
              ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              for (final row in _gameController.board.grid)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (final player in row) Tile(player, size: tileSize),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  void _dropCoin(int column) {
    try {
      _gameController.dropCoin(column);
      setState(() {});
    } on ColumnFullException catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    } on InvalidColumnException catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  void _playAgain() {
    setState(() {
      _gameController = _gameController.playAgain();
    });
  }

  Widget _buildStatusPanel() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildStatus(),
        if (_gameController.isGameOver) ...[
          const SizedBox(height: 12), //this acts as a spacer
          ElevatedButton(
            onPressed: _playAgain,
            child: const Text('Play again'),
          ),
        ],
      ],
    );
  }

  Widget _buildStatus() {
    final String message;
    final Color color;

    if (_gameController.winner != Player.none) {
      message = '${_gameController.winner.name} wins!';
      color = Colors.green;
    } else if (_gameController.isDraw) {
      message = 'Draw';
      color = Colors.orange;
    } else {
      message = '${_gameController.currentPlayer.name}\'s turn';
      color = _playerColor(_gameController.currentPlayer);
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: Container(
        key: ValueKey(message),
        constraints: const BoxConstraints(minWidth: 220),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge
              ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Color _playerColor(Player player) {
    return switch (player) {
      Player.red => Colors.red,
      Player.yellow => Colors.yellow,
      Player.none => Colors.white,
    };
  }
}
