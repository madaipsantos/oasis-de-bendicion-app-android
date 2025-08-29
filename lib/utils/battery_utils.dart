import 'package:flutter/material.dart';
import 'package:disable_battery_optimizations_latest/disable_battery_optimizations_latest.dart';

class BatteryUtils {
  static Future<void> handleBatteryOptimization(BuildContext context) async {
    final isDisabled =
        await DisableBatteryOptimizationLatest.isBatteryOptimizationDisabled;
    if (isDisabled == true) return;

    final shouldOpenSettings = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Aviso importante", textAlign: TextAlign.center),
        content: const Text(
          "Para que la radio siga sonando incluso con la pantalla apagada, desactiva la optimización de batería para esta aplicación en la próxima pantalla.",
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("No, gracias"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 94, 39, 34), // cor de destaque
              foregroundColor: Colors.white,
              textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 5),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Abrir configuração"),
          ),
        ],
      ),
    );

    if (shouldOpenSettings == true) {
      await DisableBatteryOptimizationLatest.showDisableBatteryOptimizationSettings();
    }
  }
}