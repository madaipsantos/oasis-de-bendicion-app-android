// Handler para integração com audio_service
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class RadioAudioHandler extends BaseAudioHandler with SeekHandler {
  final AudioPlayer _player;

  RadioAudioHandler(this._player) {
    _notifyAudioHandlerAboutPlaybackEvents();
    _listenForPlayerStateChanges();
    _setInitialMediaItem();
  }

  void _notifyAudioHandlerAboutPlaybackEvents() {
    _player.playbackEventStream.listen((event) {
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.rewind,
          _player.playing ? MediaControl.pause : MediaControl.play,
          MediaControl.stop,
        ],
        systemActions: const {
          MediaAction.seek,
        },
        androidCompactActionIndices: const [0, 1, 2],
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

  void _listenForPlayerStateChanges() {
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        stop();
      }
    });
  }

  void _setInitialMediaItem() {
    mediaItem.add(MediaItem(
      id: 'https://stream-152.zeno.fm/5qrh7beqizzvv',
      album: 'Oasis de Bendición',
      title: 'Rádio Oasis',
      artist: 'Oasis de Bendición',
      artUri: Uri.parse('https://sua-imagem.com/logo.png'), // Troque para sua logo
    ));
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() => _player.stop();
}