import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:webradiooasis/utils/our_social_contacts.dart';

/// Tela que exibe os contatos e redes sociais da igreja.
/// Inclui endereço, redes sociais e formas de contato (WhatsApp e telefone).
class ChurchContactsScreen extends StatefulWidget {
  const ChurchContactsScreen({super.key});

  @override
  State<ChurchContactsScreen> createState() => _ChurchContactsScreenState();
}

class _ChurchContactsScreenState extends State<ChurchContactsScreen> {
  // URLs para localização da igreja
  static const String geoUrl =
      "geo:43.5322026,-5.6611196?q=Carretera Carbonara, 2227. Gijón, Asturias - España";
  static const String googleMapsUrl =
      "https://www.google.com/maps/search/?api=1&query=Carretera+Carbonara,+2227,+Gij%C3%B3n,+Asturias+-+Espa%C3%B1a";

  @override
  Widget build(BuildContext context) {
    // Obtém dimensões da tela para responsividade
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // Define tamanhos e estilos dos cards e textos
    final double cardRadius = 15.0;
    final double cardBorder = 4.0;
    final double cardTop = screenHeight * 0.03;
    final double cardSide = screenWidth * 0.04;
    final double cardHeight = screenHeight * 0.15;
    final double tituloFont = 22.0;
    final double textoFont = 17.0;
    final double textoLargura = screenWidth * 0.90;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
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
          // Conteúdo rolável responsivo
          Positioned(
            top: cardTop,
            left: cardSide,
            right: cardSide,
            bottom: 0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Card com endereço e mapa
                  _buildServiceCard(
                    title: "Dirección",
                    imagePath: "assets/mapa.png",
                    description:
                        "Carretera Carbonara, 2227. Gijón, Asturias - España",
                    geoUrl: geoUrl,
                    googleMapsUrl: googleMapsUrl,
                    cardHeight: cardHeight,
                    cardRadius: cardRadius,
                    cardBorder: cardBorder,
                    tituloFont: tituloFont,
                    textoFont: textoFont,
                    textoLargura: textoLargura,
                  ),
                  // Card com redes sociais
                  _buildSocialMediaCard(cardRadius: cardRadius),
                  // Card com contatos (WhatsApp e telefone)
                  _buildContactCard(cardRadius: cardRadius),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Card que exibe o endereço e imagem do mapa, clicável para abrir o app de mapas.
  Widget _buildServiceCard({
    required String title,
    required String imagePath,
    required String geoUrl,
    required String googleMapsUrl,
    required double cardHeight,
    required double cardRadius,
    required double cardBorder,
    required double tituloFont,
    required double textoFont,
    required double textoLargura,
    String? description,
  }) {
    return Card(
      // ignore: deprecated_member_use
      color: Colors.black.withOpacity(0.01),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
      ),
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _buildTitle(title, fontSize: tituloFont),
            const SizedBox(height: 5),
            _buildClickableImageCard(
              imagePath,
              geoUrl,
              googleMapsUrl,
              cardHeight,
              cardRadius,
              cardBorder,
            ),
            if (description != null) ...[
              const SizedBox(height: 10),
              SizedBox(
                width: textoLargura,
                child: Text(
                  description,
                  style: TextStyle(fontSize: textoFont, color: Colors.white),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Imagem do mapa clicável, abre o app de mapas ou Google Maps no navegador.
  Widget _buildClickableImageCard(
    String imagePath,
    String geoUrl,
    String googleMapsUrl,
    double cardHeight,
    double cardRadius,
    double cardBorder,
  ) {
    return GestureDetector(
      onTap: () async {
        // Tenta abrir o app de mapas, se não conseguir, abre o Google Maps no navegador
        if (await canLaunchUrl(Uri.parse(geoUrl))) {
          await launchUrl(Uri.parse(geoUrl));
        } else if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
          await launchUrl(Uri.parse(googleMapsUrl));
        } else {
          throw 'Could not launch $geoUrl or $googleMapsUrl';
        }
      },
      child: Container(
        width: double.infinity,
        height: cardHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(cardRadius),
          border: Border.all(
            color: const Color.fromARGB(255, 141, 59, 59),
            width: cardBorder,
          ),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  /// Card com botões para redes sociais (Facebook, Instagram, YouTube, Site).
  Widget _buildSocialMediaCard({required double cardRadius}) {
    return Card(
      // ignore: deprecated_member_use
      color: Colors.black.withOpacity(0.01),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
      ),
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Facebook
                IconButton(
                  onPressed: () async {
                    await OurSocialContacts.openLink(
                      context,
                      'fb://profile/100064817646055',
                      'https://www.facebook.com/profile.php?id=100064817646055',
                      'Facebook',
                    );
                  },
                  icon: Icon(MdiIcons.facebook),
                  iconSize: 45,
                  color: Colors.blue,
                ),
                // Instagram
                IconButton(
                  onPressed: () async {
                    await OurSocialContacts.openLink(
                      context,
                      'instagram://user?username=oasisdebendiciongijon',
                      'https://www.instagram.com/oasisdebendiciongijon/',
                      'Instagram',
                    );
                  },
                  icon: Icon(MdiIcons.instagram),
                  iconSize: 45,
                  color: Colors.pink,
                ),
                // YouTube
                IconButton(
                  onPressed: () async {
                    await OurSocialContacts.openLink(
                      context,
                      'vnd.youtube://www.youtube.com/@oasisdebendiciongijon',
                      'https://www.youtube.com/@oasisdebendiciongijon',
                      'YouTube',
                    );
                  },
                  icon: Icon(MdiIcons.youtube),
                  iconSize: 55,
                  color: Colors.red,
                ),
                // Site
                IconButton(
                  onPressed: () async {
                    await OurSocialContacts.openLink(
                      context,
                      'https://www.oasisdebendicion.org/',
                      'https://www.oasisdebendicion.org/',
                      'Site',
                    );
                  },
                  icon: Icon(MdiIcons.web),
                  iconSize: 45,
                  color: Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Card com botões de contato (WhatsApp e telefone) e número exibido.
  Widget _buildContactCard({required double cardRadius}) {
    return Card(
      // ignore: deprecated_member_use
      color: Colors.black.withOpacity(0.01),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
      ),
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Botão WhatsApp
                _buildIconButton(
                  url: 'https://wa.me/+34614126301?text=',
                  appUrl: 'whatsapp://send?phone=+34614126301&text=',
                  icon: MdiIcons.whatsapp,
                  color: Colors.green,
                  iconSize: 40,
                ),
                // Botão Telefone
                IconButton(
                  onPressed: () async {
                    const phoneUrl = 'tel:+34614126301';
                    if (await OurSocialContacts.requestPhonePermission()) {
                      await launchUrl(Uri.parse(phoneUrl));
                    } else {
                      throw 'Could not launch $phoneUrl';
                    }
                  },
                  icon: Icon(MdiIcons.phone),
                  iconSize: 40,
                ),
                const SizedBox(width: 7),
                // Exibe o número de telefone
                const Text(
                  "+34 614 126 301",
                  style: TextStyle(fontSize: 22, color: Colors.white),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Botão genérico para abrir apps ou links externos (ex: WhatsApp).
  Widget _buildIconButton({
    required String url,
    required String appUrl,
    required IconData icon,
    required Color color,
    required double iconSize,
  }) {
    return IconButton(
      onPressed: () async {
        // Tenta abrir o app, se não conseguir, tenta o link web
        if (await canLaunchUrl(Uri.parse(appUrl))) {
          await launchUrl(
            Uri.parse(appUrl),
            mode: LaunchMode.externalApplication,
          );
        } else if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        } else {
          throw 'Could not launch $url';
        }
      },
      icon: Icon(icon),
      iconSize: iconSize,
      color: color,
    );
  }

  /// Widget para exibir títulos centralizados e estilizados.
  Widget _buildTitle(String text, {double fontSize = 20, bool isBold = true}) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: Colors.white,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}