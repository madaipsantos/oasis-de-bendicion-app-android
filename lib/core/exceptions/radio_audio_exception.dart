/// Exception thrown when radio audio operations fail.
class RadioAudioException implements Exception {
  final String message;
  final Object? error;
  final StackTrace? stackTrace;

  /// Creates a new radio audio exception with the given [message],
  /// optional [error] object and [stackTrace].
  RadioAudioException(
    this.message, {
    this.error,
    this.stackTrace,
  });

  @override
  String toString() => 'RadioAudioException: $message${error != null ? '\nCause: $error' : ''}';
}