import 'package:flutter/material.dart';
import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webradiooasis/config/router/app_router.dart';
import 'package:webradiooasis/core/utils/our_social_contacts.dart';
import 'package:webradiooasis/infrastructure/services/connection_service.dart';
import 'package:webradiooasis/core/utils/battery_utils.dart';
import '../providers/audio_player_provider.dart';

/// Tela principal da rádio.
/// Permite ouvir a rádio, acessar programas, redes sociais e alternar para a área da igreja.
/// Gerencia conexão, player, overlays de erro e otimização de bateria.
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
    audioPlayerProvider.initAudioService();
    _checkConnection();
    _startConnectionMonitor();
  }

  /// Checa conexão com a internet e prepara o player se necessário.
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
        // ignore: use_build_context_synchronously
        context,
        listen: false,
      );
      if (!audioPlayerProvider.initialized && !audioPlayerProvider.isPlaying) {
        await audioPlayerProvider.preparePlayer();
      }
    }
    if (!result) {
      final audioPlayerProvider = Provider.of<AudioPlayerProvider>(
        // ignore: use_build_context_synchronously
        context,
        listen: false,
      );
      if (audioPlayerProvider.isPlaying) {
        await audioPlayerProvider.stopCompletely();
      }
    }
  }

  /// Inicia monitoramento periódico da conexão.
  void _startConnectionMonitor() {
    _connectionMonitorTimer?.cancel();
    _connectionMonitorTimer = Timer.periodic(Duration(seconds: 5), (
      timer,
    ) async {
      final service = ConnectionService();
      final result = await service.hasConnection();
      if (!result && _hasConnection) {
        setState(() {
          _hasConnection = false;
        });
        final audioPlayerProvider = Provider.of<AudioPlayerProvider>(
          // ignore: use_build_context_synchronously
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

  /// Alterna entre as abas de Igreja e Rádio.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRouter.home);
        break;
      case 1:
        if (_selectedIndex != 1) {
          Navigator.pushReplacementNamed(context, AppRouter.radio);
        }
        break;
    }
  }

  @override
  void dispose() {
    _connectionMonitorTimer?.cancel();
    super.dispose();
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
      appBar: _buildAppBar(),
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
                                Navigator.pushNamed(context, AppRouter.radioPrograms);
                              },
                              cardHeight: cardHeight,
                              buttonWidth: buttonWidth,
                              buttonTop: buttonTop,
                              buttonRight: buttonRight,
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.insert_drive_file_rounded,
                                    color: const Color.fromARGB(
                                      255,
                                      231,
                                      228,
                                      228,
                                    ),
                                    size: 30,
                                  ),
                                  splashColor: Colors.red,
                                  highlightColor: Colors.redAccent,
                                  onPressed: () async {
                                    await BatteryUtils.handleBatteryOptimization(
                                      context,
                                    );
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
                            _buildPlayerControls(audioPlayerProvider),
                            SizedBox(height: 20),
                            _buildSocialButtons(),
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
          if (!_hasConnection && !_checkingConnection)
            _buildConnectionErrorOverlay(),
          if (_hasConnection &&
              !_checkingConnection &&
              audioPlayerProvider.streamingError)
            _buildStreamingErrorOverlay(),
          if (audioPlayerProvider.isLoading) _buildLoadingOverlay(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  /// AppBar personalizada para a rádio.
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        "Oasis Radio",
        style: TextStyle(fontSize: 27.0, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.black,
      elevation: 0,
      centerTitle: true,
    );
  }

  /// Barra de navegação inferior para alternar entre Igreja e Rádio.
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.red,
      unselectedItemColor: Colors.white,
      onTap: _onItemTapped,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.church), label: "Iglesia"),
        BottomNavigationBarItem(icon: Icon(Icons.radio), label: "Radio"),
      ],
    );
  }

  /// Controles do player de áudio (play/pause e título da faixa).
  Widget _buildPlayerControls(AudioPlayerProvider audioPlayerProvider) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            boxShadow: [BoxShadow(spreadRadius: 0, blurRadius: 2)],
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed:
                _hasConnection
                    ? () => audioPlayerProvider.togglePlayPause()
                    : null,
            icon: Icon(
              audioPlayerProvider.isPlaying ? MdiIcons.pause : MdiIcons.play,
            ),
            iconSize: 45,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Reproduciendo:',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        StreamBuilder<IcyMetadata?>(
          stream: audioPlayerProvider.player.icyMetadataStream,
          builder: (context, snapshot) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.black, width: 2.0),
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
                  audioPlayerProvider.currentTitle,
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
      ],
    );
  }

  /// Botões para redes sociais e telefone.
  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSocialButton(
          icon: MdiIcons.whatsapp,
          color: Colors.green,
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
        ),
        _buildSocialButton(
          icon: MdiIcons.instagram,
          color: Colors.pink,
          onPressed: () async {
            await OurSocialContacts.openLink(
              context,
              'instagram://user?username=oasis_radio_gijon',
              'https://www.instagram.com/oasis_radio_gijon/',
              'Instagram',
            );
          },
        ),
        _buildSocialButton(
          icon: MdiIcons.facebook,
          color: Colors.blue,
          onPressed: () async {
            await OurSocialContacts.openLink(
              context,
              'fb://profile/61559201453991',
              'https://www.facebook.com/profile.php?id=61559201453991',
              'Facebook',
            );
          },
        ),
        _buildSocialButton(
          icon: MdiIcons.phone,
          color: Colors.white,
          onPressed: () async {
            const phoneUrl = 'tel:+34614126301';
            if (await OurSocialContacts.requestPhonePermission()) {
              await launchUrl(Uri.parse(phoneUrl));
            } else {
              if (context.mounted) {
                _showPhonePermissionError();
              }
            }
          },
        ),
      ],
    );
  }

  /// Botão individual de rede social.
  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      iconSize: 40,
      color: color,
    );
  }

  /// Mostra alerta de erro de permissão de telefone.
  void _showPhonePermissionError() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Erro'),
            content: const Text('Permissão para ligação não concedida.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  /// Overlay exibido quando não há conexão com a internet.
  Widget _buildConnectionErrorOverlay() {
    return Container(
      // ignore: deprecated_member_use
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Card(
          // ignore: deprecated_member_use
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
                const Text(
                  'No tienes conexión a internet. Comprueba tu red y vuelve a intentarlo.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF5350),
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
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Overlay exibido quando há erro no streaming da rádio.
  Widget _buildStreamingErrorOverlay() {
    return Container(
      // ignore: deprecated_member_use
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Card(
          // ignore: deprecated_member_use
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
                const Text(
                  'El servidor de la radio no está disponible en este momento.\nInténtalo de nuevo más tarde',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Overlay exibido durante o carregamento do player.
  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black45,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Cargando rádio...', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  /// Card para acessar programas radiais.
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
                  // ignore: deprecated_member_use
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