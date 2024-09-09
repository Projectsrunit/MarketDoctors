import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:market_doctor/pages/chew/cases_page.dart';
import 'package:market_doctor/pages/chew/chew_home.dart';
import 'package:market_doctor/pages/chew/payments_main_widget.dart';

class BottomNavBar extends StatefulWidget {
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  bool isMenuVisible = false;

  // @override
  // Widget build(BuildContext context) {
  //   return Stack(
  //     clipBehavior: Clip.none,
  //     alignment: Alignment.center,
  //     children: [
  //       Container(
  //         color: Colors.blueGrey,
  //         // height: 70,
  //         child: BottomNavigationBar(
  //           items: [
  //             BottomNavigationBarItem(
  //               icon: GestureDetector(
  //                 onTap: () {
  //                   Navigator.push(context,
  //                       MaterialPageRoute(builder: (context) => ChewHome()));
  //                 },
  //                 child: Icon(Icons.home),
  //               ),
  //               label: "Home",
  //             ),
  //             BottomNavigationBarItem(
  //               icon: GestureDetector(
  //                 onTap: () {
  //                   Navigator.push(context,
  //                       MaterialPageRoute(builder: (context) => CasesPage()));
  //                 },
  //                 child: Icon(Icons.business_center),
  //               ),
  //               label: "Cases",
  //             ),
  //             BottomNavigationBarItem(
  //               icon: GestureDetector(
  //                 onTap: () {},
  //                 child: SizedBox(
  //                   height: 40,
  //                   width: 60,
  //                 ),
  //               ),
  //               label: "",
  //             ),
  //             BottomNavigationBarItem(
  //               icon: GestureDetector(
  //                 onTap: () {
  //                   Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                           builder: (context) => PaymentsMainWidget()));
  //                 },
  //                 child: Icon(Icons.credit_card),
  //               ),
  //               label: "Payment",
  //             ),
  //             BottomNavigationBarItem(
  //               icon: Icon(Icons.person),
  //               label: "Profile",
  //             ),
  //           ],
  //           currentIndex: 0,
  //           onTap: (index) {
  //             if (index != 2) {
  //               // Handle page navigation if necessary
  //             }
  //           },
  //           backgroundColor: Colors.blueGrey,
  //         ),
  //       ),
  //       Positioned(
  //         top: -20,
  //         child: GestureDetector(
  //           onTap: () {
  //             setState(() {
  //               isMenuVisible = !isMenuVisible;
  //             });
  //             Future.delayed(Duration.zero, () {
  //               showMenu(
  //                 context: context,
  //                 position: RelativeRect.fromLTRB(100, 600, 100, 100),
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(20),
  //                 ),
  //                 items: [
  //                   PopupMenuItem(
  //                     child: Row(
  //                       children: [
  //                         Icon(Icons.add, color: Colors.blue),
  //                         SizedBox(width: 10),
  //                         Text('Add a case'),
  //                       ],
  //                     ),
  //                     onTap: () {},
  //                   ),
  //                   PopupMenuItem(
  //                     child: Row(
  //                       children: [
  //                         Icon(Icons.medication, color: Colors.green),
  //                         SizedBox(width: 10),
  //                         Text('Make prescription'),
  //                       ],
  //                     ),
  //                     onTap: () {},
  //                   ),
  //                   PopupMenuItem(
  //                     child: Row(
  //                       children: [
  //                         Icon(FontAwesomeIcons.whatsapp, color: Colors.orange),
  //                         SizedBox(width: 10),
  //                         Text('Chat with a doctor'),
  //                       ],
  //                     ),
  //                     onTap: () {
  //                       Navigator.push(
  //                         context,
  //                         MaterialPageRoute(
  //                           builder: (context) => ChatWithDoctor(
  //                               pageController: PageController()),
  //                         ),
  //                       );
  //                     },
  //                   ),
  //                 ],
  //               ).then((_) {
  //                 setState(() {
  //                   isMenuVisible = false;
  //                 });
  //               });
  //             });
  //           },
  //           child: AnimatedSwitcher(
  //             duration: Duration(milliseconds: 300),
  //             transitionBuilder: (child, animation) {
  //               return FadeTransition(opacity: animation, child: child);
  //             },
  //             child: Container(
  //               key: ValueKey<bool>(isMenuVisible),
  //               height: 60,
  //               width: 60,
  //               decoration: BoxDecoration(
  //                 color: Colors.blue,
  //                 shape: BoxShape.circle,
  //               ),
  //               child: Icon(
  //                 isMenuVisible ? Icons.arrow_downward : Icons.arrow_upward,
  //                 size: 40, // Larger arrow size
  //                 color: Theme.of(context).brightness == Brightness.light
  //                     ? Colors.black
  //                     : Colors.white, // Arrow color based on theme
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          child: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ChewHome()));
                  },
                  child: Icon(Icons.home, size: 40, color: Colors.blue),
                ),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CasesPage()));
                  },
                  child:
                      Icon(Icons.business_center, size: 40, color: Colors.blue),
                ),
                label: "Cases",
              ),
              BottomNavigationBarItem(
                icon: GestureDetector(
                  onTap: () {},
                  child: SizedBox(height: 40, width: 60),
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PaymentsMainWidget()));
                  },
                  child: Icon(Icons.credit_card, size: 40, color: Colors.blue),
                ),
                label: "Payment",
              ),
              BottomNavigationBarItem(
                icon: GestureDetector(
                  onTap: () {},
                  child: Icon(Icons.person, size: 40, color: Colors.blue),
                ),
                label: "Profile",
              ),
            ],
            currentIndex: 0,
            selectedItemColor:
                isDarkMode ? Colors.white : Colors.black, // Active icon color
            unselectedItemColor: Colors.blue, // Inactive icon color
            backgroundColor:
                isDarkMode ? Colors.black : Colors.grey, // Background color
            onTap: (index) {
              if (index != 2) {
                // Handle navigation
              }
            },
          ),
        ),
        Positioned(
          top: -20,
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
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isMenuVisible ? Icons.arrow_downward : Icons.arrow_upward,
                  size: 40, // Larger arrow size
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white, // Arrow color based on theme
                ),
              ),
            ),
          ),
        ), // Rest of your Positioned widget code...
      ],
    );
  }
}
