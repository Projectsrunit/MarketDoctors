import 'package:flutter/material.dart';
import 'package:market_doctor/pages/chew/bottom_nav_bar.dart';
import 'package:market_doctor/pages/chew/chew_app_bar.dart';

class ChatWithDoctor extends StatelessWidget {
  final List<Map<String, dynamic>> doctors = [
    {'name': 'Dr. John Doe', 'age': 45, 'location': 'New York'},
    {'name': 'Dr. Jane Smith', 'age': 50, 'location': 'Los Angeles'},
    {'name': 'Dr. Emily Davis', 'age': 35, 'location': 'Chicago'},
    // Add more doctors as needed
  ];
  final PageController pageController;

  ChatWithDoctor({required this.pageController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: chewAppBar(),
      body: Column(
        children: [
          ...doctors.map((doc) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AvailableDocsDetails(
                      doctor: doc,
                      pageController: pageController,
                    ),
                  ),
                );
              },
              child: AvailableDocs(
                name: doc['name'],
                age: doc['age'],
                location: doc['location'],
              ),
            );
          }).toList(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

class AvailableDocs extends StatelessWidget {
  final String name;
  final int age;
  final String location;

  AvailableDocs(
      {required this.name, required this.age, required this.location});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(name),
        Text('Age: $age'),
        Text('Location: $location'),
      ],
    );
  }
}

class AvailableDocsDetails extends StatelessWidget {
  final Map<String, dynamic> doctor;
  final PageController pageController;

  AvailableDocsDetails({
    required this.doctor,
    required this.pageController,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: chewAppBar(),
      body: Column(
        children: [
          Row(
            children: [
              // Doctor's Image
              Image.network('https://example.com/doctor_image.png', width: 50),
              Column(
                children: [
                  Text(doctor['name']),
                  Text('Specialty: ${doctor['specialty']}'),
                  Row(
                    children: [
                      Icon(Icons.star),
                      Icon(Icons.star),
                      Icon(Icons.star)
                    ], // Star Rating
                  ),
                  // Online indicator
                  Align(
                    alignment: Alignment.topRight,
                    child: Icon(Icons.circle, color: Colors.green),
                  ),
                ],
              ),
            ],
          ),
          // More details
          Row(
            children: [
              Icon(Icons.people),
              Text("1000+ patients"),
              Icon(Icons.timer),
              Text("10 years experience"),
              Icon(Icons.local_hospital),
              Text("Health Clinic"),
            ],
          ),
          Text("About doctor"),
          Text("Doctor's detailed description goes here."),
          Text("Availability"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("Mon-Fri"), Text("9:00 AM - 5:00 PM")],
          ),
          Text("Specialisation"),
          Text("Cardiology, Pediatrics, etc."),
          Text("Languages"),
          Text("English, Spanish"),
          Row(
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RealChatWithDoctor(
                          doctor: doctor,
                          pageController: pageController,
                        ),
                      ),
                    );
                  },
                  child: Text('Send message')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Back')),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

class RealChatWithDoctor extends StatelessWidget {
  final Map<String, dynamic> doctor;
  final PageController pageController;

  RealChatWithDoctor({required this.doctor, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Row(
          children: [
            Text(doctor['name']),
            Icon(Icons.circle, color: Colors.green), // Online status
            CircleAvatar(
                backgroundImage:
                    NetworkImage('https://example.com/doctor_image.png')),
          ],
        ),
        actions: [IconButton(icon: Icon(Icons.phone), onPressed: () {})],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                // Chat messages UI similar to WhatsApp
                // Messages from the doctor and user
              ],
            ),
          ),
          Row(
            children: [
              IconButton(icon: Icon(Icons.add), onPressed: () {}),
              Expanded(
                  child: TextField(
                      decoration: InputDecoration(hintText: "Enter message"))),
              IconButton(icon: Icon(Icons.send), onPressed: () {}),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
