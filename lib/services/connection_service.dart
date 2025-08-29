import 'package:http/http.dart' as http;

class ConnectionService {
  Future<bool> hasConnection() async {
    try {
      final response = await http.get(Uri.parse('https://www.google.com'));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
