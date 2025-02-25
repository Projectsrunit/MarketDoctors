import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:market_doctor/pages/notifications/notifications_page.dart';
import 'package:shared_preferences.dart';

class NotificationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
      _handleNotificationOpened(event);
    });

    // Set notification received handler for foreground notifications
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      print("Notification received in foreground: ${event.notification.body}");
      // Store the notification
      _storeNotification(event.notification);
      // You can either display the notification or prevent it from being displayed
      event.notification.display(); // This will show the notification
    });
  }

  static Future<void> _storeNotification(OSNotification notification) async {
    final notificationItem = NotificationItem(
      title: notification.title ?? 'Notification',
      message: notification.body ?? '',
      timestamp: DateTime.now().toIso8601String(),
      data: notification.additionalData,
    );
    await NotificationsPage.addNotification(notificationItem);
  }

  static void _handleNotificationOpened(OSNotificationClickEvent event) {
    final data = event.notification.additionalData;
    if (data != null) {
      final String route = data['route'] as String? ?? '/notifications';
      final bool requiresAuth = data['requiresAuth'] as bool? ?? true;
      
      // Store the notification
      _storeNotification(event.notification);

      // Navigate to the appropriate screen
      if (requiresAuth) {
        // Check if user is logged in
        _checkAuthAndNavigate(route);
      } else {
        navigatorKey.currentState?.pushNamed(route);
      }
    } else {
      // Default to notifications page if no data
      navigatorKey.currentState?.pushNamed('/notifications');
    }
  }

  static Future<void> _checkAuthAndNavigate(String route) async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getString('token') != null;

    if (isLoggedIn) {
      navigatorKey.currentState?.pushNamed(route);
    } else {
      // Navigate to login page with return route
      navigatorKey.currentState?.pushNamed('/login', arguments: {'returnRoute': route});
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