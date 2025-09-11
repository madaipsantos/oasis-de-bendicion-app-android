import 'package:flutter/material.dart';
import 'package:webradiooasis/Pages/church_contacts_screen.dart';
import 'package:webradiooasis/Pages/church_mission_screen.dart';
import 'package:webradiooasis/Pages/church_services_screen.dart';
import 'package:webradiooasis/Pages/church_vision_screen.dart';
//import 'package:webradiooasis/utils/app_info.dart';
import 'radio_main_screen.dart';

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
    //    AppInfo.getAppVersion().then((version) {
    //    setState(() {
    //      _appVersion = version;
    //    });
    //  });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        if (_selectedIndex != 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ChurchMainScreen()),
          );
        }
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RadioMainScreen()),
        );
        break;
      case 2:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
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
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/back.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
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
