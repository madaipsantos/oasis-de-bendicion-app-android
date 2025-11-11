import 'dart:ui';
import 'package:flutter/material.dart';

class PrayerRequestScreen extends StatefulWidget {
  const PrayerRequestScreen({super.key});

  @override
  State<PrayerRequestScreen> createState() => _PrayerRequestScreenState();
}

class _PrayerRequestScreenState extends State<PrayerRequestScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _requestController = TextEditingController();

  void _sendRequest() {
    if (_requestController.text.trim().isEmpty) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("🙏 Gracias, estaremos orando.")),
    );
    _nameController.clear();
    _requestController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Peticiones de Oración"),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Image.asset("assets/back.jpg",
              width: double.infinity, height: double.infinity, fit: BoxFit.cover),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: width * 0.07),
                Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  alignment: Alignment.center,
                  child: Text(
                    "Peticiones de Oración",
                    textAlign: TextAlign.center,
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
                SizedBox(height: 10),                // Card de petición de oración
                Center(
                  child: Container(
                    width: width * 0.85,
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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Queremos orar contigo",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: width * 0.06,
                              fontWeight: FontWeight.bold,
                            )),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _nameController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Tu Nombre (opcional)",
                            labelStyle: TextStyle(color: Colors.white70),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white54),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: _requestController,
                          maxLines: 4,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Escribe tu petición",
                            labelStyle: TextStyle(color: Colors.white70),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white54),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: _sendRequest,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 189, 52, 42),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                minimumSize: const Size(90, 40),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: const Text("Enviar Petición"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
