import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class OurSocialContacts {
  static Future<void> openLink(
    BuildContext context,
    String appUrl,
    String webUrl,
    String nomeApp,
  ) async {
    if (await canLaunchUrl(Uri.parse(appUrl))) {
      await launchUrl(Uri.parse(appUrl), mode: LaunchMode.externalApplication);
    } else if (await canLaunchUrl(Uri.parse(webUrl))) {
      await launchUrl(Uri.parse(webUrl), mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text('Erro'),
                content: Text('Não foi possível abrir o $nomeApp.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              ),
        );
      }
    }
  }

  static Future<bool> requestPhonePermission() async {
    if (await Permission.phone.isGranted) {
      return true;
    } else {
      final status = await Permission.phone.request();
      return status == PermissionStatus.granted;
    }
  }

  static Future<void> petitionPrayer(BuildContext context) async {
    final String message = "Bendiciones...";
    final String telefone = '+34614126301';
    final whatsappApp =
        'whatsapp://send?phone=$telefone&text=${Uri.encodeComponent(message)}';
    final whatsappUrl =
        'https://wa.me/$telefone?text=${Uri.encodeComponent(message)}';

    if (await canLaunchUrl(Uri.parse(whatsappApp))) {
      await launchUrl(
        Uri.parse(whatsappApp),
        mode: LaunchMode.externalApplication,
      );
    } else if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(
        Uri.parse(whatsappUrl),
        mode: LaunchMode.externalApplication,
      );
    } else {
      if (context.mounted) {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Erro'),
                content: const Text('Não foi possível abrir o WhatsApp.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              ),
        );
      }
    }
  }
}
