import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DoctorCardScreen extends StatefulWidget {
  @override
  _DoctorCardScreenState createState() => _DoctorCardScreenState();
}

class _DoctorCardScreenState extends State<DoctorCardScreen> {
  List<dynamic> doctorData = [];

  @override
  void initState() {
    super.initState();
    fetchDoctorData();
  }

  Future<void> fetchDoctorData() async {
    final response = await http.get(
Uri.parse('{{BASE_URL}}/api/users?filters[id][\$eq]=35&filters[role][\$eq]=3&populate=*')
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      setState(() {
        doctorData = responseData;
      });
    } else {
      throw Exception('Failed to load doctor data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctors'),
      ),
      body: doctorData.isNotEmpty
          ? ListView.builder(
              itemCount: doctorData.length,
              itemBuilder: (context, index) {
                final doctor = doctorData[index];
                final profilePictureUrl = doctor['profile_picture']?['url'] ?? '';
                final fullName = '${doctor['firstName']} ${doctor['lastName']}';
                final profession = doctor['role']['description'] ?? 'Doctor';
                final rating = 4.5; // Assuming static rating for now

                return DoctorCard(
                  imageUrl: 'https://yourdomain.com${profilePictureUrl}',
                  name: fullName,
                  profession: profession,
                  rating: rating,
                  onChatPressed: () {
                    // Handle chat press
                  },
                  onViewProfilePressed: () {
                    // Handle view profile press
                  },
                  onBookAppointmentPressed: () {
                    // Handle book appointment press
                  },
                );
              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

class DoctorCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String profession;
  final double rating;
  final VoidCallback onChatPressed;
  final VoidCallback onViewProfilePressed;
  final VoidCallback onBookAppointmentPressed;

  DoctorCard({
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
        height: 135,
        padding: const EdgeInsets.all(2.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Image.network(
                imageUrl,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 4),
            Flex(
              crossAxisAlignment: CrossAxisAlignment.start,
              direction: Axis.vertical,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(profession),
                GestureDetector(
                  onTap: onViewProfilePressed,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5)),
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
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
                SizedBox(height: 8),
                GestureDetector(
                  onTap: onChatPressed,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5)),
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                    child: Text('Chat with doctor',
                        style: TextStyle(fontSize: 14, color: Colors.white)),
                  ),
                ),
              ],
            ),
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
                        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(5)),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: 'Book',
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
