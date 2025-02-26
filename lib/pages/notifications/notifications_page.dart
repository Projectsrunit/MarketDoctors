import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:market_doctor/data_store.dart';
import 'package:market_doctor/models/notification_item.dart';

class NotificationItem {
  final String title;
  final String message;
  final String timestamp;
  final Map<String, dynamic>? data;

  NotificationItem({
    required this.title,
    required this.message,
    required this.timestamp,
    this.data,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'message': message,
    'timestamp': timestamp,
    'data': data,
  };

  factory NotificationItem.fromJson(Map<String, dynamic> json) => NotificationItem(
    title: json['title'],
    message: json['message'],
    timestamp: json['timestamp'],
    data: json['data'],
  );
}

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  static Future<void> addNotification(NotificationItem notification) async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsJson = prefs.getStringList('notifications') ?? [];
    notificationsJson.insert(0, json.encode(notification.toJson()));
    await prefs.setStringList('notifications', notificationsJson);
  }

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<NotificationItem> notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationsJson = prefs.getStringList('notifications') ?? [];
      setState(() {
        notifications = notificationsJson
            .map((item) => NotificationItem.fromJson(json.decode(item)))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading notifications: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _clearNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('notifications', []);
    setState(() {
      notifications.clear();
    });
  }

  String _formatDateTime(String timestamp) {
    final dateTime = DateTime.parse(timestamp).toLocal();
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      // Today - show time only
      return 'Today at ${DateFormat('h:mm a').format(dateTime)}';
    } else if (difference.inDays == 1) {
      // Yesterday
      return 'Yesterday at ${DateFormat('h:mm a').format(dateTime)}';
    } else if (difference.inDays < 7) {
      // Within a week
      return '${DateFormat('EEEE').format(dateTime)} at ${DateFormat('h:mm a').format(dateTime)}';
    } else {
      // More than a week ago
      return DateFormat('MMM d, y').add_jm().format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (notifications.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Clear All Notifications'),
                    content: const Text('Are you sure you want to clear all notifications?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          _clearNotifications();
                          Navigator.pop(context);
                        },
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : notifications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_off,
                        size: 64,
                        color: isDarkMode ? Colors.white54 : Colors.black54,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No notifications yet',
                        style: TextStyle(
                          fontSize: 18,
                          color: isDarkMode ? Colors.white54 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return Dismissible(
                      key: Key(notification.timestamp),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) async {
                        final prefs = await SharedPreferences.getInstance();
                        final notificationsJson = notifications
                            .where((item) => item.timestamp != notification.timestamp)
                            .map((item) => json.encode(item.toJson()))
                            .toList();
                        await prefs.setStringList('notifications', notificationsJson);
                        setState(() {
                          notifications.removeAt(index);
                        });
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: ListTile(
                          title: Text(
                            notification.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(notification.message),
                              const SizedBox(height: 4),
                              Text(
                                _formatDateTime(notification.timestamp),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDarkMode ? Colors.white54 : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          isThreeLine: true,
                          onTap: () {
                            if (notification.data != null && 
                                notification.data!.containsKey('route')) {
                              Navigator.of(context).pushNamed(
                                notification.data!['route'] as String,
                                arguments: notification.data!['arguments'],
                              );
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
} 