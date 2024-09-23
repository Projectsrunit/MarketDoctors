import 'package:flutter/material.dart';
import 'package:market_doctor/main.dart';
import 'package:provider/provider.dart';

class PatientAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    Map? patientData = Provider.of<DataStore>(context).patientData;

    return AppBar(
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person),
            ),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                'Hi, ${patientData?['user']['firstName']} ${patientData?['user']['lastName']}!',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 19, // Reduces the size of the text
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 22, 91, 148), // Customize color if needed
                ),
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

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
