import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:webradiooasis/core/utils/our_social_contacts.dart';

class PrayerRequestScreen extends StatefulWidget {
  const PrayerRequestScreen({super.key});

  @override
  State<PrayerRequestScreen> createState() => _PrayerRequestScreenState();
}

class _PrayerRequestScreenState extends State<PrayerRequestScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _requestController = TextEditingController();

  void _sendRequest() async {
    if (_requestController.text.trim().isEmpty) return;
    
    // Obtener datos del formulario
    final name = _nameController.text.trim();
    final request = _requestController.text.trim();
    
    // Usar el mismo número y configuración que en radio_main_screen.dart
    const String phone = '34614126301';
    
    // Crear mensaje personalizado con los datos del formulario
    String message = "🙏 *Petición de Oración*\n\n";
    if (name.isNotEmpty) {
      message += "👤 *Nombre:* $name\n\n";
    }
    message += "📝 *Petición:* $request\n\n";
    message += "Bendiciones...";
    
    // Usar exactamente el mismo método que en radio_main_screen.dart
    await OurSocialContacts.openLink(
      context,
      'whatsapp://send?phone=$phone&text=${Uri.encodeComponent(message)}',
      'https://wa.me/$phone?text=${Uri.encodeComponent(message)}',
      'WhatsApp',
    );
    
    // Mostrar confirmación y limpiar campos
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("🙏 Petición enviada a WhatsApp.")),
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
                const SizedBox(height: 10),                
                // Card de petición de oración
                Center(
                  child: Container(
                    width: width * 0.85,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(color: const Color.fromARGB(255, 141, 59, 59).withOpacity(0.5), width: 1.2),
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
                        Text("Nos unimos a ti en oración.",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: width * 0.06,
                              fontWeight: FontWeight.bold,
                            )),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _nameController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
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
                          decoration: const InputDecoration(
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
                const SizedBox(height: 25),
                // Versículo bíblico
                Container(
                  width: width * 0.85,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(color: const Color.fromARGB(255, 141, 59, 59).withOpacity(0.5), width: 1.2),
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
                    children: [
                      Text(
                        "Estad siempre gozosos. Orad sin cesar. Dad gracias en todo, porque esta es la voluntad de Dios para con vosotros en Cristo Jesús.",
                        style: TextStyle(
                          color : Colors.white70,
                          fontSize: width * 0.042,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "1 Tesalonicenses 5:16-18",
                        style: TextStyle(
                          color: Colors.red.shade300,
                          fontSize: width * 0.038,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
