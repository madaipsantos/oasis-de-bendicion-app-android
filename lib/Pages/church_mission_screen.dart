import 'package:flutter/material.dart';

class ChurchMissionScreen extends StatefulWidget {
  const ChurchMissionScreen({super.key});

  @override
  State<ChurchMissionScreen> createState() => _ChurchMissionScreenState();
}

class _ChurchMissionScreenState extends State<ChurchMissionScreen> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double cardHeight = screenHeight * 0.22;
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
      body: Container(
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
                        // Card com imagem
                        Container(
                          height: cardHeight,
                          width: double.infinity,
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromARGB(255, 141, 59, 59),
                              width: cardBorder,
                            ),
                            borderRadius: BorderRadius.circular(cardRadius),
                            image: const DecorationImage(
                              image: AssetImage('assets/santabiblia.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Misión",
                          style: TextStyle(
                            fontSize: tituloFont,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          width: textoLargura,
                          child: Text(
                            "Ser un entorno de transformación familiar y espiritual, dinámico y poderoso que no pierde el enfoque ni la esencia de su razón de ser. Promoviendo el mensaje de salvación desde el ejemplo, haciendo discípulos hasta lo último de la tierra... con múltiples ubicaciones alrededor del mundo.",
                            style: TextStyle(
                              fontSize: textoFont,
                              color: Colors.white,
                            ),
                            softWrap: true,
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Mateo 28:19-20",
                          style: TextStyle(fontSize: 21, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          width: textoLargura,
                          child: Text(
                            "Por tanto, id, y haced discípulos a todas las naciones, bautizándolos en el nombre del Padre, y del Hijo, y del Espíritu Santo; enseñándoles que guarden todas las cosas que os he mandado; y he aquí yo estoy con vosotros todos los días, hasta el fin del mundo. Amen!",
                            style: TextStyle(
                              fontSize: textoFont,
                              color: Colors.white,
                            ),
                            softWrap: true,
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Expanded(child: Container()),
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
}
