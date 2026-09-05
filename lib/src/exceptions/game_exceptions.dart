class ColumnFullException implements Exception {
  final int colIndex;
  ColumnFullException(this.colIndex);

  @override
  String toString() => 'Selected column $colIndex is full. Please try again.';
}

class InvalidColumnException implements Exception {
  final int colIndex;
  InvalidColumnException(this.colIndex);

  @override
  String toString() => 'Column must be between 1 and 7.';
}
