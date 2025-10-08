import 'package:flutter/material.dart';
import 'package:webradiooasis/config/router/app_router.dart';

// Constants
const Color kCardColor = Color.fromARGB(255, 141, 59, 59);
const Color kButtonColor = Colors.red;
const Color kButtonTextColor = Colors.white;
const double kAppBarFontSize = 27.0;
const double kButtonFontSize = 16.0;
const double kCardBorderRadius = 10.0;
const double kButtonBorderRadius = 4.0;
const double kCardPadding = 4.0;
const double kScreenPadding = 20.0;
const double kButtonMinWidth = 40.0;
const double kButtonMinHeight = 30.0;

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

  @override
  void initState() {
    super.initState();
    // Example: Fetch app version if needed
    // AppInfo.getAppVersion().then((version) {
    //   setState(() {
    //     _appVersion = version;
    //   });
    // });
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

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsiveness
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double cardHeight = screenHeight * 0.15;
    final double buttonWidth = screenWidth * 0.34;
    final double buttonTop = 0.0;
    final double buttonRight = 5.0;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          "Oasis de Bendición",
          style: TextStyle(fontSize: kAppBarFontSize, fontWeight: FontWeight.bold),
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
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(kScreenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildCard(
                    context: context,
                    imagePath: 'assets/santabiblia.jpg',
                    buttonLabel: "Misión",
                    onTap: () {
                      Navigator.pushNamed(context, AppRouter.mission);
                    },
                    cardHeight: cardHeight,
                    buttonWidth: buttonWidth,
                    buttonTop: buttonTop,
                    buttonRight: buttonRight,
                  ),
                  const SizedBox(height: 15),
                  _buildCard(
                    context: context,
                    imagePath: 'assets/vision.jpg',
                    buttonLabel: "Visión",
                    onTap: () {
                      Navigator.pushNamed(context, AppRouter.vision);
                    },
                    cardHeight: cardHeight,
                    buttonWidth: buttonWidth,
                    buttonTop: buttonTop,
                    buttonRight: buttonRight,
                  ),
                  const SizedBox(height: 15),
                  _buildCard(
                    context: context,
                    imagePath: 'assets/discipulado.jpg',
                    buttonLabel: "Servicios",
                    onTap: () {
                      Navigator.pushNamed(context, AppRouter.services);
                    },
                    cardHeight: cardHeight,
                    buttonWidth: buttonWidth,
                    buttonTop: buttonTop,
                    buttonRight: buttonRight,
                  ),
                  const SizedBox(height: 15),
                  _buildCard(
                    context: context,
                    imagePath: 'assets/google_maps_alt.png',
                    buttonLabel: "Contactos",
                    onTap: () {
                      Navigator.pushNamed(context, AppRouter.contacts);
                    },
                    cardHeight: cardHeight,
                    buttonWidth: buttonWidth,
                    buttonTop: buttonTop,
                    buttonRight: buttonRight,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // Bottom navigation bar to switch between Church and Radio
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: kButtonColor,
        unselectedItemColor: Colors.white,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.church), label: "Iglesia"),
          BottomNavigationBarItem(icon: Icon(Icons.radio), label: "Radio"),
        ],
      ),
    );
  }

  /// Builds a card with image and button for each section.
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
      color: kCardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kCardBorderRadius)),
      child: Container(
        width: double.infinity,
        height: cardHeight,
        padding: const EdgeInsets.all(kCardPadding),
        child: Stack(
          children: [
            // Card background image, clickable
            GestureDetector(
              onTap: onTap,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(kCardBorderRadius),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
            // Button positioned at the top right corner of the card
            Positioned(
              top: buttonTop,
              right: buttonRight,
              child: SizedBox(
                width: buttonWidth,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kButtonColor,
                    foregroundColor: kButtonTextColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(kButtonBorderRadius),
                    ),
                    minimumSize: const Size(kButtonMinWidth, kButtonMinHeight),
                  ),
                  child: Text(
                    buttonLabel,
                    style: const TextStyle(fontSize: kButtonFontSize, color: kButtonTextColor),
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