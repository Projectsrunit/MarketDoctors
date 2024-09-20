import 'package:flutter/material.dart';

AppBar patientAppBar(String patientName) {
  return AppBar(
    automaticallyImplyLeading: false,
    title: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.person),
          ),
          SizedBox(width: 6),
          Flexible(
            child: Text(
              patientName, // Use the patient name here
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: IconButton(
          icon: Icon(Icons.notifications),
          onPressed: () {},
        ),
      ),
    ],
  );
}
