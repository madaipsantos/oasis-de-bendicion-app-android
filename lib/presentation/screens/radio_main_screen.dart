import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:webradiooasis/config/router/app_router.dart';
import 'package:webradiooasis/core/utils/our_social_contacts.dart';
import 'package:webradiooasis/core/utils/battery_utils.dart';
import 'package:webradiooasis/infrastructure/services/connection_service.dart';
import '../providers/audio_player_provider.dart';

/// Constants
const String kRadioBackgroundImage = 'assets/back.jpg';
const String kRadioLogoImage = 'assets/photoOasisRadio.jpg';
const String kRadioProgramsImage = 'assets/radiales.jpg';
const Color kCardColor = Color.fromARGB(255, 141, 59, 59);
const int kRadioTabIndex = 1;

/// Main screen for the radio section.
/// Allows listening to the radio, accessing programs, social networks, and switching to the church area.
/// Manages connection, player, error overlays, and battery optimization.
class RadioMainScreen extends StatefulWidget {
  const RadioMainScreen({super.key});

  @override
  State<RadioMainScreen> createState() => _RadioMainScreenState();
}

class _RadioMainScreenState extends State<RadioMainScreen> {
  final int _selectedIndex = kRadioTabIndex;
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

  /// Checks internet connection and prepares the player if necessary.
  Future<void> _checkConnection() async {
    setState(() {
      _checkingConnection = true;
    });
    final service = ConnectionService();
    bool result = false;
    try {
      result = await service.hasConnection();
      setState(() {
        _hasConnection = result;
        _checkingConnection = false;
      });
    } catch (e) {
      // Se ocorrer uma exceção, consideramos que não há conexão
      setState(() {
        _hasConnection = false;
        _checkingConnection = false;
      });
    }
    final audioPlayerProvider = Provider.of<AudioPlayerProvider>(
      // ignore: use_build_context_synchronously
      context,
      listen: false,
    );
    if (_hasConnection) {
      if (!audioPlayerProvider.initialized && !audioPlayerProvider.isPlaying) {
        await audioPlayerProvider.preparePlayer();
      }
    } else {
      if (audioPlayerProvider.isPlaying) {
        await audioPlayerProvider.stopCompletely();
      }
    }
  }

  /// Starts periodic monitoring of the internet connection.
  void _startConnectionMonitor() {
    _connectionMonitorTimer?.cancel();
    _connectionMonitorTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      final service = ConnectionService();
      bool result = false;
      try {
        result = await service.hasConnection();
      } catch (e) {
        result = false;
      }
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
        setState(() {
          _hasConnection = true;
        });
      }
    });
  }

  /// Handles bottom navigation bar taps.
  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRouter.home);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, AppRouter.radio);
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
                image: AssetImage(kRadioBackgroundImage),
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
                            _RadioSectionCard(
                              imagePath: kRadioProgramsImage,
                              buttonLabel: "Programas Radiales",
                              onTap: () {
                                Navigator.pushNamed(context, AppRouter.radioPrograms);
                              },
                              cardHeight: cardHeight,
                              buttonWidth: buttonWidth,
                              buttonTop: buttonTop,
                              buttonRight: buttonRight,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.insert_drive_file_rounded,
                                    color: Color.fromARGB(255, 231, 228, 228),
                                    size: 30,
                                  ),
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
                                  child: Image.asset(kRadioLogoImage),
                                ),
                              ),
                            ),
                            const SizedBox(height: 25),
                            _buildPlayerControls(audioPlayerProvider),
                            const SizedBox(height: 20),
                            _buildSocialButtons(),
                            const Expanded(child: SizedBox()),
                            const SizedBox(height: 20),
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

  /// Builds the custom AppBar for the radio screen.
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

  /// Builds the bottom navigation bar for switching between Church and Radio.
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

  /// Builds the audio player controls (play/pause and track title).
  Widget _buildPlayerControls(AudioPlayerProvider audioPlayerProvider) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            boxShadow: [BoxShadow(spreadRadius: 0, blurRadius: 2)],
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: _hasConnection
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

  /// Builds the row of social and phone buttons.
  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSocialButton(
          icon: MdiIcons.whatsapp,
          color: Colors.green,
          onPressed: () async {
            const String phone = '+34614126301';
            const String message = "Bendiciones...";
            await OurSocialContacts.openLink(
              context,
              'whatsapp://send?phone=$phone&text=${Uri.encodeComponent(message)}',
              'https://wa.me/$phone?text=${Uri.encodeComponent(message)}',
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

  /// Builds an individual social button.
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

  /// Shows an alert dialog if phone permission is denied.
  void _showPhonePermissionError() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
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

  /// Overlay shown when there is no internet connection.
  Widget _buildConnectionErrorOverlay() {
    return Container(
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
                    'Tentar Novamente',
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

  /// Overlay shown when there is a streaming error.
  Widget _buildStreamingErrorOverlay() {
    return Container(
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
              children: const [
                Text(
                  'O servidor de rádio não está disponível no momento.\nPor favor, tente novamente mais tarde.',
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
    );
  }

  /// Overlay shown while the player is loading.
  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black45,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Carregando rádio...', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

/// Private widget for the radio section card.
class _RadioSectionCard extends StatelessWidget {
  final String imagePath;
  final String buttonLabel;
  final VoidCallback onTap;
  final double cardHeight;
  final double buttonWidth;
  final double buttonTop;
  final double buttonRight;

  const _RadioSectionCard({
    required this.imagePath,
    required this.buttonLabel,
    required this.onTap,
    required this.cardHeight,
    required this.buttonWidth,
    required this.buttonTop,
    required this.buttonRight,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kCardColor,
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
                    minimumSize: const Size(40, 30),
                  ),
                  child: Text(
                    buttonLabel,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
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