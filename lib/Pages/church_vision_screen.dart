import 'package:flutter/material.dart';

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
    final double cardRadius = 15.0;
    final double cardBorder = 4.0;
    final double tituloTop = cardTop + cardHeight + 15;
    final double tituloFont = 22.0;
    final double textoTop = tituloTop + 50;
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
            child: Container(
              height: cardHeight,
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(cardRadius),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(255, 141, 59, 59),
                      width: cardBorder,
                    ),
                    borderRadius: BorderRadius.circular(cardRadius),
                    image: const DecorationImage(
                      image: AssetImage('assets/vision.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          ),
          Positioned(
            top: tituloTop,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "Visión",
                style: TextStyle(fontSize: tituloFont, color: Colors.white),
              ),
            ),
          ),
          Positioned(
            top: textoTop,
            left: cardSide + 4,
            child: SizedBox(
              width: textoLargura,
              child: Text(
                "Ser una Iglesia que trasforma su entorno (Familia, vecinos, ciudad, país) por el Poder y conocimiento de Dios, desde la intimidad de su presencia. Conociendo, escuchando y haciendo su voluntad; llevando a cabalidad su llamado, tanto individual, familiar y colectivo; para que todas las esferas de la sociedad sean afectadas por cada uno de sus discípulos. realizando así la tarea demandada por nuestro señor Jesucristo con excelencia.",
                style: TextStyle(fontSize: textoFont, color: Colors.white),
                softWrap: true,
                textAlign: TextAlign.justify,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
