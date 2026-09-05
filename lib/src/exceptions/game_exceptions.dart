/// Thrown when a coin is dropped into a column with no empty positions.
class ColumnFullException implements Exception {
  /// Creates an exception for [colIndex].
  final int colIndex;
  ColumnFullException(this.colIndex);

  @override
  String toString() => 'Selected column $colIndex is full. Please try again.';
}

/// Thrown when a column number is outside the board's valid range.
class InvalidColumnException implements Exception {
  /// Creates an exception for [colIndex].
  final int colIndex;
  InvalidColumnException(this.colIndex);

  @override
  String toString() => 'Column must be between 1 and 7.';
}
