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