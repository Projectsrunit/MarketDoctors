import 'package:flutter/material.dart';

class ChewHome extends StatefulWidget {
  @override
  _ChewHomeState createState() => _ChewHomeState();
}

class _ChewHomeState extends State<ChewHome> {
  int cases = 0;
  int doctorsOnline = 0;
  int users = 0;
  bool showMore = false;
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Row(
          mainAxisSize: MainAxisSize.min, // Prevents Row from expanding
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.ac_unit),
            ),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                "CHEW",
                overflow: TextOverflow.ellipsis, // Handles overflow
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
      ),
      body: PageView(
        controller: _pageController,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatItem("Cases", cases),
                      _buildStatItem("Doctors online", doctorsOnline),
                      _buildStatItem("Users", users),
                    ],
                  ),
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
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text("Chat with a doctor"),
        icon: Icon(Icons.message),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.business), label: "Cases"),
          BottomNavigationBarItem(
            icon: Container(
              height: 60,
              child: Icon(Icons.arrow_upward),
            ),
            label: "",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.credit_card), label: "Payment"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        currentIndex: 0,
        onTap: (index) {
          _pageController.jumpToPage(index);
        },
        backgroundColor: Colors.blueGrey,
      ),
    );
  }

  Widget _buildStatItem(String label, int value) {
    return Column(
      children: [
        Text(
          "$value",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(label),
      ],
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
