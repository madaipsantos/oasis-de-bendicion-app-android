import 'package:flutter/material.dart';

const double kCardRadius = 15.0;
const double kAppBarFontSize = 24.0;
const Color kBorderColor = Color.fromARGB(255, 141, 59, 59);

class RadioProgramsScreen extends StatefulWidget {
  const RadioProgramsScreen({super.key});

  @override
  State<RadioProgramsScreen> createState() => _RadioProgramsScreenState();
}

class _RadioProgramsScreenState extends State<RadioProgramsScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Programas Radiales",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
      ),

      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/back.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(width * 0.05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildProgramCard(
                    title: "Conecta2 @ Jesus",
                    description: "Un programa juvenil con música, enseñanza y unión espiritual.",
                    time: "Lunes - Viernes 12:30H",
                  ),
                  _buildProgramCard(
                    title: "Pan Fresco",
                    description: "Palabras que renovan el alma durante la semana.",
                    time: "Lunes & Miércoles 20:00H",
                  ),
                  _buildProgramCard(
                    title: "Sinergia",
                    description: "Un espacio para fortalecer la comunión entre hermanos.",
                    time: "Sábados 17:00H",
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProgramCard({
    required String title,
    required String time,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(kCardRadius),
        border: Border.all(color: kBorderColor.withOpacity(0.5), width: 2),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.mic, color: Colors.white, size: 30),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          Divider(color: Colors.white.withOpacity(0.3)),

          Text(
            description,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          Text(
            time,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
