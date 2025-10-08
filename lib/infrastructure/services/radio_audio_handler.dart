/// Audio handler for integrating just_audio with audio_service.
/// Provides playback controls and notification updates.
library;

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:webradiooasis/core/exceptions/radio_audio_exception.dart';

// Constants for media item details
const String kStreamUrl = 'https://stream-152.zeno.fm/5qrh7beqizzvv';
const String kAlbumName = 'Oasis de Bendición';
const String kTitle = 'Rádio Oasis';
const String kArtist = 'Oasis de Bendición';
const String kArtUri = 'https://sua-imagem.com/logo.png';

/// Handles audio playback and integrates with audio_service for system controls.
class RadioAudioHandler extends BaseAudioHandler with SeekHandler {
  final AudioPlayer _player;

  /// Creates a [RadioAudioHandler] with the given [AudioPlayer].
  RadioAudioHandler(this._player) {
    _notifyAudioHandlerAboutPlaybackEvents();
    _listenForPlayerStateChanges();
    _setInitialMediaItem();
  }

  // Updates playback state for audio_service notifications.
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

  // Stops playback when the audio completes.
  void _listenForPlayerStateChanges() {
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        stop();
      }
    });
  }

  // Sets the initial media item for notifications.
  void _setInitialMediaItem() {
    mediaItem.add(MediaItem(
      id: kStreamUrl,
      album: kAlbumName,
      title: kTitle,
      artist: kArtist,
      artUri: Uri.parse(kArtUri),
    ));
  }

  /// Starts audio playback.
  /// 
  /// Throws a [RadioAudioException] if an error occurs during the process.
  @override
  Future<void> play() async {
    try {
      await _player.play();
    } catch (e, stackTrace) {
      throw RadioAudioException(
        'Failed to start playback',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Pauses audio playback.
  /// 
  /// Throws a [RadioAudioException] if an error occurs during the process.
  @override
  Future<void> pause() async {
    try {
      await _player.pause();
    } catch (e, stackTrace) {
      throw RadioAudioException(
        'Failed to pause playback',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Stops audio playback.
  /// 
  /// Throws a [RadioAudioException] if an error occurs during the process.
  @override
  Future<void> stop() async {
    try {
      await _player.stop();
    } catch (e, stackTrace) {
      throw RadioAudioException(
        'Failed to stop playback',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}