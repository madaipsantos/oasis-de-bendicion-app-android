import 'dart:ui';
import 'package:flutter/material.dart';

class VisionMissionScreen extends StatelessWidget {
  const VisionMissionScreen({super.key});

  Widget buildBlock(String title, String text, double width) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.55),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Color.fromARGB(255, 141, 59, 59).withOpacity(0.5), width: 1.2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(title,
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: width * 0.064,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 14),
              Text(
                text,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    color: Colors.white, fontSize: width * 0.040, height: 1.4),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Visión y Misión", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Image.asset("assets/back.jpg",
              width: double.infinity, height: double.infinity, fit: BoxFit.cover),
          SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: Text(
                      "Visión y Misión",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.080,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        shadows: [
                          Shadow(
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Separador decorativo
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            height: 1.5,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.red.shade400.withOpacity(0.2),
                                  Colors.red.shade400.withOpacity(0.7),
                                  Colors.red.shade400.withOpacity(0.2),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.red.shade400.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            height: 1.5,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.red.shade400.withOpacity(0.2),
                                  Colors.red.shade400.withOpacity(0.7),
                                  Colors.red.shade400.withOpacity(0.2),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  buildBlock(
                      "VISIÓN",
                      "Ser una Iglesia que trasforma su entorno (Familia, vecinos, ciudad, país) por el Poder y conocimiento de Dios, desde la intimidad de su presencia. Conociendo, escuchando y haciendo su voluntad; llevando a cabalidad su llamado, tanto individual, familiar y colectivo; para que todas las esferas de la sociedad sean afectadas por cada uno de sus discípulos. realizando así la tarea demandada por nuestro señor Jesucristo con excelencia.",
                      width),
                  const SizedBox(height: 28),
                  buildBlock(
                      "MISIÓN",
                      "Ser un entorno de transformación familiar y espiritual, dinámico y poderoso que no pierde el enfoque ni la esencia de su razón de ser. Promoviendo el mensaje de salvación desde el ejemplo, haciendo discípulos hasta lo último de la tierra... con múltiples ubicaciones alrededor del mundo.",
                      width),
                ],
            ),
          ),
        ],
      ),
    );
  }
}
