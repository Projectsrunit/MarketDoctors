import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:market_doctor/pages/chew/cases_page.dart';
import 'package:market_doctor/pages/chew/chew_home.dart';
import 'package:market_doctor/pages/chew/payments_main_widget.dart';

class BottomNavBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey,
      child: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: GestureDetector(onTap: () {            
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChewHome()));
          },
          child: Icon(Icons.home)),
          label: "Home",),
          BottomNavigationBarItem(
            icon: GestureDetector(onTap: () {            
            Navigator.push(context, MaterialPageRoute(builder: (context) => CasesPage()));
          },
          child: Icon(Icons.business_center)),
          label: "Cases",),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(100, 600, 100, 100),
                  items: [
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.add,
                              color: Colors.blue), // Icon for "Add a case"
                          SizedBox(width: 10),
                          Text('Add a case'),
                        ],
                      ),
                      onTap: () {
                        // pageController.jumpToPage(5);
                      },
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.medication,
                              color:
                                  Colors.green), // Icon for "Make prescription"
                          SizedBox(width: 10),
                          Text('Make prescription'),
                        ],
                      ),
                      onTap: () {
                        // pageController.jumpToPage(8);
                      },
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
                            builder: (context) => 
                                ChatWithDoctor(pageController: PageController()),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
              child: SizedBox(
                height: 60,
                child: Icon(Icons.arrow_upward),
              ),
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(onTap: () {            
            Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentsMainWidget()));
          },
          child: Icon(Icons.credit_card)),
          label: "Payment",),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        currentIndex: 0,
        onTap: (index) {
          if (index != 2) {
            // pageController.jumpToPage(index);
          }
        },
        backgroundColor: Colors.blueGrey,
      ),
    );
  }
}
