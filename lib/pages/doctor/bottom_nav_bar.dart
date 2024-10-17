// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
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
               Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.message,
                      size: 36,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DoctorsChats()));
                    },
                  ),
                  Text("Chat"),
                ],
              ),
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
        
      ],
    );
  }
}
