
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';

// Constants
class RadioConstants {
  static const String streamUrl = 'https://stream-152.zeno.fm/5qrh7beqizzvv';
  static const String defaultTitle = 'Oasis Rádio';
  static const String radioName = 'Rádio Oasis';
  static const String artistName = 'Oasis de Bendición';
}

class AudioPlayerProvider extends ChangeNotifier with WidgetsBindingObserver {
  String _currentTitle = RadioConstants.defaultTitle;
  String get currentTitle => _currentTitle;
  AudioPlayer _player = AudioPlayer();
  List<StreamSubscription> _subscriptions = [];
  AudioHandler? _audioHandler;
  bool _isPlaying = false;
  bool _isLoading = false;
  bool _initialized = false;
  bool get initialized => _initialized;
  bool _isFirstPlay = true;
  bool _streamingAvailable = true;
  bool get streamingAvailable => _streamingAvailable;
  bool _streamingError = false;
  bool get streamingError => _streamingError;
  
  // Variáveis para controle de estado dos listeners
  bool _triedToLoad = false;
  bool _stoppedManually = false;
  bool _errorHandled = false;

  AudioPlayerProvider() {
    WidgetsBinding.instance.addObserver(this);
  }

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

  Future<void> preparePlayer() async {
    // Sempre resetar estado e listeners
    _streamingAvailable = true;
    _streamingError = false;
    _isLoading = true;
    _initialized = false;
    _isFirstPlay = true;
    _isPlaying = false;
    notifyListeners();
    // Remove listeners antigos
    for (final sub in _subscriptions) {
      await sub.cancel();
    }
    _subscriptions.clear();
    // Dispose do player antigo
    _player.dispose();
    // Cria novo player
    _player = AudioPlayer();
    // Atualiza o player do handler, se já existe
    if (_audioHandler != null && _audioHandler is RadioAudioHandler) {
      (_audioHandler as RadioAudioHandler).updatePlayer(_player);
    }
    // Não reinicializa o handler nem o AudioService
    await _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    if (_initialized) return;
    _initialized = true;
    
    _resetControlVariables();
    _setupPlayerListeners();
    await _configureAudioSession();
    await _setAudioSource();
    _setupMetadataListener();
  }

  void _resetControlVariables() {
    _triedToLoad = false;
    _stoppedManually = false;
    _errorHandled = false;
  }

  void _setupPlayerListeners() {
    _subscriptions.add(_player.playbackEventStream.listen(
      _handlePlaybackEvent,
      onError: _handlePlaybackError,
    ));

    _subscriptions.add(_player.playerStateStream.listen(_handlePlayerStateChange));
  }

  void _handlePlaybackEvent(PlaybackEvent event) {
    // Detecta parada manual
    if (event.processingState == ProcessingState.idle && _isPlaying == false && _triedToLoad) {
      _stoppedManually = true;
    }
    
    // Marca que tentou carregar
    if ((event.processingState == ProcessingState.loading || event.processingState == ProcessingState.buffering)) {
      _triedToLoad = true;
    }
    
    // Detecta erro de streaming
    if (_triedToLoad && event.processingState == ProcessingState.idle && _streamingAvailable && !_stoppedManually) {
      _setStreamingError();
    }
    
    // Limpa erro se foi parada manual
    if (_stoppedManually) {
      _clearStreamingError();
    }
  }

  void _handlePlaybackError(dynamic error) {
    if (!_errorHandled) {
      _errorHandled = true;
      _setStreamingError();
    }
  }

  void _handlePlayerStateChange(PlayerState state) {
    final playing = state.playing;
    final loading = state.processingState == ProcessingState.loading ||
        state.processingState == ProcessingState.buffering;
    
    // Só atualiza loading se não houver erro de streaming
    if (!_streamingError) {
      if (_isPlaying != playing || _isLoading != loading) {
        _isPlaying = playing;
        _isLoading = loading;
        notifyListeners();
      }
    } else {
      // Se há erro de streaming, mantém loading como false
      if (_isPlaying != playing || _isLoading != false) {
        _isPlaying = playing;
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> _configureAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());
    _isLoading = true;
    notifyListeners();
  }

  Future<void> _setAudioSource() async {
    try {
      await _player.setAudioSource(
        AudioSource.uri(Uri.parse(RadioConstants.streamUrl)),
      );
      _setStreamingSuccess();
    } catch (e) {
      _setStreamingError();
      return;
    }
  }

  void _setupMetadataListener() {
    _subscriptions.add(_player.icyMetadataStream.listen((icy) {
      final title = icy?.info?.title;
      if (title != null) {
        _currentTitle = title;
        (_audioHandler as RadioAudioHandler).updateCurrentMediaItem(title: title);
        notifyListeners();
      }
    }));
  }

  // State Management Methods
  void _setStreamingError() {
    _streamingAvailable = false;
    _streamingError = true;
    _isLoading = false;
    notifyListeners();
  }

  void _clearStreamingError() {
    _streamingError = false;
    notifyListeners();
  }

  void _setStreamingSuccess() {
    _isLoading = false;
    _streamingAvailable = true;
    _streamingError = false;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Helper Methods
  bool get _canPlay => _streamingAvailable && !_streamingError;

  void togglePlayPause() {
    if (_isPlaying) {
      _audioHandler?.pause();
    } else {
      if (_canPlay) {
        // Exibe loading durante a reconexão
        _setLoading(true);
        if (_isFirstPlay) {
          _player.setVolume(1.0);
          _isFirstPlay = false;
        }
        _audioHandler?.play();
      }
    }
  }

  Future<void> setVolume(double volume) async {
    if (volume >= 0.0 && volume <= 1.0) {
      await _player.setVolume(volume);
      notifyListeners();
    }
  }

  Future<void> stopCompletely() async {
    if (_audioHandler != null) {
      await _audioHandler!.stop();
    }
    _isPlaying = false;
    _isFirstPlay = true;
    notifyListeners();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached && _isPlaying) {
      stopCompletely();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();
    _player.dispose();
    super.dispose();
  }
}

class RadioAudioHandler extends BaseAudioHandler with SeekHandler {
  AudioPlayer _player;

  RadioAudioHandler(this._player) {
    _listenPlayerStreams();
    _setInitialMediaItem();
  }

  void updatePlayer(AudioPlayer newPlayer) {
    // Remove listeners antigos do player anterior
    // Não é necessário remover listeners do handler, pois são removidos em preparePlayer
    _player = newPlayer;
    _listenPlayerStreams();
  }

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

  void _setInitialMediaItem() {
    mediaItem.add(MediaItem(
      id: RadioConstants.streamUrl,
      album: RadioConstants.radioName,
      title: RadioConstants.defaultTitle,
      artist: RadioConstants.artistName,
    ));
  }

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
