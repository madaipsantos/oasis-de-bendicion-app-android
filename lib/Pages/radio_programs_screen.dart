import 'package:flutter/material.dart';

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
    final double cardRadius = 15.0;
    final double cardBorder = 4.0;
    final double tituloFont = 22.0;
    final double textoFont = 17.0;
    final double textoLargura = screenWidth * 0.90;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          "Oasis de Bendición",
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
          ),
          Positioned(
            top: cardTop,
            left: cardSide,
            right: cardSide,
            bottom: 0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildServiceCard(
                    title: "Conecta2 @ Jesus",
                    imagePath: "assets/conectados.png",
                    time: "Lunes - Viernes 12:30H",
                    cardHeight: cardHeight,
                    cardRadius: cardRadius,
                    cardBorder: cardBorder,
                    tituloFont: tituloFont,
                    textoFont: textoFont,
                    textoLargura: textoLargura,
                  ),
                  _buildServiceCard(
                    title: "Pan Fresco",
                    imagePath: "assets/panFresco.jpg",
                    time: "Lunes & Miércoles 20:00H",
                    cardHeight: cardHeight,
                    cardRadius: cardRadius,
                    cardBorder: cardBorder,
                    tituloFont: tituloFont,
                    textoFont: textoFont,
                    textoLargura: textoLargura,
                  ),
                  _buildServiceCard(
                    title: "Sinergia",
                    imagePath: "assets/synergia.jpg",
                    time: "Sábados 17:00H",
                    cardHeight: cardHeight,
                    cardRadius: cardRadius,
                    cardBorder: cardBorder,
                    tituloFont: tituloFont,
                    textoFont: textoFont,
                    textoLargura: textoLargura,
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard({
    required String title,
    required String imagePath,
    String? description,
    required String time,
    required double cardHeight,
    required double cardRadius,
    required double cardBorder,
    required double tituloFont,
    required double textoFont,
    required double textoLargura,
  }) {
    return Card(
      // ignore: deprecated_member_use
      color: Colors.black.withOpacity(0.01),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
      ),
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: tituloFont,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: cardHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(cardRadius),
                border: Border.all(
                  color: Color.fromARGB(255, 141, 59, 59),
                  width: cardBorder,
                ),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            if (description != null) ...[
              SizedBox(height: 10),
              SizedBox(
                width: textoLargura,
                child: Text(
                  description,
                  style: TextStyle(fontSize: textoFont, color: Colors.white),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
            ],
            SizedBox(height: 10),
            Center(
              child: Text(
                time,
                style: TextStyle(
                  fontSize: 17,
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
