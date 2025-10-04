import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

/// Classe utilitária para interações com redes sociais e contatos do app.
class OurSocialContacts {
  /// Tenta abrir um link de aplicativo (appUrl) ou, se não disponível, o link web (webUrl).
  /// Exibe um alerta caso nenhum dos dois possa ser aberto.
  static Future<void> openLink(
    BuildContext context,
    String appUrl,
    String webUrl,
    String nomeApp,
  ) async {
    // Tenta abrir o link do aplicativo
    if (await canLaunchUrl(Uri.parse(appUrl))) {
      await launchUrl(Uri.parse(appUrl), mode: LaunchMode.externalApplication);
    }
    // Se não conseguir, tenta abrir o link web
    else if (await canLaunchUrl(Uri.parse(webUrl))) {
      await launchUrl(Uri.parse(webUrl), mode: LaunchMode.externalApplication);
    }
    // Se não conseguir nenhum, exibe um alerta de erro
    else {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
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

  /// Solicita permissão para realizar chamadas telefônicas.
  /// Retorna true se a permissão for concedida.
  static Future<bool> requestPhonePermission() async {
    if (await Permission.phone.isGranted) {
      return true;
    } else {
      final status = await Permission.phone.request();
      return status == PermissionStatus.granted;
    }
  }

  /// Abre o WhatsApp para enviar uma mensagem de petição de oração.
  /// Tenta abrir o app, se não conseguir, tenta o link web.
  /// Exibe um alerta se não for possível abrir nenhum.
  static Future<void> petitionPrayer(BuildContext context) async {
    final String message = "Bendiciones...";
    final String telefone = '+34614126301';
    final whatsappApp =
        'whatsapp://send?phone=$telefone&text=${Uri.encodeComponent(message)}';
    final whatsappUrl =
        'https://wa.me/$telefone?text=${Uri.encodeComponent(message)}';

    // Tenta abrir o WhatsApp pelo app
    if (await canLaunchUrl(Uri.parse(whatsappApp))) {
      await launchUrl(
        Uri.parse(whatsappApp),
        mode: LaunchMode.externalApplication,
      );
    }
    // Se não conseguir, tenta abrir pelo navegador
    else if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(
        Uri.parse(whatsappUrl),
        mode: LaunchMode.externalApplication,
      );
    }
    // Se não conseguir nenhum, exibe um alerta de erro
    else {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
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