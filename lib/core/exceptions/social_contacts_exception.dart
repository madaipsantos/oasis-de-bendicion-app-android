/// Exception thrown when social contacts operations fail.
class SocialContactsException implements Exception {
  final String message;
  final Object? error;
  final StackTrace? stackTrace;

  /// Creates a new social contacts exception with the given [message],
  /// optional [error] object and [stackTrace].
  SocialContactsException(
    this.message, {
    this.error,
    this.stackTrace,
  });

  @override
  String toString() => 'SocialContactsException: $message${error != null ? '\nCause: $error' : ''}';
}