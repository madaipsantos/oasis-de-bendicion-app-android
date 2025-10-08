/// Utility class for handling battery optimization on Android.
/// Shows an alert to prompt the user to disable battery optimization,
/// ensuring audio continues playing in the background.

import 'package:flutter/material.dart';
import 'package:disable_battery_optimizations_latest/disable_battery_optimizations_latest.dart';
import '../exceptions/battery_exception.dart';

/// Provides methods to manage battery optimization settings.
class BatteryUtils {
  /// Prompts the user to disable battery optimization if necessary.
  ///
  /// - Checks if battery optimization is already disabled.
  /// - If not, displays an explanatory dialog.
  /// - If the user accepts, opens the system settings.
  /// 
  /// Throws a [BatteryException] if an error occurs during the process.
  static Future<void> handleBatteryOptimization(BuildContext context) async {
    try {
      // Check if battery optimization is already disabled.
      final isDisabled =
          await DisableBatteryOptimizationLatest.isBatteryOptimizationDisabled;
      if (isDisabled == true) return;

      // Show a dialog prompting the user to open settings.
      final shouldOpenSettings = await showDialog<bool>(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Important Notice", textAlign: TextAlign.center),
        content: const Text(
          "Para que la radio siga sonando incluso con la pantalla apagada, desactiva la optimización de batería para esta aplicación en la próxima pantalla.",
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              textStyle: TextStyle(fontSize: 12),
            ),
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("No, gracias"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              textStyle: TextStyle(fontSize: 12),
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Abrir configuración"),
          ),
        ],
      ),
    );

    // If the user accepted, open the system settings.
    if (shouldOpenSettings == true) {
      await DisableBatteryOptimizationLatest.showDisableBatteryOptimizationSettings();
    }
    } catch (e, stackTrace) {
      // Throw a custom exception with details about the error
      throw BatteryException(
        'Failed to handle battery optimization',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}