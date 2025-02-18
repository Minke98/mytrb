class CustomException implements Exception {
  String _message = "";

  CustomException([String message = 'Invalid value']) {
    _message = message;
  }

  @override
  String toString() {
    return _message;
  }
}
