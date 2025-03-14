import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class SubscriptionService {
  static String? baseUrl = dotenv.env['API_URL'];

  static Future<Map<String, dynamic>> checkSubscription(String userId) async {
    var url = Uri.parse('$baseUrl/api/subscriptions/check/$userId');
    var response = await http.get(url);
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> createTrialSubscription(String userId) async {
    var url = Uri.parse('$baseUrl/api/subscriptions/trial');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId}),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> verifyPayment(String reference) async {
    var url = Uri.parse('$baseUrl/api/subscriptions/verify-payment');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'reference': reference}),
    );
    return jsonDecode(response.body);
  }
}
