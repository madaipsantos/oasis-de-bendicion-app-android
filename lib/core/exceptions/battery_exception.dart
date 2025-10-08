/// Exception thrown when battery optimization operations fail.
class BatteryException implements Exception {
  final String message;
  final Object? error;
  final StackTrace? stackTrace;

  /// Creates a new battery exception with the given [message],
  /// optional [error] object and [stackTrace].
  BatteryException(
    this.message, {
    this.error,
    this.stackTrace,
  });

  @override
  String toString() => 'BatteryException: $message${error != null ? '\nCause: $error' : ''}';
}