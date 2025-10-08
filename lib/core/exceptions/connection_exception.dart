/// Exception thrown when connection operations fail.
class ConnectionException implements Exception {
  final String message;
  final Object? error;
  final StackTrace? stackTrace;

  /// Creates a new connection exception with the given [message],
  /// optional [error] object and [stackTrace].
  ConnectionException(
    this.message, {
    this.error,
    this.stackTrace,
  });

  @override
  String toString() => 'ConnectionException: $message${error != null ? '\nCause: $error' : ''}';
}