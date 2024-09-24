import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:market_doctor/pages/patient/payments_main_widget.dart';
import 'package:market_doctor/pages/patient/profile_page.dart';
import 'package:market_doctor/pages/patient/health_tips.dart';
import 'package:market_doctor/pages/patient/patient_home.dart';

class PatientBottomNavBar extends StatefulWidget {
  @override
  State<PatientBottomNavBar> createState() => _PatientBottomNavBarState();
}

class _PatientBottomNavBarState extends State<PatientBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color iconColor = Colors.blue; // Use predefined Colors.blue

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.black : Colors.grey[300],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.home, size: 30, color: iconColor),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PatientHome()),
                      );
                    },
                  ),
                  Text("Home"),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: FaIcon(FontAwesomeIcons.solidHeart,
                        size: 30, color: iconColor),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HealthTipsPage()));
                    },
                  ),
                  Text("Health"),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.credit_card,
                        size: 30, color: iconColor),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PaymentsMainWidget()));
                    },
                  ),
                  Text("Payment"),
                ],
              ),
            
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.chat_bubble, size: 30, color: iconColor),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PatientProfilePage()));
                    },
                  ),
                  Text("Contact"),
                ],
              ),

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.person, size: 30, color: iconColor),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PatientProfilePage()));
                    },
                  ),
                  Text("Profile"),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
