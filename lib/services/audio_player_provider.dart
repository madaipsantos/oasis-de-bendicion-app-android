
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';

class AudioPlayerProvider extends ChangeNotifier with WidgetsBindingObserver {
  String _currentTitle = 'Oasis Rádio';
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

  AudioPlayerProvider() {
    WidgetsBinding.instance.addObserver(this);
    // Removido qualquer inicialização assíncrona aqui
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
      // Listener para eventos de erro do player
      bool triedToLoad = false;
      bool stoppedManually = false;
      _subscriptions.add(_player.playbackEventStream.listen((event) {
        // Detecta parada manual
        if (event.processingState == ProcessingState.idle && _isPlaying == false && triedToLoad) {
          stoppedManually = true;
        }
        // Só considera erro de streaming se já tentou carregar o áudio e não foi parada manual
        if ((event.processingState == ProcessingState.loading || event.processingState == ProcessingState.buffering)) {
          triedToLoad = true;
        }
        if (triedToLoad && event.processingState == ProcessingState.idle && _streamingAvailable && !stoppedManually) {
          _streamingAvailable = false;
          _streamingError = true;
          _isLoading = false;
          notifyListeners();
        }
        // Se está em idle por parada manual, não é erro
        if (stoppedManually) {
          _streamingError = false;
          notifyListeners();
        }
      }));
    if (_initialized) return;
    _initialized = true;
    try {
      final session = await AudioSession.instance;
      await session.configure(AudioSessionConfiguration.music());
      _isLoading = true;
      notifyListeners();
      await _player.setAudioSource(
        AudioSource.uri(Uri.parse('https://stream-152.zeno.fm/5qrh7beqizzvv')),
      );
      _isLoading = false;
      _streamingAvailable = true;
      notifyListeners();

      _subscriptions.add(_player.playerStateStream.listen((state) {
        final playing = state.playing;
        final loading = state.processingState == ProcessingState.loading ||
            state.processingState == ProcessingState.buffering;
        if (_isPlaying != playing || _isLoading != loading) {
          _isPlaying = playing;
          _isLoading = loading;
          notifyListeners();
        }
        // Detecta erro de streaming (por exemplo, URL inválida, 404, etc)
        if (state.processingState == ProcessingState.idle && _streamingAvailable) {
          _streamingAvailable = false;
          notifyListeners();
        }
      }));

      _subscriptions.add(_player.icyMetadataStream.listen((icy) {
        final title = icy?.info?.title;
        if (title != null) {
          _currentTitle = title;
          (_audioHandler as RadioAudioHandler).updateCurrentMediaItem(title: title);
          notifyListeners();
        }
      }));
    } catch (e) {
      _isLoading = false;
      _streamingAvailable = false;
      notifyListeners();
    }
  }

  void togglePlayPause() {
    if (_isPlaying) {
      _audioHandler?.pause();
    } else {
      // Exibe loading durante a reconexão
      _isLoading = true;
      notifyListeners();
      if (_isFirstPlay) {
        _player.setVolume(1.0);
        _isFirstPlay = false;
      }
      _audioHandler?.play();
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
      id: 'https://stream-152.zeno.fm/5qrh7beqizzvv',
      album: 'Rádio Oasis',
      title: 'Oasis Rádio',
      artist: 'Oasis de Bendición',
    ));
  }

  void updateCurrentMediaItem({required String title}) {
    mediaItem.add(MediaItem(
      id: 'https://stream-152.zeno.fm/5qrh7beqizzvv',
      artist: title.isNotEmpty ? title : 'Oasis Rádio',
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
