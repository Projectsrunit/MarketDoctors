import 'package:flutter/material.dart';
import 'package:market_doctor/data_store.dart';
import 'package:provider/provider.dart';

class ChewAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    Map? chewData = Provider.of<DataStore>(context).chewData;

    return AppBar(
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
      automaticallyImplyLeading: false,
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
                    border: Border.all(
                        color: Colors.grey, width: 2), // Black border
                  ),
                  child: ClipOval(
                    child: chewData?['picture_url'] != null
                        ? Image.network(
                            chewData?['picture_url'],
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
                  '${chewData?['firstName']} ${chewData?['lastName']}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black
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
