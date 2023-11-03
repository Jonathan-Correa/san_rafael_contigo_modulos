class ServerError {
  final String message;
  final bool shouldLogout;
  final bool shouldRetry;

  const ServerError({
    required this.message,
    this.shouldRetry = false,
    this.shouldLogout = false,
  });

  @override
  String toString() {
    return '''
      Loading Error:
        message: $message.
        shouldLogout: $shouldLogout.
        shouldRetry: $shouldRetry.
    ''';
  }
}
