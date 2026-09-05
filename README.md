# Vier Connects

A small Flutter implementation of the classic Connect Four game. Two players
take turns dropping red and yellow coins into a 7-column, 6-row board. The
first player to connect four coins horizontally, vertically, or diagonally
wins.

## Requirements

- Flutter SDK with Dart 3.13 or later
- A Flutter-supported desktop, web, or mobile device

## Run the application

Install dependencies and start the Flutter app with:

```bash
flutter pub get
flutter run
```

The project can also be run on a specific device, for example:

```bash
flutter run -d chrome
```

## Run the tests

Run the automated tests with:

```bash
flutter test
```

The tests cover horizontal, vertical, and diagonal wins, invalid columns,
full columns, and game-over behavior.

## Project structure

- `lib/main.dart` contains the Flutter user interface.
- `lib/src/models/board.dart` contains the board and coin-placement rules.
- `lib/src/logic/game_controller.dart` manages turns, wins, and draws.
- `lib/src/exceptions/game_exceptions.dart` contains invalid-move exceptions.
- `test/` contains automated tests for the game logic.
- `bin/test_game.dart` provides a simple terminal version of the game.
