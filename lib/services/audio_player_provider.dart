import 'package:flutter/material.dart';
import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';

// Classe de constantes para centralizar informações do rádio
class RadioConstants {
  static const String streamUrl = 'https://stream-152.zeno.fm/5qrh7beqizzvv';
  static const String defaultTitle = 'Oasis Rádio';
  static const String radioName = 'Rádio Oasis';
  static const String artistName = 'Oasis de Bendición';
}

// Provider responsável por controlar o player de áudio e seu estado
class AudioPlayerProvider extends ChangeNotifier with WidgetsBindingObserver {
  String _currentTitle = RadioConstants.defaultTitle;
  String get currentTitle => _currentTitle;

  AudioPlayer _player = AudioPlayer(); // Instância do player
  List<StreamSubscription> subscriptions = []; // Lista de listeners ativos
  AudioHandler? _audioHandler; // Handler para integração com notificações e controles do sistema

  // Estados internos do player
  bool _isPlaying = false;
  bool _isLoading = false;
  bool _initialized = false;
  bool get initialized => _initialized;
  bool _isFirstPlay = true;
  bool _streamingAvailable = true;
  bool get streamingAvailable => _streamingAvailable;
  bool _streamingError = false;
  bool get streamingError => _streamingError;

  // Variáveis de controle para listeners e erros
  bool _triedToLoad = false;
  bool _stoppedManually = false;
  bool _errorHandled = false;

  AudioPlayerProvider() {
    // Observa mudanças no ciclo de vida do app
    WidgetsBinding.instance.addObserver(this);
  }

  // Inicializa o AudioService e o handler para integração com notificações
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

  // Prepara o player para tocar, reinicializando tudo
  Future<void> preparePlayer() async {
    _streamingAvailable = true;
    _streamingError = false;
    _isLoading = true;
    _initialized = false;
    _isFirstPlay = true;
    _isPlaying = false;
    notifyListeners();

    // Remove listeners antigos
    for (final sub in subscriptions) {
      await sub.cancel();
    }
    subscriptions.clear();

    // Descarta player antigo e cria um novo
    _player.dispose();
    _player = AudioPlayer();

    // Atualiza o player do handler, se já existe
    if (_audioHandler != null && _audioHandler is RadioAudioHandler) {
      (_audioHandler as RadioAudioHandler).updatePlayer(_player);
    }

    // Inicializa o player (configura sessão, listeners, etc)
    await _initializePlayer();
  }

  // Inicializa o player e listeners
  Future<void> _initializePlayer() async {
    if (_initialized) return;
    _initialized = true;

    _resetControlVariables();
    _setupPlayerListeners();
    await _configureAudioSession();
    await _setAudioSource();
    _setupMetadataListener();
  }

  // Reseta variáveis de controle de erro e estado
  void _resetControlVariables() {
    _triedToLoad = false;
    _stoppedManually = false;
    _errorHandled = false;
  }

  // Adiciona listeners para eventos do player
  void _setupPlayerListeners() {
    subscriptions.add(_player.playbackEventStream.listen(
      _handlePlaybackEvent,
      onError: _handlePlaybackError,
    ));

    subscriptions.add(_player.playerStateStream.listen(_handlePlayerStateChange));
  }

  // Lida com eventos de reprodução (buffer, erro, idle, etc)
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

  // Lida com erros do player
  void _handlePlaybackError(dynamic error) {
    if (!_errorHandled) {
      _errorHandled = true;
      _setStreamingError();
    }
  }

  // Atualiza estados de playing/loading conforme mudanças do player
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

  // Configura a sessão de áudio do sistema (para controle de foco, etc)
  Future<void> _configureAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());
    _isLoading = true;
    notifyListeners();
  }

  // Define a fonte de áudio (stream da rádio)
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

  // Listener para metadados ICY (título da música, etc)
  void _setupMetadataListener() {
    subscriptions.add(_player.icyMetadataStream.listen((icy) {
      final title = icy?.info?.title;
      if (title != null) {
        _currentTitle = title;
        (_audioHandler as RadioAudioHandler).updateCurrentMediaItem(title: title);
        notifyListeners();
      }
    }));
  }

  // Métodos de gerenciamento de estado
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

  // Helper para saber se pode tocar
  bool get _canPlay => _streamingAvailable && !_streamingError;

  // Alterna entre play e pause
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

  // Altera o volume do player
  Future<void> setVolume(double volume) async {
    if (volume >= 0.0 && volume <= 1.0) {
      await _player.setVolume(volume);
      notifyListeners();
    }
  }

  // Para completamente a reprodução e reseta estados
  Future<void> stopCompletely() async {
    if (_audioHandler != null) {
      await _audioHandler!.stop();
    }
    _isPlaying = false;
    _isFirstPlay = true;
    notifyListeners();
  }

  // Lida com mudanças no ciclo de vida do app (ex: fechar app)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached && _isPlaying) {
      stopCompletely();
    }
  }

  // Limpa listeners e recursos ao destruir o provider
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    for (final sub in subscriptions) {
      sub.cancel();
    }
    subscriptions.clear();
    _player.dispose();
    super.dispose();
  }
}

// Handler para integração com notificações e controles do sistema operacional
class RadioAudioHandler extends BaseAudioHandler with SeekHandler {
  AudioPlayer _player;

  RadioAudioHandler(this._player) {
    _listenPlayerStreams();
    _setInitialMediaItem();
  }

  // Atualiza o player usado pelo handler (quando reinicializa)
  void updatePlayer(AudioPlayer newPlayer) {
    // Não é necessário remover listeners do handler, pois são removidos em preparePlayer
    _player = newPlayer;
    _listenPlayerStreams();
  }

  // Adiciona listeners para atualizar o estado do sistema (notificações, controles)
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

  // Define o item de mídia inicial (usado nas notificações)
  void _setInitialMediaItem() {
    mediaItem.add(MediaItem(
      id: RadioConstants.streamUrl,
      album: RadioConstants.radioName,
      title: RadioConstants.defaultTitle,
      artist: RadioConstants.artistName,
    ));
  }

  // Atualiza o item de mídia com o título atual (ex: música tocando)
  void updateCurrentMediaItem({required String title}) {
    mediaItem.add(MediaItem(
      id: RadioConstants.streamUrl,
      artist: title.isNotEmpty ? title : RadioConstants.defaultTitle,
      title: 'Oasis Radio',
    ));
  }

  // Implementações dos comandos básicos do player
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