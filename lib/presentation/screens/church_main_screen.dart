import 'package:flutter/material.dart';
import 'package:webradiooasis/config/router/app_router.dart';
import 'package:webradiooasis/core/models/daily_verse.dart';
import 'package:webradiooasis/infrastructure/services/daily_verse_service.dart';

// Constants
const double kCardRadius = 15.0;
const double kCardBorder = 4.0;
const double kAppBarFontSize = 27.0;
const double kTitleFontSize = 22.0;
const double kTextFontSize = 17.0;
const double kTimeFontSize = 17.0;
const Color kBorderColor = Color.fromARGB(255, 141, 59, 59);
const Color kButtonColor = Colors.red;
const double kScreenPadding = 20.0;
const String kVerseBackgroundImage = 'assets/verse1.jpg';

/// Representa uma ação principal na tela.
class ChurchAction {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  ChurchAction({required this.title, required this.icon, required this.onTap});
}

/// Main screen for the church section.
/// Displays cards for mission, vision, services, and contacts.
/// Includes bottom navigation to switch between church and radio areas.
class ChurchMainScreen extends StatefulWidget {
  const ChurchMainScreen({super.key});

  @override
  State<ChurchMainScreen> createState() => _ChurchMainScreenState();
}

class _ChurchMainScreenState extends State<ChurchMainScreen> {
  final int _selectedIndex = 0; // Church tab is always selected on this screen
  late Future<DailyVerse> _currentVerse;
  // Lista de ações mockadas para o Grid.
  late List<ChurchAction> _actions;

  @override
  void initState() {
    super.initState();
    _currentVerse = DailyVerseService.getDailyVerse();
    _initializeActions();
  }

  /// Exibe uma SnackBar como feedback temporário
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }

  /// Inicializa as ações principais da tela.
  void _initializeActions() {
    _actions = [      
      ChurchAction(
        title: "Visión y Misión",
        icon: Icons.church_sharp,
        onTap: () {
          Navigator.pushNamed(context, AppRouter.visionAndMission);
        },
      ),
      ChurchAction(
        title: "Servicios",
        icon: Icons.calendar_month,
        onTap: () {
          Navigator.pushNamed(context, AppRouter.services);
        },
      ),
      ChurchAction(
        title: "Culto en Directo",
        icon: Icons.live_tv,
        onTap: () {
          Navigator.pushNamed(context, AppRouter.cultTransmissions);
        },
      ),
      ChurchAction(
        title: "Contactos/Redes sociales",
        icon: Icons.phone,
        onTap: () {
          Navigator.pushNamed(context, AppRouter.contacts);
        },
      ),
      ChurchAction(
        title: "Peticiones de Oración",
        icon: Icons.handshake,
        onTap: () {
          Navigator.pushNamed(context, AppRouter.prayerRequests);
        },
      ),
      ChurchAction(
        title: "Ubicación",
        icon: Icons.location_on,
        onTap: () {
          Navigator.pushNamed(context, AppRouter.location);
        },
      ),
    ];
  }

  /// Handles bottom navigation tap events.
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

  /// Constrói um único item de ação (botão do grid).
  Widget _buildActionButton(ChurchAction action, double screenWidth) {
    final double iconSize = screenWidth * 0.08;
    final double adjustedFontSize = kTextFontSize * 0.85; // Reducido al 85% del tamaño original

    return InkWell(
      onTap: action.onTap,
      borderRadius: BorderRadius.circular(kCardRadius),
      child: Container(
        padding: const EdgeInsets.all(kCardBorder),
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

  /// Constrói a grade de botões de ação responsiva.
  Widget _buildActionGrid(double screenWidth) {
    int crossAxisCount = screenWidth < 450 ? 2 : 3;
    double spacing = kScreenPadding / 2;
    double aspectRatio = MediaQuery.of(context).size.aspectRatio;
    // Ajustar el aspect ratio para diferentes tamaños de pantalla
    double childAspectRatio = aspectRatio < 1.0 ? 1.5 : 1.8;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: spacing,
      mainAxisSpacing: spacing,
      childAspectRatio: childAspectRatio,
      children: _actions.map((action) => _buildActionButton(action, screenWidth)).toList(),
    );
  }

  /// Constrói o widget do Versículo do Dia.
  Widget _buildVerseOfTheDayCard(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.only(bottom: kScreenPadding / 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kCardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        image: const DecorationImage(
          image: AssetImage(kVerseBackgroundImage),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Color.fromRGBO(0, 0, 0, 0.6),
            BlendMode.darken,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kScreenPadding * 0.8,
          vertical: kScreenPadding,
        ),
        child: FutureBuilder<DailyVerse>(
          future: _currentVerse,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            }
            
            if (snapshot.hasError) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Error al cargar el versículo',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        DailyVerseService.clearCache();
                        _currentVerse = DailyVerseService.getDailyVerse();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kButtonColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Intentar nuevamente'),
                  ),
                ],
              );
            }

            final verse = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Versículo del Día",
                  style: TextStyle(
                    color: kButtonColor,
                    fontSize: screenWidth * 0.040,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(color: Colors.white54, height: 16),
                Text(
                  "\"${verse.texto}\"",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.035,
                    fontStyle: FontStyle.italic,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "${verse.livro} ${verse.capitulo}:${verse.versiculo}",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: screenWidth * 0.03,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          "Oasis de Bendición",
          style: TextStyle(
            fontSize: kAppBarFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
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
          // Scrollable content with main cards
          Positioned(
            top: MediaQuery.of(context).size.height * 0.03,
            left: MediaQuery.of(context).size.width * 0.04,
            right: MediaQuery.of(context).size.width * 0.04,
            bottom: 0,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildVerseOfTheDayCard(context),
                  // Divisor decorativo
                  Container(
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
                            Icons.church_outlined,
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
                  ),
                  _buildActionGrid(MediaQuery.of(context).size.width),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: kButtonColor,
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.black,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.church), label: "Iglesia"),
          BottomNavigationBarItem(icon: Icon(Icons.radio), label: "Radio"),
        ],
      ),
    );
  }
}