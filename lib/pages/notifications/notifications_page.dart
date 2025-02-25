import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:market_doctor/data_store.dart';

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

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsJson = prefs.getStringList('notifications') ?? [];
    setState(() {
      notifications = notificationsJson
          .map((item) => NotificationItem.fromJson(json.decode(item)))
          .toList();
    });
  }

  Future<void> _saveNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsJson = notifications
        .map((item) => json.encode(item.toJson()))
        .toList();
    await prefs.setStringList('notifications', notificationsJson);
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () async {
              setState(() {
                notifications.clear();
              });
              await _saveNotifications();
            },
          ),
        ],
      ),
      body: notifications.isEmpty
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
                    setState(() {
                      notifications.removeAt(index);
                    });
                    await _saveNotifications();
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
                            DateTime.parse(notification.timestamp)
                                .toLocal()
                                .toString()
                                .split('.')[0],
                            style: TextStyle(
                              fontSize: 12,
                              color: isDarkMode ? Colors.white54 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      isThreeLine: true,
                    ),
                  ),
                );
              },
            ),
    );
  }
} 