import 'package:flutter/material.dart';
import 'package:market_doctor/pages/chew/add_case_forms.dart';
import 'package:market_doctor/pages/chew/bottom_nav_bar.dart';
import 'package:market_doctor/pages/chew/cases_page.dart';
import 'package:market_doctor/pages/chew/chew_app_bar.dart';
import 'package:market_doctor/pages/chew/payments_main_widget.dart';
import 'package:market_doctor/pages/chew/stats_row.dart';
import 'package:market_doctor/pages/chew/profile_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      //     AddCaseForms(),
      //     UpdateProfileChew(),
      //     ManagePaymentsChew(),
      //     UpdateQualificationChew(),
      floatingActionButton: FloatingActionButton.extended(
  onPressed: () {},
  // icon: Icon(FontAwesomeIcons.whatsapp),
  label: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(FontAwesomeIcons.whatsapp, size: 32),
      SizedBox(height: 4), 
      Text(
        "Chat with a doctor",
        style: TextStyle(fontSize: 12), 
      ),
    ],
  ),
),

      bottomNavigationBar: BottomNavBar(),
    );
  }
}

class ChewHomeBody extends StatefulWidget {

  @override
  State<ChewHomeBody> createState() => _ChewHomeBodyState();
}

class _ChewHomeBodyState extends State<ChewHomeBody> {
  bool showMore = false;

  @override
  Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StatsRow(),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Recent cases",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
              Text("DD/MM"),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  _buildCaseItem("John Doe", "25", "New York", "01/09"),
                  _buildCaseItem("Jane Smith", "30", "Los Angeles", "02/09"),
                  _buildCaseItem("Michael Johnson", "40", "Chicago", "03/09"),
                  if (showMore) ...[
                    _buildCaseItem("Alice Brown", "35", "Miami", "04/09"),
                    _buildCaseItem("Robert Davis", "28", "Houston", "05/09"),
                  ],
                  TextButton(
                    onPressed: () {
                      setState(() {
                        showMore = !showMore;
                      });
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12
                          ),
                      minimumSize: Size(0, 0), 
                    ),
                    child: Text(showMore ? "Show less" : "See more"),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            "Available doctors",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            double itemWidth = (constraints.maxWidth - 10) / 2;
            return Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                SizedBox(
                  width: itemWidth,
                  child: _buildDoctorItem("Dr. A", "Cardiologist", "Free"),
                ),
                SizedBox(
                  width: itemWidth,
                  child: _buildDoctorItem("Dr. B", "Dentist", "Paid"),
                ),
                SizedBox(
                  width: itemWidth,
                  child: _buildDoctorItem("Dr. C", "Pediatrician", "Free"),
                ),
                SizedBox(
                  width: itemWidth,
                  child: _buildDoctorItem("Dr. D", "Opthalmologist", "Free"),
                ),
              ],
            );
          },
        ),
      ],
    ),
  );
}

  Widget _buildCaseItem(String name, String age, String location, String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Text("Age: "),
                  Text(age, style: TextStyle(fontSize: 14)),
                ],
              ),
              Row(
                children: [
                  Text("Location: "),
                  Text(location, style: TextStyle(fontSize: 14)),
                ],
              ),
            ],
          ),
          Text(
            date,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorItem(String name, String specialization, String status) {
    return IntrinsicWidth(
      child: Container(
        padding: EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, color: Colors.white),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(specialization),
                  Text(status, style: TextStyle(color: Colors.green)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddCaseForms extends StatelessWidget {

  void pushNewCase() {
    print('going to push1');
  }
  
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      children: [
        Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StatsRow(),
              SizedBox(height: 20),
              AddCaseForm1(pageController: pageController),
            ],
          ),
        ),
      ),
      Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StatsRow(),
                  SizedBox(height: 20),
                  AddCaseForm2(pageController: pageController),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StatsRow(),
                  SizedBox(height: 20),
                  AddCaseForm3(pushNewCase: pushNewCase),
                ],
              ),
            ),
          ),
      ]
    );
  }
}

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
          StatsRow(),
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
