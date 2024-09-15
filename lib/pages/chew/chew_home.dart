import 'package:flutter/material.dart';
import 'package:market_doctor/pages/chew/bottom_nav_bar.dart';
import 'package:market_doctor/pages/chew/cases_page.dart';
import 'package:market_doctor/pages/chew/chew_app_bar.dart';

class ChewHome extends StatelessWidget {
  final int cases = 0;
  final int doctorsOnline = 0;
  final int users = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: chewAppBar(),
      //detect a back button press and dont log out the person
      body: ChewHomeBody(),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

class ChewHomeBody extends StatefulWidget {
  @override
  State<ChewHomeBody> createState() => _ChewHomeBodyState();
}

class _ChewHomeBodyState extends State<ChewHomeBody> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search doctor, field, drugs",
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    // Add search functionality here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context)
                            .textButtonTheme
                            .style
                            ?.backgroundColor
                            ?.resolve({}) ??
                        Color(0xFF617DEF),
                    foregroundColor: Theme.of(context)
                            .textButtonTheme
                            .style
                            ?.foregroundColor
                            ?.resolve({}) ??
                        Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text('Search'),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context )=> CasesPage()));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        child: Icon(Icons.local_hospital,
                            size: 80, color: Colors.red),
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text('Cases',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(width: 8.0), 
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context )=> CasesPage()));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        child: Icon(Icons.person,
                            size: 80, color: Colors.blue),
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text('Doctors',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(width: 8.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context )=> CasesPage()));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        child: Icon(Icons.person_outline,
                            size: 80, color: Colors.green),
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text('Patients',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Container(
            height: 130,
            color: Color(0xFF617DEF),
            child: Center(
              child: Text(
                'for advertisement',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popular Doctors',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.transparent,
                ),
                child: Text(
                  'See all',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Column(
            children: [
              _DoctorCard(
                imageUrl: 'https://via.placeholder.com/120',
                name: 'Dr. John Doe',
                profession: 'Cardiologist',
                rating: 4.5,
                onChatPressed: () {},
                onViewProfilePressed: () {},
                onBookAppointmentPressed: () {},
              ),
              SizedBox(height: 16.0),
              _DoctorCard(
                imageUrl: 'https://via.placeholder.com/120',
                name: 'Dr. Jane Smith',
                profession: 'Dermatologist',
                rating: 4.0,
                onChatPressed: () {
                  // Add functionality for "Chat with doctor"
                },
                onViewProfilePressed: () {
                  // Add functionality for "View Profile"
                },
                onBookAppointmentPressed: () {
                  // Add functionality for "Book appointment"
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DoctorCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String profession;
  final double rating;
  final VoidCallback onChatPressed;
  final VoidCallback onViewProfilePressed;
  final VoidCallback onBookAppointmentPressed;

  _DoctorCard({
    required this.imageUrl,
    required this.name,
    required this.profession,
    required this.rating,
    required this.onChatPressed,
    required this.onViewProfilePressed,
    required this.onBookAppointmentPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
      height: 124,
      padding: const EdgeInsets.all(2.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Image.network(imageUrl, width: 120, height: 120),
          ),
          SizedBox(width: 4),
          Flex(
              crossAxisAlignment: CrossAxisAlignment.start,
              direction: Axis.vertical,
              children: [
                Text(name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )),
                Text(profession),
                GestureDetector(
                  onTap: onViewProfilePressed,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xFF617DEF),
                        borderRadius: BorderRadius.circular(2)),
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                    constraints: BoxConstraints(
                      minHeight: 20,
                      maxHeight: 25,
                      maxWidth: double.infinity,
                    ),
                    child: Text('View Profile',
                        style: TextStyle(fontSize: 14, color: Colors.white)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      SizedBox(width: 4.0),
                      Text('$rating',
                          style: TextStyle(color: Colors.amber, fontSize: 14)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onChatPressed,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xFF617DEF),
                        borderRadius: BorderRadius.circular(2)),
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                    constraints: BoxConstraints(
                      minHeight: 24,
                    ),
                    child: Text('Chat with doctor',
                        style: TextStyle(fontSize: 14, color: Colors.white)),
                  ),
                ),
              ]),
          SizedBox(width: 8.0),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2),
              child: Flex(
                direction: Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 4.0),
                      Text(
                        'available',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: onBookAppointmentPressed,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      decoration: BoxDecoration(
                          color: Color(0xFF617DEF),
                          borderRadius: BorderRadius.circular(2)),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: 'Book\n',
                                style: TextStyle(color: Colors.white)),
                            TextSpan(
                                text: 'Appointment',
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
