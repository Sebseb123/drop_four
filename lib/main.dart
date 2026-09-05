import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'src/exceptions/game_exceptions.dart';
import 'src/logic/game_controller.dart';
import 'src/models/board.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Align(
            alignment: Alignment.center,
            child: Text('Four Connects'),
          ),
        ),
        body: Center(child: GamePage()),
      ),
    );
  }
}

class Tile extends StatelessWidget {
  const Tile(this.player, {super.key, this.size = 60});
  final Player player;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        //border: Border.all(color: Colors.grey.shade300),
        color: Colors.blue,
      ),
      child: Container(
        width: size - 5,
        height: size - 5,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(size / 2),
          color: switch (player) {
            Player.red => Colors.red,
            Player.yellow => Colors.yellow,
            Player.none => Colors.white,
          },
        ),
      ),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final GameController _gameController = GameController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final widthForBoard = constraints.maxWidth - 30;
          final heightForBoard = constraints.maxHeight - 24;

          final widthBasedTileSize = widthForBoard / _gameController.board.cols;
          final heightBasedTileSize = heightForBoard / (_gameController.board.rows + 1);

          final tileSize = math.min(widthBasedTileSize, heightBasedTileSize);
          
          final boardWidth = tileSize * _gameController.board.cols + 30;

          return SizedBox(
            width: boardWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStatus(),
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
                for (final row in _gameController.board.grid)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (final player in row) Tile(player, size: tileSize),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
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

  Widget _buildStatus() {
    if (_gameController.winner != Player.none) {
      return Text('${_gameController.winner.name} wins!');
    }
    if (_gameController.isDraw) {
      return const Text('Draw');
    }
    return Text('${_gameController.currentPlayer.name}\'s turn');
  }
}

class DropCoinBox extends StatelessWidget {
  const DropCoinBox({
    super.key,
    required this.onDropCoin,
    required this.size,
    required this.enabled,
  });
  final VoidCallback onDropCoin;
  final double size;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    // Wrap your Container in a GestureDetector
    return GestureDetector(
      onTap: enabled ? onDropCoin : null,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(size / 2),
        ),
        child: Icon(
          Icons.arrow_downward,
          color: enabled ? Colors.grey : Colors.grey.shade300,
        ),
      ),
    );
  }
}
