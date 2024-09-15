import 'package:flutter/material.dart';
import 'package:market_doctor/pages/chew/bottom_nav_bar.dart';
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
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
                            size: 50, color: Colors.red),
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text('Cases',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Expanded(
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
                        child: Icon(Icons.person, size: 50, color: Colors.blue),
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text('Doctors',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Expanded(
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
                            size: 50, color: Colors.green),
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text('Patients',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
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
                imageUrl: 'https://via.placeholder.com/100',
                name: 'Dr. John Doe',
                profession: 'Cardiologist',
                rating: 4.5,
                onChatPressed: () {},
                onViewProfilePressed: () {},
                onBookAppointmentPressed: () {},
              ),
              SizedBox(height: 16.0),
              _DoctorCard(
                imageUrl: 'https://via.placeholder.com/100',
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
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(imageUrl, width: 100, height: 100),
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )),
                Text(profession),
                SizedBox(height: 8.0), // Space between text and buttons
                TextButton(
                  onPressed: onViewProfilePressed,
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    textStyle: TextStyle(fontSize: 10), // Smaller text size
                  ),
                  child: Text('View Profile'),
                ),
                SizedBox(height: 4.0), // Space between buttons
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16), // Smaller icon size
                    SizedBox(width: 4.0),
                    Text('$rating', style: TextStyle(color: Colors.amber, fontSize: 12)),
                  ],
                ),
                SizedBox(height: 4.0), // Space between buttons
                TextButton(
                  onPressed: onChatPressed,
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    textStyle: TextStyle(fontSize: 10), // Smaller text size
                  ),
                  child: Text('Chat with doctor'),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
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
                  Text('available'),
                ],
              ),
              SizedBox(height: 8.0), // Space between the text and button
              TextButton(
                onPressed: onBookAppointmentPressed,
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  textStyle: TextStyle(fontSize: 10), // Smaller text size
                ),
                child: Text('Book Appointment'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
