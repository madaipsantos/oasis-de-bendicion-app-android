import 'package:flutter/material.dart';
import 'package:webradiooasis/presentation/screens/church_main_screen.dart';
import 'package:webradiooasis/presentation/screens/church_mission_screen.dart';
import 'package:webradiooasis/presentation/screens/church_vision_screen.dart';
import 'package:webradiooasis/presentation/screens/church_services_screen.dart';
import 'package:webradiooasis/presentation/screens/church_contacts_screen.dart';
import 'package:webradiooasis/presentation/screens/radio_main_screen.dart';
import 'package:webradiooasis/presentation/screens/radio_programs_screen.dart';

/// AppRouter centralizes all navigation routes for the application.
/// This makes routing more maintainable and prepares the app for web and deep linking.
class AppRouter {
  // Route name constants
  static const String home = '/';
  static const String mission = '/mission';
  static const String vision = '/vision';
  static const String services = '/services';
  static const String contacts = '/contacts';
  static const String radio = '/radio';
  static const String radioPrograms = '/radio-programs';

  /// Returns the app's route map for use in MaterialApp
  static Map<String, WidgetBuilder> get routes => {
        home: (context) => const ChurchMainScreen(),
        mission: (context) => const ChurchMissionScreen(),
        vision: (context) => const ChurchVisionScreen(),
        services: (context) => const ChurchServicesScreen(),
        contacts: (context) => const ChurchContactsScreen(),
        radio: (context) => const RadioMainScreen(),
        radioPrograms: (context) => const RadioProgramsScreen(),
      };
}