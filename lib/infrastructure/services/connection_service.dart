/// Service responsible for checking internet connectivity.
/// Makes an HTTP request to verify active connection.
library;

import 'package:http/http.dart' as http;
import 'package:webradiooasis/core/exceptions/connection_exception.dart';

// Constants
const String kTestUrl = 'https://www.google.com';

/// Checks for an active internet connection by making an HTTP request.
class ConnectionService {
  /// Returns `true` if the device has an active internet connection.
  /// Performs a GET request to [kTestUrl] and checks for a 200 OK response.
  /// Returns `false` if an exception occurs or the response is not valid.
  /// 
  /// Throws a [ConnectionException] if an error occurs during the process.
  Future<bool> hasConnection() async {
    try {
      final response = await http.get(Uri.parse(kTestUrl));
      return response.statusCode == 200;
    } catch (e, stackTrace) {
      throw ConnectionException(
        'Failed to check internet connection',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}