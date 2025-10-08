import 'package:flutter/material.dart';

// Constants
const double kCardRadius = 15.0;
const double kCardBorder = 4.0;
const double kAppBarFontSize = 27.0;
const double kTitleFontSize = 22.0;
const double kTextFontSize = 17.0;
const Color kBorderColor = Color.fromARGB(255, 141, 59, 59);

/// Screen that displays the church vision, including an illustrative image and explanatory text.
class ChurchVisionScreen extends StatefulWidget {
  const ChurchVisionScreen({super.key});

  @override
  State<ChurchVisionScreen> createState() => _ChurchVisionScreenState();
}

class _ChurchVisionScreenState extends State<ChurchVisionScreen> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double cardTop = screenHeight * 0.03;
    final double cardSide = screenWidth * 0.04;
    final double cardHeight = screenHeight * 0.22;
    final double tituloTop = cardTop + cardHeight + 15;
    final double textoTop = tituloTop + 50;
    final double textoLargura = screenWidth * 0.90;

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
          // Vision image card
          Positioned(
            top: cardTop,
            left: cardSide,
            right: cardSide,
            child: _buildImageCard(cardHeight),
          ),
          // Vision title
          Positioned(
            top: tituloTop,
            left: 0,
            right: 0,
            child: _buildTitle("Visión"),
          ),
          // Vision description text
          Positioned(
            top: textoTop,
            left: cardSide + 4,
            child: SizedBox(
              width: textoLargura,
              child: _buildText(
                "Ser una Iglesia que trasforma su entorno (Familia, vecinos, ciudad, país) por el Poder y conocimiento de Dios, desde la intimidad de su presencia. Conociendo, escuchando y haciendo su voluntad; llevando a cabalidad su llamado, tanto individual, familiar y colectivo; para que todas las esferas de la sociedad sean afectadas por cada uno de sus discípulos. realizando así la tarea demandada por nuestro señor Jesucristo con excelencia.",
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the vision image card.
  Widget _buildImageCard(double height) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(kCardRadius),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: kBorderColor,
              width: kCardBorder,
            ),
            borderRadius: BorderRadius.circular(kCardRadius),
            image: const DecorationImage(
              image: AssetImage('assets/vision.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }

  /// Builds a centered title text.
  Widget _buildTitle(String text) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(fontSize: kTitleFontSize, color: Colors.white),
      ),
    );
  }

  /// Builds a justified vision description text.
  Widget _buildText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: kTextFontSize, color: Colors.white),
      softWrap: true,
      textAlign: TextAlign.justify,
    );
  }
}