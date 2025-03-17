import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class SubscriptionService {
  static String? baseUrl = dotenv.env['API_URL'];

  static Future<Map<String, dynamic>> checkSubscription(String userId) async {
    try {
      print('Checking subscription for user: $userId'); // Debug log
      var url = Uri.parse('$baseUrl/api/subscriptions/check/$userId');
      var response = await http.get(url);
      print('Check subscription response: ${response.body}'); // Debug log
      return jsonDecode(response.body);
    } catch (e) {
      print('Check subscription error: $e'); // Debug log
      return {'status': 'error', 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> createTrialSubscription(String userId) async {
    try {
      print('Creating trial for user: $userId'); // Debug log
      var url = Uri.parse('$baseUrl/api/subscriptions/trial');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId}),
      );
      print('Trial creation response: ${response.body}'); // Debug log
      return jsonDecode(response.body);
    } catch (e) {
      print('Trial creation error: $e'); // Debug log
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> verifyPayment(String reference) async {
    try {
      print('Verifying payment: $reference'); // Debug log
      var url = Uri.parse('$baseUrl/api/subscriptions/verify-payment');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'reference': reference,
        }),
      );
      print('Payment verification response: ${response.body}'); // Debug log
      return jsonDecode(response.body);
    } catch (e) {
      print('Payment verification error: $e'); // Debug log
      return {'success': false, 'message': e.toString()};
    }
  }
}
