import 'package:flutter/material.dart';
import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:webradiooasis/services/connection_service.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webradiooasis/Pages/church_main_screen.dart';
import 'package:webradiooasis/Pages/radio_programs%20_screen.dart';
import 'package:webradiooasis/utils/battery_utils.dart';
import 'package:webradiooasis/utils/our_social_contacts.dart';
import '../services/audio_player_provider.dart';

class RadioMainScreen extends StatefulWidget {
  const RadioMainScreen({super.key});

  @override
  State<RadioMainScreen> createState() => _RadioMainScreenState();
}

class _RadioMainScreenState extends State<RadioMainScreen> {
  int _selectedIndex = 1;
  bool _hasConnection = true;
  bool _checkingConnection = true;
  Timer? _connectionMonitorTimer;

  @override
  void initState() {
    super.initState();
    final audioPlayerProvider = Provider.of<AudioPlayerProvider>(
      context,
      listen: false,
    );
    audioPlayerProvider
        .initAudioService(); // Inicializa AudioService apenas uma vez
    _checkConnection();
    _startConnectionMonitor();
  }

  Future<void> _checkConnection() async {
    setState(() {
      _checkingConnection = true;
    });
    final service = ConnectionService();
    final result = await service.hasConnection();
    setState(() {
      _hasConnection = result;
      _checkingConnection = false;
    });
    if (result) {
      final audioPlayerProvider = Provider.of<AudioPlayerProvider>(
        context,
        listen: false,
      );
      // Só prepara o player se não estiver inicializado e não estiver tocando
      if (!audioPlayerProvider.initialized && !audioPlayerProvider.isPlaying) {
        await audioPlayerProvider.preparePlayer();
      }
    }
    // Se perdeu conexão durante streaming, pausa o player
    if (!result) {
      final audioPlayerProvider = Provider.of<AudioPlayerProvider>(
        context,
        listen: false,
      );
      if (audioPlayerProvider.isPlaying) {
        await audioPlayerProvider.stopCompletely();
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ChurchMainScreen()),
        );
        break;
      case 1:
        // Não navega se já está na tela atual
        if (_selectedIndex != 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => RadioMainScreen()),
          );
        }
        break;
    }
  }

  @override
  void dispose() {
    _connectionMonitorTimer?.cancel();
    super.dispose();
  }

  void _startConnectionMonitor() {
    _connectionMonitorTimer?.cancel();
    _connectionMonitorTimer = Timer.periodic(Duration(seconds: 5), (
      timer,
    ) async {
      final service = ConnectionService();
      final result = await service.hasConnection();
      if (!result && _hasConnection) {
        // Perdeu conexão
        setState(() {
          _hasConnection = false;
        });
        final audioPlayerProvider = Provider.of<AudioPlayerProvider>(
          context,
          listen: false,
        );
        if (audioPlayerProvider.isPlaying) {
          await audioPlayerProvider.stopCompletely();
        }
      } else if (result && !_hasConnection) {
        // Reconectou
        setState(() {
          _hasConnection = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final audioPlayerProvider = Provider.of<AudioPlayerProvider>(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double cardHeight = screenHeight * 0.15;
    final double buttonWidth = screenWidth * 0.54;
    final double buttonTop = 0.0;
    final double buttonRight = 8.0;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          "Oasis Radio",
          style: TextStyle(fontSize: 27.0, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/back.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04,
                          vertical: screenHeight * 0.02,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildCard(
                              context: context,
                              imagePath: 'assets/radiales.jpg',
                              buttonLabel: "Programas Radiales",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RadioProgramsScreen(),
                                  ),
                                );
                              },
                              cardHeight: cardHeight,
                              buttonWidth: buttonWidth,
                              buttonTop: buttonTop,
                              buttonRight: buttonRight,
                            ),
                            SizedBox(height: 10),
                            // Ícone de bateria para otimização
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.insert_drive_file_rounded, color: const Color.fromARGB(255, 231, 228, 228), size: 30),
                                  splashColor: Colors.red,
                                  highlightColor: Colors.redAccent,
                                  onPressed: () async {
                                    await BatteryUtils.handleBatteryOptimization(context);
                                  },
                                ),
                              ],
                            ),
                            Center(
                              child: SizedBox(
                                width: 220,
                                height: 220,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(400),
                                  child: Image.asset(
                                    'assets/photoOasisRadio.jpg',
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 25),
                            Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(spreadRadius: 0, blurRadius: 2),
                                ],
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                onPressed:
                                    _hasConnection
                                        ? () async {
                                          audioPlayerProvider.togglePlayPause();
                                        }
                                        : null,
                                icon: Icon(
                                  audioPlayerProvider.isPlaying
                                      ? MdiIcons.pause
                                      : MdiIcons.play,
                                ),
                                iconSize: 45,
                              ),
                            ),
                            SizedBox(height: 10),
                            const Text(
                              'Reproduciendo:',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            StreamBuilder<IcyMetadata?>(
                              stream:
                                  audioPlayerProvider.player.icyMetadataStream,
                              builder: (context, snapshot) {
                                final title = audioPlayerProvider.currentTitle;
                                return Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 10.0,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      title,
                                      style: const TextStyle(fontSize: 14.0),
                                      softWrap: true,
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    final String telefone = '+34614126301';
                                    final String message = "Bendiciones...";
                                    await OurSocialContacts.openLink(
                                      context,
                                      'whatsapp://send?phone=$telefone&text=${Uri.encodeComponent(message)}',
                                      'https://wa.me/$telefone?text=${Uri.encodeComponent(message)}',
                                      'WhatsApp',
                                    );
                                  },
                                  icon: Icon(MdiIcons.whatsapp),
                                  iconSize: 40,
                                  color: Colors.green,
                                ),
                                IconButton(
                                  onPressed: () async {
                                    await OurSocialContacts.openLink(
                                      context,
                                      'instagram://user?username=oasis_radio_gijon',
                                      'https://www.instagram.com/oasis_radio_gijon/',
                                      'Instagram',
                                    );
                                  },
                                  icon: Icon(MdiIcons.instagram),
                                  iconSize: 40,
                                  color: Colors.pink,
                                ),
                                IconButton(
                                  onPressed: () async {
                                    await OurSocialContacts.openLink(
                                      context,
                                      'fb://profile/61559201453991',
                                      'https://www.facebook.com/profile.php?id=61559201453991',
                                      'Facebook',
                                    );
                                  },
                                  icon: Icon(MdiIcons.facebook),
                                  iconSize: 40,
                                  color: Colors.blue,
                                ),
                                IconButton(
                                  onPressed: () async {
                                    const phoneUrl = 'tel:+34614126301';
                                    if (await OurSocialContacts.requestPhonePermission()) {
                                      await launchUrl(Uri.parse(phoneUrl));
                                    } else {
                                      if (context.mounted) {
                                        showDialog(
                                          context: context,
                                          builder:
                                              (context) => AlertDialog(
                                                title: const Text('Erro'),
                                                content: const Text(
                                                  'Permissão para ligação não concedida.',
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed:
                                                        () =>
                                                            Navigator.of(
                                                              context,
                                                            ).pop(),
                                                    child: const Text('OK'),
                                                  ),
                                                ],
                                              ),
                                        );
                                      }
                                    }
                                  },
                                  icon: Icon(MdiIcons.phone),
                                  iconSize: 40,
                                ),
                              ],
                            ),
                            Expanded(child: Container()),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Overlay de conexão
          if (!_hasConnection && !_checkingConnection)
            Container(
              color: Colors.black.withOpacity(0.7),
              child: Center(
                child: Card(
                  color: Colors.grey[900]?.withOpacity(0.85),
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 18.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'No tienes conexión a internet. Comprueba tu red y vuelve a intentarlo.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 18),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                              0xFFEF5350,
                            ), // vermelho suave
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 22,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11),
                            ),
                            elevation: 3,
                          ),
                          onPressed: _checkConnection,
                          child: const Text(
                            'Intentar de novo',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          // Overlay de streaming indisponível (só se erro real)
          if (_hasConnection &&
              !_checkingConnection &&
              audioPlayerProvider.streamingError)
            Container(
              color: Colors.black.withOpacity(0.7),
              child: Center(
                child: Card(
                  color: Colors.grey[900]?.withOpacity(0.85),
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 18.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'El servidor de la radio no está disponible en este momento.\nInténtalo de nuevo más tarde',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 18),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          // Mostra loading sempre que isLoading for true
          if (audioPlayerProvider.isLoading)
            Container(
              color: Colors.black45,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Cargando rádio...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.white,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.church), label: "Iglesia"),
          BottomNavigationBarItem(icon: Icon(Icons.radio), label: "Radio"),
        ],
      ),
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required String imagePath,
    required String buttonLabel,
    required VoidCallback onTap,
    required double cardHeight,
    required double buttonWidth,
    required double buttonTop,
    required double buttonRight,
  }) {
    return Card(
      color: const Color.fromARGB(255, 141, 59, 59),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: double.infinity,
        height: cardHeight,
        padding: const EdgeInsets.all(4.0),
        child: Stack(
          children: [
            GestureDetector(
              onTap: onTap,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.transparent.withOpacity(0.1),
                  colorBlendMode: BlendMode.darken,
                ),
              ),
            ),
            Positioned(
              top: buttonTop,
              right: buttonRight,
              child: SizedBox(
                width: buttonWidth,
                child: ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    minimumSize: Size(40, 30),
                  ),
                  child: Text(
                    buttonLabel,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
