// Handler para integração com audio_service
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

/// Handler responsável por integrar o player de áudio com o audio_service,
/// permitindo controle via notificações e sistema operacional.
class RadioAudioHandler extends BaseAudioHandler with SeekHandler {
  final AudioPlayer _player;

  /// Construtor recebe a instância do player.
  RadioAudioHandler(this._player) {
    _notifyAudioHandlerAboutPlaybackEvents();
    _listenForPlayerStateChanges();
    _setInitialMediaItem();
  }

  /// Escuta eventos do player e atualiza o estado do audio_service,
  /// incluindo controles e status de reprodução.
  void _notifyAudioHandlerAboutPlaybackEvents() {
    _player.playbackEventStream.listen((event) {
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.rewind, // Controle de retroceder (não implementado no player)
          _player.playing ? MediaControl.pause : MediaControl.play, // Alterna play/pause
          MediaControl.stop, // Controle de parar
        ],
        systemActions: const {
          MediaAction.seek, // Permite ação de seek (não implementada aqui)
        },
        androidCompactActionIndices: const [0, 1, 2], // Ícones compactos na notificação
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
  }

  /// Escuta mudanças de estado do player para parar o áudio ao finalizar.
  void _listenForPlayerStateChanges() {
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        stop();
      }
    });
  }

  /// Define o item de mídia inicial exibido nas notificações do sistema.
  void _setInitialMediaItem() {
    mediaItem.add(MediaItem(
      id: 'https://stream-152.zeno.fm/5qrh7beqizzvv',
      album: 'Oasis de Bendición',
      title: 'Rádio Oasis',
      artist: 'Oasis de Bendición',
      artUri: Uri.parse('https://sua-imagem.com/logo.png'), // Troque para sua logo
    ));
  }

  /// Inicia a reprodução do áudio.
  @override
  Future<void> play() => _player.play();

  /// Pausa a reprodução do áudio.
  @override
  Future<void> pause() => _player.pause();

  /// Para a reprodução do áudio.
  @override
  Future<void> stop() => _player.stop();
}