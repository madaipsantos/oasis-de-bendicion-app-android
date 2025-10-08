import 'package:flutter/material.dart';

// Constants
const double kCardRadius = 15.0;
const double kCardBorder = 4.0;
const double kAppBarFontSize = 27.0;
const double kTitleFontSize = 22.0;
const double kTextFontSize = 17.0;
const double kTimeFontSize = 17.0;
const Color kBorderColor = Color.fromARGB(255, 141, 59, 59);

/// Screen that displays the main radio programs and their schedules.
class RadioProgramsScreen extends StatefulWidget {
  const RadioProgramsScreen({super.key});

  @override
  State<RadioProgramsScreen> createState() => _RadioProgramsScreenState();
}

class _RadioProgramsScreenState extends State<RadioProgramsScreen> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double cardTop = screenHeight * 0.03;
    final double cardSide = screenWidth * 0.04;
    final double cardHeight = screenHeight * 0.15;
    final double textWidth = screenWidth * 0.90;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
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
          // Scrollable content with radio program cards
          Positioned(
            top: cardTop,
            left: cardSide,
            right: cardSide,
            bottom: 0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildProgramCard(
                    title: "Conecta2 @ Jesus",
                    imagePath: "assets/conectados.png",
                    time: "Lunes - Viernes 12:30H",
                    cardHeight: cardHeight,
                    textWidth: textWidth,
                  ),
                  _buildProgramCard(
                    title: "Pan Fresco",
                    imagePath: "assets/panFresco.jpg",
                    time: "Lunes & Miércoles 20:00H",
                    cardHeight: cardHeight,
                    textWidth: textWidth,
                  ),
                  _buildProgramCard(
                    title: "Sinergia",
                    imagePath: "assets/synergia.jpg",
                    time: "Sábados 17:00H",
                    cardHeight: cardHeight,
                    textWidth: textWidth,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a card for each radio program, displaying title, image, and time.
  Widget _buildProgramCard({
    required String title,
    required String imagePath,
    String? description,
    required String time,
    required double cardHeight,
    required double textWidth,
  }) {
    return Card(
      color: Colors.black.withOpacity(0.01),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kCardRadius),
      ),
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: kTitleFontSize,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: cardHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(kCardRadius),
                border: Border.all(
                  color: kBorderColor,
                  width: kCardBorder,
                ),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            if (description != null) ...[
              const SizedBox(height: 10),
              SizedBox(
                width: textWidth,
                child: Text(
                  description,
                  style: const TextStyle(fontSize: kTextFontSize, color: Colors.white),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
            ],
            const SizedBox(height: 10),
            Center(
              child: Text(
                time,
                style: const TextStyle(
                  fontSize: kTimeFontSize,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}