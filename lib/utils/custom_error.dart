class CustomException implements Exception {
  late String _message;

  CustomException([String message = 'Custom Value']) {
    _message = message;
  }

  @override
  String toString() {
    return _message;
  }
}
