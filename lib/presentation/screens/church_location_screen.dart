import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Constantes copiadas da tela principal para garantir a consistência
const Color kCardColor = Color.fromARGB(255, 141, 59, 59); // Cor principal
const Color kButtonColor = Colors.red;
const double kScreenPadding = 20.0;
const double kCardBorderRadius = 10.0; // Mantendo o valor do layout base (10.0)

// Constantes de ubicación de la iglesia
const String kGeoUrl =
    "geo:43.5322026,-5.6611196?q=Carretera Carbonara, 2227. Gijón, Asturias - España";
const String kGoogleMapsUrl =
    "https://www.google.com/maps/search/?api=1&query=Carretera+Carbonara,+2227,+Gij%C3%B3n,+Asturias+-+Espa%C3%B1a";
const String kChurchAddress = "Carretera Carbonara, 2227. Gijón, Asturias - España";

/// Tela dedicada à Localização, Endereço e Horários de Serviço da Igreja.
class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Dirección",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // -----------------------------------------------------------
      // ESTRUTURA STACK REPLICADA DO ChurchMainScreen
      // -----------------------------------------------------------
      backgroundColor: Colors.grey[200],
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

          // Contenido principal
          Positioned(
            top: MediaQuery.of(context).size.height * 0.03,
            left: MediaQuery.of(context).size.width * 0.04,
            right: MediaQuery.of(context).size.width * 0.04,
            bottom: 0,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título de la sección
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(bottom: 15),
                    child: Text(
                      "Dirección",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.080,
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
                  // -----------------------------------------------------------
                  // 1. Imagen del Mapa
                  // -----------------------------------------------------------
                  Container(
                    alignment: Alignment.center,
                    height: screenWidth * 0.6, // Altura responsiva
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color.fromARGB(255, 141, 59, 59).withOpacity(0.5),
                        width: 1.2,
                      ),
                      color: Colors.black54,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Opacity(
                        opacity: 0.8, // Opacidad del mapa
                        child: Image.asset(
                          'assets/mapa.png',
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  // -----------------------------------------------------------
                  // 2. Informações de Endereço e Contato
                  // -----------------------------------------------------------
                  Padding(
                    padding: const EdgeInsets.all(kScreenPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        // Cartão principal com Endereço e Horários
                        _buildInfoCard(
                          context: context,
                          address: "Carretera Carbonera, 2227. Gijón, Asturias - España",
                          screenWidth: screenWidth,
                        ),

                        const SizedBox(height: 30),

                        // Botão de Rota (Ação externa)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () async {
                                if (await canLaunchUrl(Uri.parse(kGoogleMapsUrl))) {
                                  await launchUrl(
                                    Uri.parse(kGoogleMapsUrl),
                                    mode: LaunchMode.externalApplication,
                                  );
                                } else {
                                  _showSnackBar(context, "No se pudo abrir Google Maps.");
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(2255, 189, 52, 42),
                                padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 15),
                                minimumSize: const Size(90, 40),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(kCardBorderRadius),
                                ),
                              ),
                              icon: const Icon(Icons.near_me, color: Colors.white),
                              label: const Text(
                                "Ruta en el mapa",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói o cartão de informações detalhadas (Endereço e Horários)
  Widget _buildInfoCard({
    required BuildContext context,
    required String address,
    required double screenWidth,
  }) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: Color.fromARGB(255, 141, 59, 59).withOpacity(0.5), width: 1.2),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [      
          // Endereço
          _buildInfoRow(
            icon: Icons.pin_drop,
            text: address,
            isBold: false,
            screenWidth: screenWidth,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  /// Constrói uma linha de informação simples.
  Widget _buildInfoRow({
    required IconData icon,
    required String text,
    required bool isBold,
    required double screenWidth,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: screenWidth * 0.04,
            fontWeight: isBold ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  /// Exibe uma SnackBar como feedback temporário.
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
