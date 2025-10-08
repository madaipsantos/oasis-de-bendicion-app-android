/// Custom exceptions for audio player operations
class AudioException implements Exception {
  final String message;
  
  AudioException([this.message = 'An audio error occurred']);
  
  @override
  String toString() => message;
}

/// Exception for audio streaming issues
class AudioStreamingException extends AudioException {
  AudioStreamingException([String message = 'Audio streaming error']) : super(message);
  
  @override
  String toString() => 'AudioStreamingException: $message';
}

/// Exception for audio initialization issues
class AudioInitializationException extends AudioException {
  AudioInitializationException([String message = 'Audio initialization error']) : super(message);
  
  @override
  String toString() => 'AudioInitializationException: $message';
}

/// Exception for audio session configuration issues
class AudioSessionException extends AudioException {
  AudioSessionException([String message = 'Audio session configuration error']) : super(message);
  
  @override
  String toString() => 'AudioSessionException: $message';
}

/// Exception for audio service initialization issues
class AudioServiceException extends AudioException {
  AudioServiceException([String message = 'Audio service initialization error']) : super(message);
  
  @override
  String toString() => 'AudioServiceException: $message';
}

/// Exception for audio playback control issues
class AudioPlaybackException extends AudioException {
  AudioPlaybackException([String message = 'Audio playback control error']) : super(message);
  
  @override
  String toString() => 'AudioPlaybackException: $message';
}