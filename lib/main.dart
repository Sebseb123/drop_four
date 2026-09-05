import 'package:flutter/material.dart';

import 'src/views/game_page.dart';

/// Starts the Four Connects Flutter application.
void main() {
  runApp(const MainApp());
}

/// Root widget for the Four Connects application.
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        /*appBar: AppBar(
          title: const Align(
            alignment: Alignment.center,
            child: Text('Four Connects'),
          ),
        ),*/
        body: Center(child: GamePage()),
      ),
    );
  }
}
