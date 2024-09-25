import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
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
              // Home Icon and Label
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PatientHome()),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.home, size: 30, color: iconColor),
                    SizedBox(height: 2), // Reduced height for less spacing
                    Text(
                      "Home",
                      style: GoogleFonts.nunito(
                        textStyle: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Health Icon and Label
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HealthTipsPage()),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FaIcon(FontAwesomeIcons.solidHeart,
                        size: 30, color: iconColor),
                    SizedBox(height: 2), // Reduced height
                    Text(
                      "Health",
                      style: GoogleFonts.nunito(
                        textStyle: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Payment Icon and Label
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaymentsMainWidget()),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.credit_card, size: 30, color: iconColor),
                    SizedBox(height: 2), // Reduced height
                    Text(
                      "Payment",
                      style: GoogleFonts.nunito(
                        textStyle: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Contact Icon and Label
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PatientProfilePage(),
                    ),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.chat_bubble, size: 30, color: iconColor),
                    SizedBox(height: 3), // Reduced height for less spacing
                    Text(
                      "Contact",
                      style: GoogleFonts.nunito(
                        textStyle: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Profile Icon and Label
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PatientProfilePage(),
                    ),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.person, size: 30, color: iconColor),
                    SizedBox(height: 2), // Reduced height
                    Text(
                      "Profile",
                      style: GoogleFonts.nunito(
                        textStyle: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
