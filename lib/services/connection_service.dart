import 'package:http/http.dart' as http;

/// Serviço responsável por checar a conexão com a internet.
class ConnectionService {
  /// Verifica se há conexão com a internet fazendo uma requisição HTTP para o Google.
  /// 
  /// Retorna `true` se o status da resposta for 200 (OK), indicando conexão ativa.
  /// Retorna `false` em caso de erro ou se não houver resposta válida.
  Future<bool> hasConnection() async {
    try {
      // Faz uma requisição GET para o Google.
      final response = await http.get(Uri.parse('https://www.google.com'));
      // Se o status for 200, há conexão.
      return response.statusCode == 200;
    } catch (_) {
      // Em caso de exceção (sem internet, timeout, etc), retorna false.
      return false;
    }
  }
}