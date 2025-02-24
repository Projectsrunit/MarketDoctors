// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:market_doctor/pages/doctor/availability_calendar.dart';
import 'package:market_doctor/pages/doctor/doctor_home.dart';
import 'package:market_doctor/pages/doctor/doctors_chats.dart';
import 'package:market_doctor/pages/doctor/profile_page.dart';
import 'package:market_doctor/pages/doctor/upcoming_appointment.dart';

class DoctorBottomNavBar extends StatefulWidget {
  @override
  State<DoctorBottomNavBar> createState() => _DoctorBottomNavBarState();
}

class _DoctorBottomNavBarState extends State<DoctorBottomNavBar> {
  bool isMenuVisible = false;
  bool isPrescriptionExpanded = false;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
                    icon: Icon(
                      Icons.home,
                      size: 36,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DashboardPage()),
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
                    icon: Icon(
                      Icons.business_center,
                      size: 36,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UpcomingAppointmentPage()));
                    },
                  ),
                  Text("Appointments"),
                ],
              ),
              SizedBox(width: 70),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.watch_sharp,
                      size: 36,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AvailabilityCalendar()));
                    },
                  ),
                  Text("Availability"),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.person,
                      size: 36,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DoctorProfilePage()));
                    },
                  ),
                  Text("Profile"),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: -12,
          child: GestureDetector(
            onTap: () {
              setState(() {
                isMenuVisible = !isMenuVisible;
                if (isPrescriptionExpanded) {
                  isPrescriptionExpanded = false;
                }
              });
              Future.delayed(Duration.zero, () {
                showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(100, 600, 100, 100),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  items: [
                    PopupMenuItem(
                      padding: EdgeInsets.zero,
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          Icon(FontAwesomeIcons.whatsapp, color: Colors.orange),
                          SizedBox(width: 10),
                          Text('Chat History'),
                          SizedBox(width: 10),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DoctorsChats(),
                          ),
                        );
                      },
                    ),
                  ],
                ).then((_) {
                  setState(() {
                    isMenuVisible = false;
                  });
                });
              });
            },
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: Container(
                key: ValueKey<bool>(isMenuVisible),
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isMenuVisible ? Icons.arrow_downward : Icons.arrow_upward,
                  size: 40,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
