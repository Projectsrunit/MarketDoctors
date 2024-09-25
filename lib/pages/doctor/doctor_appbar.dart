import 'package:flutter/material.dart';

AppBar doctorAppBar({required String firstName, required String lastName  }) {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: Colors.white,
    elevation: 0,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.person_2_rounded, color: Colors.black),
              onPressed: () {}, // Profile action
            ),
            const SizedBox(width: 10), // Add some space between avatar and text
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Hello, ',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  TextSpan(
                    text: '$firstName $lastName!',
                    style: const TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Action Buttons on the Right (Notifications, Time, and More options)
        // Action Buttons on the Right (Notifications, Time, and More options)
        Row(
          children: [
            // Time/Clock Icon
            IconButton(
              icon: const Icon(Icons.access_time_outlined, color: Colors.black),
              onPressed: () {
                // Add desired clock action
              },
            ),
            // Notification Icon
            IconButton(
              icon: const Icon(Icons.notifications_none_outlined,
                  color: Colors.black),
              onPressed: () {
                // Add desired notification action
              },
            ),
            // Popup menu for additional actions (e.g., settings, logout)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.black),
              onSelected: (value) {
                if (value == 'Settings') {
                  // Navigate to the Profile Page when 'Settings' is selected
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => ProfilePage()),
                  // );
                } else if (value == 'Logout') {
                  // Log out user
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'Settings',
                  child: Text('Settings'),
                ),
                const PopupMenuItem(
                  value: 'Logout',
                  child: Text('Logout'),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}
