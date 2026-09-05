import 'package:flutter/material.dart';

/// Displays a column control that lets the user drop a coin.
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
