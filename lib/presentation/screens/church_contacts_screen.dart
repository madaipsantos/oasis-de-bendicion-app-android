import 'package:flutter/material.dart';
// Importação simulada para ícones de redes sociais (em um projeto real, você usaria 'font_awesome_flutter')
// Usaremos os ícones padrões do Material para manter a compatibilidade no Canvas.

// Constantes copiadas da tela principal para garantir a consistência
const Color kCardColor = Color.fromARGB(255, 141, 59, 59); // Cor principal
const Color kButtonColor = Colors.red;
const double kScreenPadding = 20.0;
const double kCardBorderRadius = 10.0; // Mantendo o valor do layout base (10.0)

/// Tela dedicada aos Contatos e Redes Sociais da Igreja.
class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Contato e Redes",
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
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.055),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(bottom: 15),
                    child: Text(
                      "Contactos",
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
                  // 1. CARTÃO DE INFORMAÇÕES DE CONTATO
                  // -----------------------------------------------------------
                  _buildContactInfoCard(screenWidth, context),
                  
                  const SizedBox(height: 30),

                  // -----------------------------------------------------------
                  // 2. TÍTULO REDES SOCIAIS
                  // -----------------------------------------------------------
                  Text(
                    "Síguenos en las redes sociales.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // -----------------------------------------------------------
                  // 3. BOTÕES DE REDES SOCIAIS
                  // -----------------------------------------------------------
                  _buildSocialMediaButtons(context),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói o cartão principal com telefone e email.
  Widget _buildContactInfoCard(double screenWidth, BuildContext context) {
    return Container(
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
        children: [
          // Telefone (Simulando ligação direta)
          _buildContactRow(
            icon: Icons.phone,
            label: "Telefone (Ligação):",
            value: "(XX) XXXX-XXXX",
            actionText: "Ligar",
            onTap: () => _showSnackBar(context, "Abrindo discador para (XX) XXXX-XXXX"),
            screenWidth: screenWidth,
          ),
          const Divider(color: Colors.white24, height: 25), // Divisor após Ligar
          // WhatsApp (Simulando envio de mensagem) - NOVO!
          _buildContactRow(
            icon: Icons.chat_bubble_outline, // Ícone de chat para WhatsApp
            label: "WhatsApp (Mensagem):",
            value: "(XX) XXXX-XXXX",
            actionText: "Mensagem",
            onTap: () => _showSnackBar(context, "Abrindo WhatsApp para enviar mensagem..."),
            screenWidth: screenWidth,
          ),
          const Divider(color: Colors.white24, height: 25), // Divisor antes do Email
          // Email (Simulando envio de email)
          _buildContactRow(
            icon: Icons.email,
            label: "E-mail:",
            value: "contato@suaigreja.com.br",
            actionText: "Enviar Email",
            onTap: () => _showSnackBar(context, "Abrindo cliente de e-mail..."),
            screenWidth: screenWidth,
          ),
        ],
      ),
    );
  }

  /// Constrói uma linha de contato individual com ação.
  Widget _buildContactRow({
    required IconData icon,
    required String label,
    required String value,
    required String actionText,
    required VoidCallback onTap,
    required double screenWidth,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: kButtonColor, size: screenWidth * 0.06),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: screenWidth * 0.035,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            foregroundColor: kButtonColor,
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
          ),
          child: Text(
            actionText,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  /// Constrói a seção de botões de redes sociais.
  Widget _buildSocialMediaButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Botão Instagram
        _buildSocialButton(
          icon: Icons.photo_camera, // Placeholder para Instagram
          label: "Instagram",
          color: const Color(0xFFC13584), // Cor simulada do Instagram
          onTap: () => _showSnackBar(context, "Abrindo Instagram..."),
        ),
        // Botão Facebook
        _buildSocialButton(
          icon: Icons.facebook, // Placeholder para Facebook
          label: "Facebook",
          color: const Color(0xFF4267B2), // Cor simulada do Facebook
          onTap: () => _showSnackBar(context, "Abrindo Facebook..."),
        ),
        // Botão YouTube
        _buildSocialButton(
          icon: Icons.video_library, // Placeholder para YouTube
          label: "YouTube",
          color: const Color(0xFFFF0000), // Cor simulada do YouTube
          onTap: () => _showSnackBar(context, "Abrindo Canal do YouTube..."),
        ),
      ],
    );
  }

  /// Constrói um botão de rede social quadrado.
  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(kCardBorderRadius),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: color.withOpacity(0.8),
              borderRadius: BorderRadius.circular(kCardBorderRadius),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 36),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
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
