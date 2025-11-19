import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:disable_battery_optimizations_latest/disable_battery_optimizations_latest.dart';
import 'package:webradiooasis/config/router/app_router.dart';
import 'package:webradiooasis/core/utils/battery_utils.dart';
import 'package:webradiooasis/infrastructure/services/connection_service.dart';
import '../providers/audio_player_provider.dart';

const String kRadioBackgroundImage = 'assets/back.jpg';
const String kRadioLogoImage = 'assets/photoOasisRadio.jpg';
const String kRadioProgramsImage = 'assets/radiales.jpg';
const Color kCardColor = Color.fromARGB(255, 141, 59, 59);
const int kRadioTabIndex = 1;

// Constantes copiadas de church_main_screen para mantener consistencia de estilo
const double kCardRadius = 15.0;
const double kCardBorder = 4.0;
const double kTextFontSize = 17.0;
const Color kBorderColor = Color.fromARGB(255, 141, 59, 59);
const Color kButtonColor = Colors.red;
const double kScreenPadding = 20.0;

/// Representa una ação principal na tela de radio.
class RadioAction {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  RadioAction({required this.title, required this.icon, required this.onTap});
}

class RadioMainScreen extends StatefulWidget {
  const RadioMainScreen({super.key});

  @override
  State<RadioMainScreen> createState() => _RadioMainScreenState();
}

