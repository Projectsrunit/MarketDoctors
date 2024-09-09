import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:market_doctor/pages/chew/cases_page.dart';
import 'package:market_doctor/pages/chew/chew_home.dart';
import 'package:market_doctor/pages/chew/payments_main_widget.dart';
import 'package:market_doctor/pages/chew/profile_page.dart';

class BottomNavBar extends StatefulWidget {
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  bool isMenuVisible = false;

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
                    icon: Icon(Icons.home, size: 36, color: Colors.blue),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChewHome()),
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
                    icon: Icon(Icons.business_center, size: 36, color: Colors.blue),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => CasesPage()));
                    },
                  ),
                  Text("Cases"),
                ],
              ),
              
              SizedBox(width: 70),

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.credit_card, size: 36, color: Colors.blue),
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
                    icon: Icon(Icons.person, size: 36, color: Colors.blue),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage()));
                    },
                  ),
                  Text("Profile"),
                ],
              ),
            ],
          ),
        ),
        // Positioned arrow button in the center
        Positioned(
          top: -12,
          child: GestureDetector(
            onTap: () {
              setState(() {
                isMenuVisible = !isMenuVisible;
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
                      child: Row(
                        children: [
                          Icon(Icons.add, color: Colors.blue),
                          SizedBox(width: 10),
                          Text('Add a case'),
                        ],
                      ),
                      onTap: () {},
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.medication, color: Colors.green),
                          SizedBox(width: 10),
                          Text('Make prescription'),
                        ],
                      ),
                      onTap: () {},
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(FontAwesomeIcons.whatsapp, color: Colors.orange),
                          SizedBox(width: 10),
                          Text('Chat with a doctor'),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatWithDoctor(
                                pageController: PageController()),
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
