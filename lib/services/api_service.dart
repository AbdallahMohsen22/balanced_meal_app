import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order.dart';

class ApiService {
  final String _baseUrl = 'https://uz8if7.buildship.run';
  final Duration _timeout = const Duration(seconds: 15);

  Future<bool> placeOrder(Order order) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/placeOrder'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(order.toJson()),
      ).timeout(_timeout);

      print('API Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        // Handle the exact response format {"result": true/false}
        return responseData['result'] == true;
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } on TimeoutException {
      throw Exception('Request timed out');
    } catch (e) {
      throw Exception('Failed to place order: $e');
    }
  }
}