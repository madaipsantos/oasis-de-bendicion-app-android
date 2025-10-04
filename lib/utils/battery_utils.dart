import 'package:flutter/material.dart';
import 'package:disable_battery_optimizations_latest/disable_battery_optimizations_latest.dart';

/// Classe utilitária para lidar com otimização de bateria no Android.
/// Exibe um alerta para o usuário desativar a otimização de bateria,
/// garantindo que o áudio continue tocando em segundo plano.
class BatteryUtils {
  /// Solicita ao usuário para desativar a otimização de bateria, se necessário.
  /// 
  /// - Verifica se a otimização já está desativada.
  /// - Se não estiver, exibe um diálogo explicativo.
  /// - Se o usuário aceitar, abre as configurações do sistema.
  static Future<void> handleBatteryOptimization(BuildContext context) async {
    // Verifica se a otimização de bateria já está desativada.
    final isDisabled =
        await DisableBatteryOptimizationLatest.isBatteryOptimizationDisabled;
    if (isDisabled == true) return;

    // Exibe um diálogo solicitando ao usuário abrir as configurações.
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
            style: TextButton.styleFrom( // Estilo do botão "Não, obrigado"
              textStyle: TextStyle(fontSize: 12),
            ),
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("No, gracias"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom( // Estilo do botão "Abrir configuração"
              textStyle: TextStyle(fontSize: 12),
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Abrir configuración"),
          ),
        ],
      ),
    );

    // Se o usuário aceitou, abre as configurações do sistema.
    if (shouldOpenSettings == true) {
      await DisableBatteryOptimizationLatest.showDisableBatteryOptimizationSettings();
    }
  }
}