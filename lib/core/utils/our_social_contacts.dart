/// Utility class for interactions with app social networks and contacts.
/// Provides methods to open links, request phone permissions, and send WhatsApp messages.

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../exceptions/social_contacts_exception.dart';

/// Provides methods for social and contact interactions.
class OurSocialContacts {
  /// Attempts to open an app link [appUrl], or falls back to [webUrl] if unavailable.
  /// Shows an alert if neither can be opened.
  ///
  /// Throws a [SocialContactsException] if an error occurs during the process.
  static Future<void> openLink(
    BuildContext context,
    String appUrl,
    String webUrl,
    String appName,
  ) async {
    try {
      if (await canLaunchUrl(Uri.parse(appUrl))) {
        await launchUrl(Uri.parse(appUrl), mode: LaunchMode.externalApplication);
      } else if (await canLaunchUrl(Uri.parse(webUrl))) {
        await launchUrl(Uri.parse(webUrl), mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Erro'),
              content: Text('Não foi possível abrir o $appName.'),
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
    } catch (e, stackTrace) {
      throw SocialContactsException(
        'Failed to open link for $appName',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Requests permission to make phone calls.
  /// Returns true if permission is granted.
  /// 
  /// Throws a [SocialContactsException] if an error occurs during the process.
  static Future<bool> requestPhonePermission() async {
    try {
      if (await Permission.phone.isGranted) {
        return true;
      } else {
        final status = await Permission.phone.request();
        return status == PermissionStatus.granted;
      }
    } catch (e, stackTrace) {
      throw SocialContactsException(
        'Failed to request phone permission',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Opens WhatsApp to send a prayer request message.
  /// Tries to open the app, falls back to the web link if needed.
  /// Shows an alert if neither can be opened.
  ///
  /// Throws a [SocialContactsException] if an error occurs during the process.
  static Future<void> petitionPrayer(BuildContext context) async {
    try {
      const String message = "Bendiciones...";
      const String phone = '+34614126301';
      final String whatsappApp =
          'whatsapp://send?phone=$phone&text=${Uri.encodeComponent(message)}';
      final String whatsappUrl =
          'https://wa.me/$phone?text=${Uri.encodeComponent(message)}';

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
    } catch (e, stackTrace) {
      throw SocialContactsException(
        'Failed to send WhatsApp petition prayer',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}