import 'package:package_info_plus/package_info_plus.dart';

/// Classe utilitária para obter informações do aplicativo, como a versão.
class AppInfo {
  // Variável estática para armazenar a versão uma vez que ela é carregada
  static String? _appVersion;

  /// Método assíncrono para obter a versão do aplicativo.
  /// 
  /// Retorna a versão já armazenada se disponível, evitando múltiplas consultas.
  /// Caso contrário, busca as informações do pacote usando o package_info_plus.
  /// Em caso de erro, retorna 'Desconhecida'.
  static Future<String> getAppVersion() async {
    // Se a versão já foi carregada, retorna-a imediatamente
    if (_appVersion != null) {
      return _appVersion!;
    }

    try {
      // Obtém as informações do pacote (nome, versão, etc)
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      // Armazena e retorna a versão do aplicativo
      _appVersion = packageInfo.version;
      return _appVersion!;
    } catch (e) {
      // Em caso de erro, imprime o erro e retorna uma string indicando o problema
      print('Erro ao obter informações do pacote: $e');
      return 'Desconhecida'; // Ou "Erro ao carregar versão"
    }
  }
}