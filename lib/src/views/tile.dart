import 'package:flutter/material.dart';

import '../models/board.dart';

/// Displays one board position as a colored playing piece.
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
      child: Container(
        width: size - 5,
        height: size - 5,
        decoration: BoxDecoration(
          //border: Border.all(color: Colors.grey.shade300),
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
