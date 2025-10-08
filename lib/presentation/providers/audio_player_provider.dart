import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';

/// Centralized radio constants.
class RadioConstants {
  static const String streamUrl = 'https://stream-152.zeno.fm/5qrh7beqizzvv';
  static const String defaultTitle = 'Oasis Rádio';
  static const String radioName = 'Rádio Oasis';
  static const String artistName = 'Oasis de Bendición';
}

/// Provider responsible for controlling the audio player and its state.
class AudioPlayerProvider extends ChangeNotifier with WidgetsBindingObserver {
  String _currentTitle = RadioConstants.defaultTitle;
  String get currentTitle => _currentTitle;

  AudioPlayer _player = AudioPlayer();
  List<StreamSubscription> subscriptions = [];
  AudioHandler? _audioHandler;

  // Internal player states
  bool _isPlaying = false;
  bool _isLoading = false;
  bool _initialized = false;
  bool _isFirstPlay = true;
  bool _streamingAvailable = true;
  bool _streamingError = false;

  // Control variables for listeners and errors
  bool _triedToLoad = false;
  bool _stoppedManually = false;
  bool _errorHandled = false;

  /// Constructor: observes app lifecycle changes.
  AudioPlayerProvider() {
    WidgetsBinding.instance.addObserver(this);
  }

  /// Initializes the AudioService and handler for system notifications.
  Future<void> initAudioService() async {
    if (_audioHandler != null) return;
    _audioHandler = await AudioService.init(
      builder: () => RadioAudioHandler(_player),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.oasis.radio.channel.audio',
        androidNotificationChannelName: 'Rádio Oasis',
        androidNotificationOngoing: false,
        androidStopForegroundOnPause: false,
      ),
    );
  }

  AudioPlayer get player => _player;
  bool get isPlaying => _isPlaying;
  bool get isLoading => _isLoading;
  double get volume => _player.volume;
  bool get streamingAvailable => _streamingAvailable;
  bool get streamingError => _streamingError;
  bool get initialized => _initialized;

  /// Prepares the player for playback, reinitializing everything.
  Future<void> preparePlayer() async {
    _streamingAvailable = true;
    _streamingError = false;
    _isLoading = true;
    _initialized = false;
    _isFirstPlay = true;
    _isPlaying = false;

    // Remove old listeners
    for (final sub in subscriptions) {
      await sub.cancel();
    }
    subscriptions.clear();

    // Dispose old player and create a new one
    _player.dispose();
    _player = AudioPlayer();

    // Update handler's player if it exists
    if (_audioHandler is RadioAudioHandler) {
      (_audioHandler as RadioAudioHandler).updatePlayer(_player);
    }

    // Initialize player (session, listeners, etc)
    await _initializePlayer();
    notifyListeners();
  }

  /// Initializes the player and listeners.
  Future<void> _initializePlayer() async {
    if (_initialized) return;
    _initialized = true;

    _resetControlVariables();
    _setupPlayerListeners();
    await _configureAudioSession();
    await _setAudioSource();
    _setupMetadataListener();
  }

  /// Resets error and state control variables.
  void _resetControlVariables() {
    _triedToLoad = false;
    _stoppedManually = false;
    _errorHandled = false;
  }

  /// Adds listeners for player events.
  void _setupPlayerListeners() {
    subscriptions.add(_player.playbackEventStream.listen(
      _handlePlaybackEvent,
      onError: _handlePlaybackError,
    ));

    subscriptions.add(_player.playerStateStream.listen(_handlePlayerStateChange));
  }

  /// Handles playback events (buffer, error, idle, etc).
  void _handlePlaybackEvent(PlaybackEvent event) {
    // Detect manual stop
    if (event.processingState == ProcessingState.idle && !_isPlaying && _triedToLoad) {
      _stoppedManually = true;
    }

    // Mark that loading was attempted
    if (event.processingState == ProcessingState.loading || event.processingState == ProcessingState.buffering) {
      _triedToLoad = true;
    }

    // Detect streaming error
    if (_triedToLoad && event.processingState == ProcessingState.idle && _streamingAvailable && !_stoppedManually) {
      _setStreamingError();
    }

    // Clear error if manually stopped
    if (_stoppedManually) {
      _clearStreamingError();
    }
  }

  /// Handles player errors.
  void _handlePlaybackError(dynamic error) {
    if (!_errorHandled) {
      _errorHandled = true;
      _setStreamingError();
    }
  }

  /// Updates playing/loading states according to player changes.
  void _handlePlayerStateChange(PlayerState state) {
    final playing = state.playing;
    final loading = state.processingState == ProcessingState.loading ||
        state.processingState == ProcessingState.buffering;

    // Only update loading if no streaming error
    if (!_streamingError) {
      if (_isPlaying != playing || _isLoading != loading) {
        _isPlaying = playing;
        _isLoading = loading;
        notifyListeners();
      }
    } else {
      // If streaming error, keep loading as false
      if (_isPlaying != playing || _isLoading != false) {
        _isPlaying = playing;
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  /// Configures the system audio session (for focus, etc).
  Future<void> _configureAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());
    _isLoading = true;
    notifyListeners();
  }

  /// Sets the audio source (radio stream).
  Future<void> _setAudioSource() async {
    try {
      await _player.setAudioSource(
        AudioSource.uri(Uri.parse(RadioConstants.streamUrl)),
      );
      _setStreamingSuccess();
    } catch (e) {
      _setStreamingError();
    }
  }

  /// Listens for ICY metadata (song title, etc).
  void _setupMetadataListener() {
    subscriptions.add(_player.icyMetadataStream.listen((icy) {
      final title = icy?.info?.title;
      if (title != null) {
        _currentTitle = title;
        if (_audioHandler is RadioAudioHandler) {
          (_audioHandler as RadioAudioHandler).updateCurrentMediaItem(title: title);
        }
        notifyListeners();
      }
    }));
  }

  /// Sets streaming error state.
  void _setStreamingError() {
    _streamingAvailable = false;
    _streamingError = true;
    _isLoading = false;
    notifyListeners();
  }

  /// Clears streaming error state.
  void _clearStreamingError() {
    _streamingError = false;
    notifyListeners();
  }

  /// Sets streaming success state.
  void _setStreamingSuccess() {
    _isLoading = false;
    _streamingAvailable = true;
    _streamingError = false;
    notifyListeners();
  }

  /// Sets loading state.
  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  /// Returns true if playback is possible.
  bool get _canPlay => _streamingAvailable && !_streamingError;

  /// Toggles between play and pause.
  void togglePlayPause() {
    if (_isPlaying) {
      _audioHandler?.pause();
    } else {
      if (_canPlay) {
        _setLoading(true);
        if (_isFirstPlay) {
          _player.setVolume(1.0);
          _isFirstPlay = false;
        }
        _audioHandler?.play();
      }
    }
  }

  /// Changes the player volume.
  Future<void> setVolume(double volume) async {
    if (volume >= 0.0 && volume <= 1.0) {
      await _player.setVolume(volume);
      notifyListeners();
    }
  }

  /// Completely stops playback and resets states.
  Future<void> stopCompletely() async {
    await _audioHandler?.stop();
    _isPlaying = false;
    _isFirstPlay = true;
    notifyListeners();
  }

  /// Handles app lifecycle changes (e.g., app closed).
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached && _isPlaying) {
      stopCompletely();
    }
  }

  /// Cleans up listeners and resources when disposing the provider.
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    for (final sub in subscriptions) {
      sub.cancel();
    }
    _player.dispose();
    super.dispose();
  }
}

