import 'package:flutter/material.dart';

AppBar doctorAppBar() {
  return AppBar(
    automaticallyImplyLeading: false, // Disable back button
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.person_2_rounded, color: Colors.black),
              onPressed: () {}, // Clock action
            ),
            const SizedBox(width: 8),
            const Text('@user',
                style: TextStyle(color: Colors.black, fontSize: 15)),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.access_time_outlined, color: Colors.black),
              onPressed: () {}, // Clock action
            ),
            IconButton(
              icon: const Icon(Icons.notification_add_outlined,
                  color: Colors.black),
              onPressed: () {}, // Notification action
            ),
          ],
        ),
      ],
    ),
  );
}
