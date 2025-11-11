import 'package:flutter/material.dart';

// Constantes copiadas da tela principal para garantir a consistência
const Color kCardColor = Color.fromARGB(255, 141, 59, 59); // Cor principal
const Color kButtonColor = Colors.red;
const double kScreenPadding = 20.0;
const double kCardBorderRadius = 10.0; // Mantendo o valor do layout base (10.0)

/// Tela dedicada à Localização, Endereço e Horários de Serviço da Igreja.
class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Donde Estamos",
          style: TextStyle(
            fontSize: 22.0,
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
                  // -----------------------------------------------------------
                  // 1. Placeholder do Mapa
                  // -----------------------------------------------------------
                  _buildMapPlaceholder(screenWidth),

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
                          title: "Dirección del Templo",
                          address: "Carretera Carbonera, 2227",
                          city: "Gijon, Asturias, España",
                          screenWidth: screenWidth,
                        ),

                        const SizedBox(height: 20),

                        // Botão de Rota (Ação externa)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                _showSnackBar(context, "Abrindo Google Maps com a rota...");
                                // Em um app real: launchUrl(Uri.parse('googlemaps://...'));
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
                                "Traçar Rota no Mapa",
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

  /// Constrói o placeholder do Mapa (simulando a visualização)
  Widget _buildMapPlaceholder(double screenWidth) {
    return Container(
      height: screenWidth * 0.7, // Altura responsiva
      decoration: const BoxDecoration(
        color: Colors.black54,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.map,
              color: kButtonColor,
              size: screenWidth * 0.2,
            ),
            const SizedBox(height: 10),
            Text(
              "Visualização do Mapa (Placeholder)",
              style: TextStyle(
                color: Colors.white70,
                fontSize: screenWidth * 0.04,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Constrói o cartão de informações detalhadas (Endereço e Horários)
  Widget _buildInfoCard({
    required BuildContext context,
    required String title,
    required String address,
    required String city,
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
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromARGB(255, 141, 59, 59),
              fontSize: screenWidth * 0.05,
              letterSpacing: 0.5,
            ),
          ),
          const Divider(color: Colors.white24, height: 20),
          
          // Endereço
          _buildInfoRow(
            icon: Icons.pin_drop,
            text: address,
            isBold: false,
            screenWidth: screenWidth,
          ),
          _buildInfoRow(
            icon: Icons.location_city,
            text: city,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white70, size: screenWidth * 0.045),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.04,
                fontWeight: isBold ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
        ],
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
