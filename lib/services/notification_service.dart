import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NotificationService {
  static Future<void> initializeNotifications() async {
    // Initialize OneSignal
    OneSignal.initialize(dotenv.env['ONESIGNAL_APP_ID'] ?? '');
    
    // Request permission
    await OneSignal.Notifications.requestPermission(true);
  }

  static Future<void> setExternalUserId(String userId) async {
    await OneSignal.login(userId);
  }

  static Future<void> setUserTags(Map<String, dynamic> tags) async {
    await OneSignal.User.addTags(tags);
  }

  static Future<void> removeUserTags(List<String> tagKeys) async {
    await OneSignal.User.removeTags(tagKeys);
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