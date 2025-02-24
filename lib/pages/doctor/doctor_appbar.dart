import 'package:flutter/material.dart';
import 'package:market_doctor/data_store.dart';
import 'package:provider/provider.dart';

class DoctorAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    Map? doctorData = Provider.of<DataStore>(context).doctorData;

    return AppBar(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : Colors.white,
      automaticallyImplyLeading: false,
      elevation: 5,
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 20, // Adjust radius as needed
              child: Container(
                width: 112,
                height: 112,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: Colors.grey, width: 2), // Black border
                ),
                child: ClipOval(
                  child: doctorData?['picture_url'] != null
                      ? Image.network(
                          doctorData?['picture_url'],
                          width: 112,
                          height: 120,
                          fit: BoxFit.cover,
                        )
                      : Icon(Icons.person),
                ),
              ),
            ),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                '${doctorData?['firstName']} ${doctorData?['lastName']}',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
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
        // ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