class _RadioMainScreenState extends State<RadioMainScreen> 
    with SingleTickerProviderStateMixin {
  final int _selectedIndex = kRadioTabIndex;
  bool _hasConnection = true;
  bool _checkingConnection = true;
  Timer? _connectionMonitorTimer;
  late List<RadioAction> _radioActions;
  
  // Variables para la animación de pulso
  late AnimationController _pulseAnimationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    // Inicializar controlador de animación de pulso
    _pulseAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseAnimationController,
      curve: Curves.easeInOut,
    ));
    
    final audioPlayerProvider = Provider.of<AudioPlayerProvider>(context, listen: false);
    audioPlayerProvider.initAudioService();
    _initializeRadioActions();
    _checkConnection();
    _startConnectionMonitor();
  }

  /// Inicializa as ações específicas para a tela de rádio.
  void _initializeRadioActions() {
    _radioActions = [
      RadioAction(
        title: "Programas Radiales",
        icon: Icons.calendar_month,
        onTap: () {
          Navigator.pushNamed(context, AppRouter.radioPrograms);
        },
      ),
      RadioAction(
        title: "Contactos/Redes sociales",
        icon: Icons.phone,
        onTap: () {
          Navigator.pushNamed(context, AppRouter.contactsRadio);
        },
      ),
    ];
  }

  Future<void> _checkConnection() async {
    setState(() => _checkingConnection = true);
    final service = ConnectionService();
    bool result = false;
    try {
      result = await service.hasConnection();
      setState(() {
        _hasConnection = result;
        _checkingConnection = false;
      });
    } catch (_) {
      setState(() {
        _hasConnection = false;
        _checkingConnection = false;
      });
    }

    final audioPlayerProvider = Provider.of<AudioPlayerProvider>(context, listen: false);
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

  void _startConnectionMonitor() {
    _connectionMonitorTimer?.cancel();
    _connectionMonitorTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      final service = ConnectionService();
      bool result = false;
      try {
        result = await service.hasConnection();
      } catch (_) {
        result = false;
      }
      if (!result && _hasConnection) {
        setState(() => _hasConnection = false);
        final audioPlayerProvider = Provider.of<AudioPlayerProvider>(context, listen: false);
        if (audioPlayerProvider.isPlaying) {
          await audioPlayerProvider.stopCompletely();
        }
      } else if (result && !_hasConnection) {
        setState(() => _hasConnection = true);
      }
    });
  }

  /// Verifica y maneja la optimización de batería
  Future<void> _checkBatteryOptimization() async {
    try {
      await BatteryUtils.handleBatteryOptimization(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.warning, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text('Error al verificar configuración de batería'),
                ),
              ],
            ),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

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

  /// Constrói um único item de ação (botão do card).
  Widget _buildRadioActionButton(RadioAction action, double screenWidth) {
    final double iconSize = screenWidth * 0.08;
    final double adjustedFontSize = kTextFontSize * 0.85;

    return InkWell(
      onTap: action.onTap,
      borderRadius: BorderRadius.circular(kCardRadius),
      child: Container(
        padding: const EdgeInsets.all(kCardBorder * 0.7),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.black.withOpacity(0.7),
              Colors.black.withOpacity(0.5),
            ],
          ),
          borderRadius: BorderRadius.circular(kCardRadius),
          border: Border.all(color: kBorderColor.withOpacity(0.5), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
          backgroundBlendMode: BlendMode.overlay,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(action.icon, size: iconSize, color: kButtonColor),
            const SizedBox(height: 8),
            Text(
              action.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: adjustedFontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Constrói a grade de cards de ação para radio usando o mesmo estilo de church_main.
  Widget _buildRadioActionCards(double screenWidth) {
    // Usar a mesma lógica responsiva da tela church
    int crossAxisCount = 2; // Sempre 2 colunas para os 2 cards de radio
    double spacing = kScreenPadding / 2; // Mesmo spacing que church_main
    double aspectRatio = MediaQuery.of(context).size.aspectRatio;
    // Mesma lógica de aspect ratio que church_main
    double childAspectRatio = aspectRatio < 1.0 ? 1.8 : 2.2;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: spacing,
      mainAxisSpacing: spacing,
      childAspectRatio: childAspectRatio,
      children: _radioActions.map((action) => _buildRadioActionButton(action, screenWidth)).toList(),
    );
  }

  @override
  void dispose() {
    _connectionMonitorTimer?.cancel();
    _pulseAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audioPlayerProvider = Provider.of<AudioPlayerProvider>(context);
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
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
          ),
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: 25),
            child: Column(
              children: [
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.redAccent, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.redAccent.withOpacity(0.6),
                          blurRadius: 30,
                          spreadRadius: 6,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(120),
                      child: Image.asset(kRadioLogoImage, width: 220, height: 220, fit: BoxFit.cover),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                _buildPlayerControls(audioPlayerProvider),
                const SizedBox(height: 30),
              ],
            ),
          ),
          if (!_hasConnection && !_checkingConnection) _buildConnectionErrorOverlay(),
          if (_hasConnection && !_checkingConnection && audioPlayerProvider.streamingError)
            _buildStreamingErrorOverlay(),
          if (audioPlayerProvider.isLoading) _buildLoadingOverlay(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() => AppBar(
        title: const Text(
          "Oasis Radio",
          style: TextStyle(fontSize: 27.0, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        elevation: 4,
        centerTitle: true,
        actions: [
          // Indicador visual del estado de optimización de batería
          FutureBuilder<bool?>(
            future: DisableBatteryOptimizationLatest.isBatteryOptimizationDisabled,
            builder: (context, snapshot) {
              // Solo muestra el ícono si la optimización NO está deshabilitada
              if (snapshot.hasData && snapshot.data == false) {
                return Container(
                  margin: EdgeInsets.only(right: 8),
                  child: IconButton(
                    onPressed: () => _checkBatteryOptimization(),
                    icon: Stack(
                      children: [
                        Icon(
                          Icons.battery_alert,
                          color: Colors.orange,
                          size: 28,
                        ),
                        // Pequeño punto pulsante para llamar más la atención
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    tooltip: 'Optimizar batería para mejor rendimiento',
                    splashRadius: 24,
                  ),
                );
              }
              // Si ya está configurado o estamos cargando, no mostrar nada
              return SizedBox.shrink();
            },
          ),
        ],
      );

  Widget _buildBottomNavigationBar() => BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.black,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.church), label: "Iglesia"),
          BottomNavigationBarItem(icon: Icon(Icons.radio), label: "Radio"),
        ],
      );

  Widget _buildPlayerControls(AudioPlayerProvider provider) => Column(
        children: [
          // Botón con animación de pulso suave y brillo
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              // Controlar la animación basado en el estado de reproducción
              if (provider.isPlaying && !_pulseAnimationController.isAnimating) {
                _pulseAnimationController.repeat(reverse: true);
              } else if (!provider.isPlaying && _pulseAnimationController.isAnimating) {
                _pulseAnimationController.stop();
                _pulseAnimationController.reset();
              }

              return Transform.scale(
                scale: provider.isPlaying ? _pulseAnimation.value : 1.0,
                child: IconButton(
                  onPressed: _hasConnection ? () => provider.togglePlayPause() : null,
                  icon: Icon(provider.isPlaying ? MdiIcons.pause : MdiIcons.play),
                  iconSize: 60,
                  // Cambio de color animado usando los colores de la app
                  color: provider.isPlaying 
                    ? Color.lerp(
                        Colors.redAccent,              // Color principal de la app
                        const Color.fromARGB(255, 239, 139, 139), // kBorderColor de la app
                        _pulseAnimation.value,
                      )
                    : Colors.redAccent, // Color normal cuando está parado
                ),
              );
            },
          ),
          const SizedBox(height: 5),
          const Text(
            'Reproduciendo:',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          StreamBuilder<IcyMetadata?>(
            stream: provider.player.icyMetadataStream,
            builder: (context, snapshot) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.black.withOpacity(0.10),
                      Colors.black.withOpacity(0.10),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(kCardRadius),
                  border: Border.all(color: kBorderColor.withOpacity(0.5), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(2, 4),
                    ),
                  ],
                  backgroundBlendMode: BlendMode.overlay,
                ),
                child: Text(
                  provider.currentTitle,
                  style: const TextStyle(fontSize: 14.0, color: Colors.white),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          _buildDecorativeDivider(),
          const SizedBox(height: 10),
          _buildRadioActionCards(MediaQuery.of(context).size.width),
        ],
      );

  /// Constrói o divisor decorativo copiado de church_main_screen.
  Widget _buildDecorativeDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.6),
                    Colors.white.withOpacity(0.1),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: kButtonColor.withOpacity(0.7),
                width: 1.5,
              ),
            ),
            child: Icon(
              Icons.radio,
              color: kButtonColor,
              size: 20,
            ),
          ),
          Expanded(
            child: Container(
              height: 1.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.6),
                    Colors.white.withOpacity(0.1),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionErrorOverlay() => Container(
        color: Colors.black54,
        child: const Center(
          child: Text('Sem conexão. Verifique sua internet.', style: TextStyle(color: Colors.white)),
        ),
      );

  Widget _buildStreamingErrorOverlay() => Container(
        color: Colors.black54,
        child: const Center(
          child: Text('Erro no servidor de rádio.', style: TextStyle(color: Colors.white)),
        ),
      );

  Widget _buildLoadingOverlay() => Container(
        color: Colors.black54,
        child: const Center(child: CircularProgressIndicator(color: Colors.redAccent)),
      );
}