/// Handler for integration with system notifications and controls.
class RadioAudioHandler extends BaseAudioHandler with SeekHandler {
  AudioPlayer _player;

  /// Creates a handler for the given [AudioPlayer].
  RadioAudioHandler(this._player) {
    _listenPlayerStreams();
    _setInitialMediaItem();
  }

  /// Updates the player used by the handler (when reinitializing).
  void updatePlayer(AudioPlayer newPlayer) {
    _player = newPlayer;
    _listenPlayerStreams();
  }

  /// Adds listeners to update system state (notifications, controls).
  void _listenPlayerStreams() {
    _player.playbackEventStream.listen((event) {
      playbackState.add(playbackState.value.copyWith(
        controls: [
          _player.playing ? MediaControl.pause : MediaControl.play,
          MediaControl.stop,
        ],
        systemActions: const {MediaAction.seek},
        androidCompactActionIndices: const [0, 1],
        playing: _player.playing,
        processingState: {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_player.processingState]!,
      ));
    });
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        stop();
      }
    });
  }

  /// Sets the initial media item (used in notifications).
  void _setInitialMediaItem() {
    mediaItem.add(MediaItem(
      id: RadioConstants.streamUrl,
      album: RadioConstants.radioName,
      title: RadioConstants.defaultTitle,
      artist: RadioConstants.artistName,
    ));
  }

  /// Updates the media item with the current title (e.g., currently playing song).
  void updateCurrentMediaItem({required String title}) {
    mediaItem.add(MediaItem(
      id: RadioConstants.streamUrl,
      artist: title.isNotEmpty ? title : RadioConstants.defaultTitle,
      title: 'Oasis Radio',
    ));
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    await _player.stop();
    playbackState.add(playbackState.value.copyWith(
      controls: [],
      playing: false,
      processingState: AudioProcessingState.idle,
    ));
    mediaItem.add(null);
  }
}