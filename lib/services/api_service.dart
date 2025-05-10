

// services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order.dart';

class ApiService {
  final String _baseUrl = 'https://uz8if7.buildship.run';

  Future<bool> placeOrder(Order order) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/placeOrder'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(order.toJson()),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        return result == true;
      } else {
        print('API error: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error placing order: $e');
      throw Exception('Failed to place order');
    }
  }
  }
