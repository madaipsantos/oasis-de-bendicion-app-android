/// Utility class for retrieving app information such as version.

import 'package:package_info_plus/package_info_plus.dart';

/// Provides methods to access application information.
class AppInfo {
  // Stores the app version once loaded.
  static String? _appVersion;

  /// Returns the app version as a [String].
  /// If already loaded, returns the cached value.
  /// Otherwise, fetches from [PackageInfo].
  /// Returns 'Unknown' if an error occurs.
  static Future<String> getAppVersion() async {
    if (_appVersion != null) {
      return _appVersion!;
    }
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      _appVersion = packageInfo.version;
      return _appVersion!;
    } catch (e) {
      // Prints error and returns a default value.
      print('Error retrieving package info: $e');
      return 'Unknown';
    }
  }
}