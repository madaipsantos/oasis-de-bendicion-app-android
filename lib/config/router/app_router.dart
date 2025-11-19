import 'package:flutter/material.dart';
import 'package:webradiooasis/presentation/screens/church_location_screen.dart';
import 'package:webradiooasis/presentation/screens/church_main_screen.dart';
import 'package:webradiooasis/presentation/screens/church_prayer_request_screen.dart';
import 'package:webradiooasis/presentation/screens/church_vision_mission_screen.dart';
import 'package:webradiooasis/presentation/screens/church_services_screen.dart';
import 'package:webradiooasis/presentation/screens/church_contacts_screen.dart';
import 'package:webradiooasis/presentation/screens/cult_transmission_screen.dart';
import 'package:webradiooasis/presentation/screens/radio_contacts_screen.dart';
import 'package:webradiooasis/presentation/screens/radio_main_screen.dart';
import 'package:webradiooasis/presentation/screens/radio_programs_screen.dart';

/// AppRouter centralizes all navigation routes for the application.
/// This makes routing more maintainable and prepares the app for web and deep linking.
class AppRouter {
  // Route name constants
  static const String home = '/';
  static const String visionAndMission = '/visionAndMission';
  static const String services = '/services';
  static const String contacts = '/contacts';
  static const String radio = '/radio';
  static const String radioPrograms = '/radio-programs';
  static const String cultTransmissions = '/cult-transmissions';
  static const String location = '/location';
  static const String prayerRequests = '/prayer-requests';
  static const String contactsRadio = '/contacts-radio';

  /// Returns the app's route map for use in MaterialApp
  static Map<String, WidgetBuilder> get routes => {
        home: (context) => const ChurchMainScreen(),
        visionAndMission: (context) => const VisionMissionScreen(),
        services: (context) => const ChurchServicesScreen(),
        contacts: (context) => const ContactScreen(),
        radio: (context) => const RadioMainScreen(),
        radioPrograms: (context) => const RadioProgramsScreen(),
        cultTransmissions: (context) => const CultTransmissionsScreen(),
        location: (context) => const LocationScreen(),
        prayerRequests: (context) => const PrayerRequestScreen(),
        contactsRadio: (context) => const ContactsRadioScreen(),
      };
}