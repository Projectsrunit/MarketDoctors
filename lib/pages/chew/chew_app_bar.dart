import 'package:flutter/material.dart';
import 'package:market_doctor/main.dart';
import 'package:provider/provider.dart';

class ChewAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    Map? chewData = Provider.of<DataStore>(context).chewData;
  // if (chewData == null) {
  //   print('chewdata is null');
  // }

    return AppBar(
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.ac_unit),
            ),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                '${chewData?['user']['firstName']} ${chewData?['user']['lastName']}',
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

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
