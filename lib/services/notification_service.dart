import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationService {
  static Future<void> initializeNotifications() async {
    // Initialize OneSignal
    OneSignal.initialize('69587fc7-f7c9-4119-acf4-c632d8646c01');
    
    // Enable notifications
    OneSignal.Notifications.clearAll();
    
    // Request permission
    final accepted = await OneSignal.Notifications.requestPermission(true);
    print("Accepted permission: $accepted");

    // Set notification opened handler
    OneSignal.Notifications.addClickListener((event) {
      print("Notification clicked: ${event.notification.body}");
      // Handle notification tap here
      _handleNotificationOpened(event);
    });

    // Set notification received handler
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      print("Notification received in foreground: ${event.notification.body}");
      // You can either display the notification or prevent it from being displayed
      event.display(); // This will show the notification
    });
  }

  static void _handleNotificationOpened(OSNotificationClickEvent event) {
    // Handle the notification click based on the notification data
    final data = event.notification.additionalData;
    if (data != null) {
      final String? type = data['type'] as String?;
      final String? targetScreen = data['targetScreen'] as String?;
      
      // Handle navigation or other actions based on the notification data
      print('Notification type: $type, target screen: $targetScreen');
      // TODO: Implement navigation logic here
    }
  }

  static Future<void> setExternalUserId(String userId) async {
    await OneSignal.login(userId);
  }

  static Future<String?> getPlayerId() async {
    final deviceState = await OneSignal.User.pushSubscription;
    return deviceState.id;
  }

  static Future<void> updatePlayerIdForUser(String userId) async {
    try {
      final playerId = await getPlayerId();
      if (playerId != null) {
        final baseUrl = dotenv.env['API_URL']!;
        final response = await http.post(
          Uri.parse('$baseUrl/api/notifications/update-player-id'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'userId': userId,
            'playerId': playerId,
          }),
        );

        if (response.statusCode != 200) {
          throw Exception('Failed to update player ID: ${response.body}');
        }
        
        print('Successfully updated OneSignal player ID');
      }
    } catch (e) {
      print('Failed to update OneSignal player ID: $e');
      throw e;
    }
  }

  static Future<void> setUserTags(Map<String, dynamic> tags) async {
    await OneSignal.User.addTags(tags);
  }

  static Future<void> setUserType(String userType) async {
    await setUserTags({
      'user_type': userType.toLowerCase(), // 'doctor', 'patient', or 'chew'
    });
  }

  static Future<void> removeUserTags(List<String> tagKeys) async {
    await OneSignal.User.removeTags(tagKeys);
  }

  static Future<void> handleLogin(String userId, String userType) async {
    await setExternalUserId(userId);
    await setUserType(userType);
    await updatePlayerIdForUser(userId);
  }

  static Future<void> handleLogout() async {
    await OneSignal.logout();
    await removeUserTags(['user_type']);
  }

  static Future<void> sendNotification({
    required String heading,
    required String content,
    required List<String> playerIds,
    Map<String, dynamic>? additionalData,
  }) async {
    // For sending notifications, you'll need to use the OneSignal REST API
    // or your backend server to send notifications
    throw UnimplementedError(
      'Sending notifications directly from the app is not supported. '
      'Please implement this using your backend server with the OneSignal REST API.'
    );
  }

  static Future<void> sendNotificationBySegment({
    required String heading,
    required String content,
    required String segment,
    Map<String, dynamic>? additionalData,
  }) async {
    // For sending notifications, you'll need to use the OneSignal REST API
    // or your backend server to send notifications
    throw UnimplementedError(
      'Sending notifications directly from the app is not supported. '
      'Please implement this using your backend server with the OneSignal REST API.'
    );
  }
}