import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// ===============================================
/// CONFIGURAÇÕES DO YOUTUBE
/// ===============================================
const String kYoutubeApiKey = 'AIzaSyBKJ3PwmupeEx4z0pMYidx7_yG9GfxzK84';
const String kChannelId = 'UC4nJ_qBjgm3p1r27pYI3F_g';

/// ===============================================
/// ESTILO VISUAL
/// ===============================================
const Color kButtonColor = Colors.red;
const double kScreenPadding = 20.0;

/// ===============================================
/// HORARIOS DE TRANSMISIÓN
/// ===============================================
class TransmissionSchedule {
  static const sundayHour = 12;
  static const sundayMinute = 0;
  static const tuesdayHour = 20;
  static const tuesdayMinute = 0;
}

class YoutubeService {
  Future<String?> fetchLiveVideoId() async {
    final url = Uri.parse(
      'https://www.googleapis.com/youtube/v3/search'
      '?part=snippet'
      '&channelId=$kChannelId'
      '&eventType=live'
      '&type=video'
      '&key=$kYoutubeApiKey',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final items = data['items'] as List?;
      if (items != null && items.isNotEmpty) {
        return items.first['id']['videoId'] as String;
      }
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> fetchRecentVideos() async {
    final url = Uri.parse(
      'https://www.googleapis.com/youtube/v3/search'
      '?part=snippet'
      '&channelId=$kChannelId'
      '&order=date'
      '&maxResults=6'
      '&type=video'
      '&key=$kYoutubeApiKey',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final items = data['items'] as List;
      return items.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception('Erro ao carregar vídeos: ${response.body}');
    }
  }
}

class CultTransmissionsScreen extends StatefulWidget {
  const CultTransmissionsScreen({super.key});

  @override
  State<CultTransmissionsScreen> createState() => _CultTransmissionsScreenState();
}

class _CultTransmissionsScreenState extends State<CultTransmissionsScreen> {
  final YoutubeService _youtubeService = YoutubeService();
  YoutubePlayerController? _controller;
  bool _loadingLive = true;
  bool _loadingVideos = true;
  List<Map<String, dynamic>> _recentVideos = [];
  String _currentTitle = "Culto ao Vivo";

  String _getNextTransmissionTime() {
    final now = DateTime.now();
    late DateTime nextTuesday;
    late DateTime nextSunday;

    // Encontrar el próximo martes
    nextTuesday = now;
    while (nextTuesday.weekday != DateTime.tuesday) {
      nextTuesday = nextTuesday.add(const Duration(days: 1));
    }
    nextTuesday = DateTime(
      nextTuesday.year,
      nextTuesday.month,
      nextTuesday.day,
      TransmissionSchedule.tuesdayHour,
      TransmissionSchedule.tuesdayMinute,
    );

    // Encontrar el próximo domingo
    nextSunday = now;
    while (nextSunday.weekday != DateTime.sunday) {
      nextSunday = nextSunday.add(const Duration(days: 1));
    }
    nextSunday = DateTime(
      nextSunday.year,
      nextSunday.month,
      nextSunday.day,
      TransmissionSchedule.sundayHour,
      TransmissionSchedule.sundayMinute,
    );

    // Si ya pasó la hora del día actual, añadir una semana
    if (nextTuesday.isBefore(now)) {
      nextTuesday = nextTuesday.add(const Duration(days: 7));
    }
    if (nextSunday.isBefore(now)) {
      nextSunday = nextSunday.add(const Duration(days: 7));
    }

    // Determinar cuál es la próxima transmisión
    final nextTransmission = nextTuesday.isBefore(nextSunday) ? nextTuesday : nextSunday;
    
    // Formatear el mensaje
    final isNextTuesday = nextTransmission.weekday == DateTime.tuesday;
    return isNextTuesday ? "Terça, 20:00h" : "Domingo, 12:00h";
  }

  @override
  void initState() {
    super.initState();
    _loadLiveAndVideos();
  }

  Future<void> _loadLiveAndVideos() async {
    try {
      final liveId = await _youtubeService.fetchLiveVideoId();
      final videos = await _youtubeService.fetchRecentVideos();

      if (mounted) {
        setState(() {
          if (liveId != null) {
            _currentTitle = "Culto ao Vivo";
            _controller = YoutubePlayerController(
              initialVideoId: liveId,
              flags: const YoutubePlayerFlags(
                autoPlay: true,
                enableCaption: false,
              ),
            );
          }
          _recentVideos = videos;
          _loadingLive = false;
          _loadingVideos = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loadingLive = false;
          _loadingVideos = false;
        });
      }
    }
  }

  void _playVideo(String videoId, String title) {
    setState(() {
      _currentTitle = title;
      if (_controller != null) {
        _controller!.load(videoId);
      } else {
        _controller = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: true,
            enableCaption: false,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  // Removed unused widget

  Widget _buildContent(BuildContext context, double screenWidth, Widget? player) {
    return Stack(
      children: [
        // Background image
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/back.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        
        // Contenido principal
        Positioned(
          top: MediaQuery.of(context).size.height * 0.03,
          left: MediaQuery.of(context).size.width * 0.04,
          right: MediaQuery.of(context).size.width * 0.04,
          bottom: 0,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  clipBehavior: Clip.antiAlias,
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: _loadingLive
                        ? const Center(
                            child: CircularProgressIndicator(color: kButtonColor),
                          )
                        : player ??
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.live_tv_outlined,
                                    size: 45,
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No hay transmisión en directo en este momento.',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      height: 1.3,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: kButtonColor,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.schedule,
                                          color: kButtonColor,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Próximo culto: ${_getNextTransmissionTime()}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(kScreenPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text(
                          "Últimos Cultos Gravados",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      if (_loadingVideos)
                        const Center(
                          child: CircularProgressIndicator(color: kButtonColor),
                        )
                      else
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          childAspectRatio: 1.3,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          children: _recentVideos.map((video) {
                            final thumb = video['snippet']['thumbnails']['medium']['url'];
                            final videoId = video['id']['videoId'];
                            final title = video['snippet']['title'] as String;
                            return Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () => _playVideo(videoId, title),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Image.network(
                                            thumb,
                                            width: double.infinity,
                                            height: 90,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned.fill(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Colors.transparent,
                                                  Colors.black.withOpacity(0.7),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 8,
                                          bottom: 8,
                                          child: Icon(
                                            Icons.play_circle_filled,
                                            color: Colors.white.withOpacity(0.9),
                                            size: 24,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (_controller == null) {
      return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text(
            _currentTitle,
            style: const TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          backgroundColor: Colors.black,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: _buildContent(context, screenWidth, null),
      );
    }

    return YoutubePlayerBuilder(
      onEnterFullScreen: () {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      },
      onExitFullScreen: () {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      },
      player: YoutubePlayer(
        controller: _controller!,
        showVideoProgressIndicator: true,
        progressIndicatorColor: kButtonColor,
        progressColors: const ProgressBarColors(
          playedColor: kButtonColor,
          handleColor: kButtonColor,
        ),
      ),
      builder: (context, player) {
        return Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            title: Text(
              _currentTitle,
              style: const TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            backgroundColor: Colors.black,
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: _buildContent(context, screenWidth, player),
        );
      },
    );
  }
}