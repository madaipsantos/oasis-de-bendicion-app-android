import 'package:flutter/material.dart';
import 'package:webradiooasis/presentation/screens/church_contacts_screen.dart';
import 'package:webradiooasis/presentation/screens/church_mission_screen.dart';
import 'package:webradiooasis/presentation/screens/church_services_screen.dart';
import 'package:webradiooasis/presentation/screens/church_vision_screen.dart';
//import 'package:webradiooasis/utils/app_info.dart';
import 'radio_main_screen.dart';

/// Tela principal da igreja, exibe cards para missão, visão, serviços e contatos.
/// Possui navegação inferior para alternar entre a área da igreja e a área da rádio.
class ChurchMainScreen extends StatefulWidget {
  const ChurchMainScreen({super.key});

  @override
  State<ChurchMainScreen> createState() => _ChurchMainScreenState();
}

class _ChurchMainScreenState extends State<ChurchMainScreen> {
  int _selectedIndex = 0;
  // String _appVersion = '';

  @override
  void initState() {
    super.initState();
    // Exemplo de como obter a versão do app (comentado)
    // AppInfo.getAppVersion().then((version) {
    //   setState(() {
    //     _appVersion = version;
    //   });
    // });
  }

  /// Atualiza o índice selecionado da barra de navegação inferior e faz a navegação.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Se já está na tela da igreja, não faz nada
        if (_selectedIndex != 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ChurchMainScreen()),
          );
        }
        break;
      case 1:
        // Navega para a tela principal da rádio
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RadioMainScreen()),
        );
        break;
      case 2:
        // Não há terceira opção implementada
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtém dimensões da tela para responsividade
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double cardHeight = screenHeight * 0.15; 
    final double buttonWidth = screenWidth * 0.34; 
    final double buttonTop = 0.0; 
    final double buttonRight = 5.0;

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
          // Imagem de fundo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/back.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Conteúdo rolável com os cards principais
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  // Card Missão
                  _buildCard(
                    context: context,
                    imagePath: 'assets/santabiblia.jpg',
                    buttonLabel: "Misión",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChurchMissionScreen(),
                        ),
                      );
                    },
                    cardHeight: cardHeight,
                    buttonWidth: buttonWidth,
                    buttonTop: buttonTop,
                    buttonRight: buttonRight,
                  ),
                  SizedBox(height: 15),
                  // Card Visão
                  _buildCard(
                    context: context,
                    imagePath: 'assets/vision.jpg',
                    buttonLabel: "Visión",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChurchVisionScreen(),
                        ),
                      );
                    },
                    cardHeight: cardHeight,
                    buttonWidth: buttonWidth,
                    buttonTop: buttonTop,
                    buttonRight: buttonRight,
                  ),
                  SizedBox(height: 15),
                  // Card Serviços
                  _buildCard(
                    context: context,
                    imagePath: 'assets/discipulado.jpg',
                    buttonLabel: "Servicios",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChurchServicesScreen(),
                        ),
                      );
                    },
                    cardHeight: cardHeight,
                    buttonWidth: buttonWidth,
                    buttonTop: buttonTop,
                    buttonRight: buttonRight,
                  ),
                  SizedBox(height: 15),
                  // Card Contatos
                  _buildCard(
                    context: context,
                    imagePath: 'assets/google_maps_alt.png',
                    buttonLabel: "Contactos",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChurchContactsScreen(),
                        ),
                      );
                    },
                    cardHeight: cardHeight,
                    buttonWidth: buttonWidth,
                    buttonTop: buttonTop,
                    buttonRight: buttonRight,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // Barra de navegação inferior para alternar entre Igreja e Rádio
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.white,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.church), label: "Iglesia"),
          BottomNavigationBarItem(icon: Icon(Icons.radio), label: "Radio"),
        ],
      ),
    );
  }

  /// Constrói um card com imagem e botão, usado para cada seção (Missão, Visão, etc).
  Widget _buildCard({
    required BuildContext context,
    required String imagePath,
    required String buttonLabel,
    required VoidCallback onTap,
    required double cardHeight,
    required double buttonWidth,
    required double buttonTop,
    required double buttonRight,
  }) {
    return Card(
      color: const Color.fromARGB(255, 141, 59, 59),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: double.infinity,
        height: cardHeight,
        padding: const EdgeInsets.all(4.0),
        child: Stack(
          children: [
            // Imagem de fundo do card, clicável
            GestureDetector(
              onTap: onTap,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
            // Botão sobreposto no canto superior direito do card
            Positioned(
              top: buttonTop,
              right: buttonRight,
              child: SizedBox(
                width: buttonWidth,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    minimumSize: Size(40, 30),
                  ),
                  child: Text(
                    buttonLabel,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}