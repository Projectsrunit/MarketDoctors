import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:market_doctor/pages/chew/add_case_forms.dart';
import 'package:market_doctor/pages/chew/cases_page.dart';
import 'package:market_doctor/pages/chew/chat_with_doctor.dart';
import 'package:market_doctor/pages/chew/chew_home.dart';
import 'package:market_doctor/pages/chew/payments_main_widget.dart';
import 'package:market_doctor/pages/chew/profile_page.dart';

class BottomNavBar extends StatefulWidget {
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
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
                    icon: Icon(Icons.home, size: 36, color: Color(0xFF617DEF)),
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
                    icon: Icon(Icons.business_center,
                        size: 36, color: Color(0xFF617DEF)),
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
                    icon: Icon(Icons.credit_card,
                        size: 36, color: Color(0xFF617DEF)),
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
                    icon:
                        Icon(Icons.person, size: 36, color: Color(0xFF617DEF)),
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
                          Icon(Icons.add, color: Color(0xFF617DEF)),
                          SizedBox(width: 10),
                          Text('Add a case'),
                          SizedBox(width: 10),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddCaseForms()));
                      },
                    ),
                    PopupMenuItem(
                      padding: EdgeInsets.zero,
                      child: StatefulBuilder(
                        builder: (context, setState) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isPrescriptionExpanded =
                                        !isPrescriptionExpanded;
                                  });
                                },
                                child: Row(
                                  children: [
                                    SizedBox(width: 10),
                                    Icon(Icons.medication, color: Colors.green),
                                    SizedBox(width: 10),
                                    Text('Prescription'),
                                    Icon(
                                      isPrescriptionExpanded
                                          ? Icons.arrow_drop_up
                                          : Icons.arrow_drop_down,
                                    ),
                                    SizedBox(width: 10),
                                  ],
                                ),
                              ),
                              if (isPrescriptionExpanded) ...[
                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.grey[700]
                                        : Colors.grey[300],
                                  ),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12),
                                        dense: true,
                                        title: Center(
                                          // Centering the text inside the ListTile
                                          child: Text('Make prescription'),
                                        ),
                                        onTap: () {},
                                      ),
                                      Divider(
                                        color: Theme.of(context).dividerColor,
                                        thickness: 1.0,
                                        height: 0,
                                      ),
                                      ListTile(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12),
                                        dense: true,
                                        title: Center(
                                          // Centering the text inside the ListTile
                                          child: Text('Track prescription'),
                                        ),
                                        onTap: () {},
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          );
                        },
                      ),
                    ),
                    PopupMenuItem(
                      padding: EdgeInsets.zero, // Remove default padding
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          Icon(FontAwesomeIcons.whatsapp, color: Colors.orange),
                          SizedBox(width: 10),
                          Text('Chat with a doctor'),
                          SizedBox(width: 10),
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
                  color: Color(0xFF617DEF),
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
