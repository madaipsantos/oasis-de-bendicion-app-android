import 'package:flutter/material.dart';

const double kCardRadius = 15.0;
const double kAppBarFontSize = 27.0;
const Color kBorderColor = Color.fromARGB(255, 141, 59, 59);

class ChurchServicesScreen extends StatelessWidget {
  const ChurchServicesScreen({super.key});

  Widget _buildAgendaItem(
      String day, String title, String time, IconData icon, double width) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kCardRadius),
        border: Border.all(color: kBorderColor.withOpacity(0.5), width: 1.2),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black.withOpacity(0.7),
            Colors.black.withOpacity(0.5),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: width * 0.07, color: Colors.red.shade400),
          const SizedBox(width: 16),

          // Textos
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.042,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.2)),
                const SizedBox(height: 4),
                Text(time,
                    style: TextStyle(
                        color: Colors.white70, 
                        fontSize: width * 0.034,
                        letterSpacing: 0.3)),
              ],
            ),
          ),

          // Dia (badge)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.red.shade600,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.25),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Text(day,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: width * 0.034,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Oasis de Bendición",
            style: TextStyle(fontSize: kAppBarFontSize, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/back.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(width * 0.055),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Título de la sección
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: Text(
                      "Servicios",
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
                  _buildAgendaItem(
                      "DOM", "Culto Dominical", "12:00h", Icons.church, width),
                  _buildAgendaItem(
                      "MAR", "Culto de Oración", "20:00h", Icons.self_improvement, width),
                  _buildAgendaItem(
                      "MIÉ", "Oración de la Mañana", "06:00h", Icons.wb_sunny, width),
                  _buildAgendaItem(
                      "JUE", "Estudio Bíblico", "20:00h", Icons.school, width),
                  _buildAgendaItem(
                      "VIE", "Reunión de Jóvenes", "20:00h - (Confirmar Programación)", Icons.handshake, width),
                  _buildAgendaItem(
                      "VIE", "Reunión de Mujeres", "20:00h - (Confirmar Programación)", Icons.handshake, width),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
