import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:webradiooasis/core/utils/our_social_contacts.dart';

// Constants
const String kGeoUrl =
    "geo:43.5322026,-5.6611196?q=Carretera Carbonara, 2227. Gijón, Asturias - España";
const String kGoogleMapsUrl =
    "https://www.google.com/maps/search/?api=1&query=Carretera+Carbonara,+2227,+Gij%C3%B3n,+Asturias+-+Espa%C3%B1a";
const String kChurchAddress = "Carretera Carbonara, 2227. Gijón, Asturias - España";
const String kPhoneNumber = "+34 614 126 301";
const String kPhoneUrl = "tel:+34614126301";
const String kWhatsAppUrl = 'https://wa.me/+34614126301?text=';
const String kWhatsAppAppUrl = 'whatsapp://send?phone=+34614126301&text=';

/// Screen that displays church contacts and social media.
/// Includes address, social media, WhatsApp, and phone contact options.
class ChurchContactsScreen extends StatefulWidget {
  const ChurchContactsScreen({super.key});

  @override
  State<ChurchContactsScreen> createState() => _ChurchContactsScreenState();
}

class _ChurchContactsScreenState extends State<ChurchContactsScreen> {
  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsiveness
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // Card and text style constants
    final double cardRadius = 15.0;
    final double cardBorder = 4.0;
    final double cardTop = screenHeight * 0.03;
    final double cardSide = screenWidth * 0.04;
    final double cardHeight = screenHeight * 0.15;
    final double titleFontSize = 22.0;
    final double textFontSize = 17.0;
    final double textWidth = screenWidth * 0.90;

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
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/back.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Scrollable responsive content
          Positioned(
            top: cardTop,
            left: cardSide,
            right: cardSide,
            bottom: 0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Address and map card
                  _buildServiceCard(
                    title: "Address",
                    imagePath: "assets/mapa.png",
                    description: kChurchAddress,
                    geoUrl: kGeoUrl,
                    googleMapsUrl: kGoogleMapsUrl,
                    cardHeight: cardHeight,
                    cardRadius: cardRadius,
                    cardBorder: cardBorder,
                    titleFontSize: titleFontSize,
                    textFontSize: textFontSize,
                    textWidth: textWidth,
                  ),
                  // Social media card
                  _buildSocialMediaCard(cardRadius: cardRadius),
                  // Contact card (WhatsApp and phone)
                  _buildContactCard(cardRadius: cardRadius),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Card displaying address and map image, clickable to open maps app.
  Widget _buildServiceCard({
    required String title,
    required String imagePath,
    required String geoUrl,
    required String googleMapsUrl,
    required double cardHeight,
    required double cardRadius,
    required double cardBorder,
    required double titleFontSize,
    required double textFontSize,
    required double textWidth,
    String? description,
  }) {
    return Card(
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
            _buildTitle(title, fontSize: titleFontSize),
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
                width: textWidth,
                child: Text(
                  description,
                  style: TextStyle(fontSize: textFontSize, color: Colors.white),
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

  /// Clickable map image, opens maps app or Google Maps in browser.
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

  /// Card with social media buttons (Facebook, Instagram, YouTube, Website).
  Widget _buildSocialMediaCard({required double cardRadius}) {
    return Card(
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
                // Website
                IconButton(
                  onPressed: () async {
                    await OurSocialContacts.openLink(
                      context,
                      'https://www.oasisdebendicion.org/',
                      'https://www.oasisdebendicion.org/',
                      'Website',
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

  /// Card with WhatsApp and phone buttons, and phone number displayed.
  Widget _buildContactCard({required double cardRadius}) {
    return Card(
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
                // WhatsApp button
                _buildIconButton(
                  url: kWhatsAppUrl,
                  appUrl: kWhatsAppAppUrl,
                  icon: MdiIcons.whatsapp,
                  color: Colors.green,
                  iconSize: 40,
                ),
                // Phone button
                IconButton(
                  onPressed: () async {
                    if (await OurSocialContacts.requestPhonePermission()) {
                      await launchUrl(Uri.parse(kPhoneUrl));
                    } else {
                      throw 'Could not launch $kPhoneUrl';
                    }
                  },
                  icon: Icon(MdiIcons.phone),
                  iconSize: 40,
                ),
                const SizedBox(width: 7),
                // Display phone number
                const Text(
                  kPhoneNumber,
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

  /// Generic icon button to open external apps or links (e.g., WhatsApp).
  Widget _buildIconButton({
    required String url,
    required String appUrl,
    required IconData icon,
    required Color color,
    required double iconSize,
  }) {
    return IconButton(
      onPressed: () async {
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

  /// Widget to display centered and styled titles.
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