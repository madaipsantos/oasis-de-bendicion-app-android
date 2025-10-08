import 'package:flutter/material.dart';

// Constants
const double kCardRadius = 15.0;
const double kCardBorder = 4.0;
const double kAppBarFontSize = 27.0;
const double kTitleFontSize = 22.0;
const double kTextFontSize = 17.0;
const double kTimeFontSize = 17.0;
const Color kBorderColor = Color.fromARGB(255, 141, 59, 59);

/// Screen that displays the main church services and schedules.
class ChurchServicesScreen extends StatefulWidget {
  const ChurchServicesScreen({super.key});

  @override
  State<ChurchServicesScreen> createState() => _ChurchServicesScreenState();
}

class _ChurchServicesScreenState extends State<ChurchServicesScreen> {
  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsiveness
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
          // Scrollable content with service cards
          Positioned(
            top: cardTop,
            left: cardSide,
            right: cardSide,
            bottom: 0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildServiceCard(
                    title: "Culto Familiar",
                    imagePath: "assets/vision.jpg",
                    description: "Donde toda la familia está convocada a una experiencia con el Espíritu Santo.",
                    time: "Domingo 12:00H",
                    cardHeight: cardHeight,
                    textWidth: textWidth,
                  ),
                  _buildServiceCard(
                    title: "Culto de Oración",
                    imagePath: "assets/oracion_culto.png",
                    description: "Tiempo donde nos conectamos en Clamor al Padre.",
                    time: "Martes 20:00H",
                    cardHeight: cardHeight,
                    textWidth: textWidth,
                  ),
                  _buildServiceCard(
                    title: "Oración de la Mañana",
                    imagePath: "assets/oracion.jpg",
                    time: "Miércoles 06:00H",
                    cardHeight: cardHeight,
                    textWidth: textWidth,
                  ),
                  _buildServiceCard(
                    title: "Discipulado",
                    imagePath: "assets/discipulado.jpg",
                    description: "Un espacio donde aprendemos más acerca de Jesús y el ser sus discípulos.",
                    time: "Jueves 20:00H",
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

  /// Builds a card for each service, displaying title, image, description, and time.
  Widget _buildServiceCard({
    required String title,
    required String imagePath,
    String? description,
    required String time,
    required double cardHeight,
    required double textWidth,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Card(
        color: Colors.black.withOpacity(0.01),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kCardRadius),
        ),
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
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}