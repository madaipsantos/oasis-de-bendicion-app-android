import 'package:flutter/material.dart';

// Constants
const double kCardHeightFactor = 0.22;
const double kCardRadius = 15.0;
const double kCardBorder = 4.0;
const double kTitleFontSize = 22.0;
const double kTextFontSize = 17.0;
const double kAppBarFontSize = 27.0;
const Color kBorderColor = Color.fromARGB(255, 141, 59, 59);

/// Screen that displays the church mission, including image, description, and Bible verse.
class ChurchMissionScreen extends StatefulWidget {
  const ChurchMissionScreen({super.key});

  @override
  State<ChurchMissionScreen> createState() => _ChurchMissionScreenState();
}

class _ChurchMissionScreenState extends State<ChurchMissionScreen> {
  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsiveness
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double cardHeight = screenHeight * kCardHeightFactor;
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
      body: Container(
        // Background image
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
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                      vertical: screenHeight * 0.03,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Mission image card
                        _buildImageCard(cardHeight),
                        const SizedBox(height: 20),
                        // Mission title
                        _buildTitle("Misión"),
                        const SizedBox(height: 20),
                        // Mission description
                        _buildText(
                          "Ser un entorno de transformación familiar y espiritual, dinámico y poderoso que no pierde el enfoque ni la esencia de su razón de ser. Promoviendo el mensaje de salvación desde el ejemplo, haciendo discípulos hasta lo último de la tierra... con múltiples ubicaciones alrededor del mundo.",
                          textWidth,
                        ),
                        const SizedBox(height: 20),
                        // Bible reference
                        _buildTitle("Mateo 28:19-20", fontSize: 21),
                        const SizedBox(height: 10),
                        // Bible verse
                        _buildText(
                          "Por tanto, id, y haced discípulos a todas las naciones, bautizándolos en el nombre del Padre, y del Hijo, y del Espíritu Santo; enseñándoles que guarden todas las cosas que os he mandado; y he aquí yo estoy con vosotros todos los días, hasta el fin del mundo. Amen!",
                          textWidth,
                        ),
                        // Spacer to push content up if needed
                        const Expanded(child: SizedBox()),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Builds the mission image card.
  Widget _buildImageCard(double height) {
    return Container(
      height: height,
      width: double.infinity,
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: kBorderColor,
          width: kCardBorder,
        ),
        borderRadius: BorderRadius.circular(kCardRadius),
        image: const DecorationImage(
          image: AssetImage('assets/santabiblia.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  /// Builds a centered title text.
  Widget _buildTitle(String text, {double fontSize = kTitleFontSize}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: Colors.white,
      ),
      textAlign: TextAlign.center,
    );
  }

  /// Builds a justified mission or Bible verse text.
  Widget _buildText(String text, double width) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: kTextFontSize,
          color: Colors.white,
        ),
        softWrap: true,
        textAlign: TextAlign.justify,
      ),
    );
  }
}