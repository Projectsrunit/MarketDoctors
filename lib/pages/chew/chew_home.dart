import 'package:flutter/material.dart';
import 'package:market_doctor/pages/chew/add_case_forms.dart';
import 'package:market_doctor/pages/chew/cases_page.dart';
import 'package:market_doctor/pages/chew/payments_main_widget.dart';
import 'package:market_doctor/pages/chew/stats_row.dart';
import 'package:market_doctor/pages/chew/profile_page.dart';

class ChewHome extends StatefulWidget {
  @override
  _ChewHomeState createState() => _ChewHomeState();
}

class _ChewHomeState extends State<ChewHome> {
  int cases = 0;
  int doctorsOnline = 0;
  int users = 0;
  bool showMore = false;
  PageController pageController = PageController();

  void pushNewCase() {
    print('going to push1');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: chewAppBar(),
      body: PageView(
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
                  Text(
                    "Recent cases",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(),
                      Text("DD/MM"),
                    ],
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: [
                      _buildCaseItem("John Doe", "25", "New York", "01/09"),
                      _buildCaseItem(
                          "Jane Smith", "30", "Los Angeles", "02/09"),
                      _buildCaseItem(
                          "Michael Johnson", "40", "Chicago", "03/09"),
                      if (showMore) ...[
                        _buildCaseItem("Alice Brown", "35", "Miami", "04/09"),
                        _buildCaseItem(
                            "Robert Davis", "28", "Houston", "05/09"),
                      ],
                      TextButton(
                        onPressed: () {
                          setState(() {
                            showMore = !showMore;
                          });
                        },
                        child: Text(showMore ? "Show less" : "See more"),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Available doctors",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _buildDoctorItem("Dr. A", "Cardiologist", "Free"),
                      _buildDoctorItem("Dr. B", "Dentist", "Paid"),
                      _buildDoctorItem("Dr. C", "Pediatrician", "Free"),
                    ],
                  ),
                ],
              ),
            ),
          ),
          CasesPage(),
          SizedBox(
              //this is the index 2 which is to be skipped
              ),
          PaymentsMainWidget(),
          ProfilePage(pageController: pageController),
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
          UpdateProfileChew(),
          ManagePaymentsChew(),
          UpdateQualificationChew(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text("Chat with a doctor"),
        icon: Icon(Icons.message),
      ),
      bottomNavigationBar: BottomNavBar(pageController: pageController),
    );
  }

  Widget _buildCaseItem(String name, String age, String location, String date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
            Text(age, style: TextStyle(fontSize: 12)),
            Text(location, style: TextStyle(fontSize: 12)),
          ],
        ),
        Text(date),
      ],
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

AppBar chewAppBar() {
  return AppBar(
    leading: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(Icons.ac_unit),
        ),
        SizedBox(width: 8),
        Flexible(
          child: Text(
            "CHEW",
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
    actions: [
      IconButton(
        icon: Icon(Icons.notifications),
        onPressed: () {},
      ),
    ],
  );
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey,
      child: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.business), label: "Cases"),
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
                        pageController.jumpToPage(5);
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
                        pageController.jumpToPage(8);
                      },
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.chat, color: Colors.orange),
                          SizedBox(width: 10),
                          Text('Chat with a doctor'),
                        ],
                      ),
                      onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ChatWithDoctor(pageController: pageController),
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
              icon: Icon(Icons.credit_card), label: "Payment"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        currentIndex: 0,
        onTap: (index) {
          if (index != 2) {
            pageController.jumpToPage(index);
          }
        },
        backgroundColor: Colors.blueGrey,
      ),
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
                      pageController:
                          pageController, 
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
      bottomNavigationBar: BottomNavBar(pageController: pageController),
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
                        builder: (context) =>
                            RealChatWithDoctor(doctor: doctor, pageController: pageController,),
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
      bottomNavigationBar: BottomNavBar(pageController: pageController),
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
      bottomNavigationBar: BottomNavBar(pageController: pageController),
    );
  }
}
