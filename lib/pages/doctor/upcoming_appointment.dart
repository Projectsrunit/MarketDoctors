import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:market_doctor/pages/doctor/bottom_nav_bar.dart';
import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:market_doctor/main.dart';

// Main Appointments Page with Tabs for Upcoming and Pending Appointments
class UpcomingAppointmentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Appointments'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Upcoming Appointments'),
              Tab(text: 'Pending Appointments'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AppointmentListTab(isPending: false),
            AppointmentListTab(isPending: true),
          ],
        ),
        bottomNavigationBar: DoctorBottomNavBar(),
      ),
    );
  }
}

// Appointment List Tab: Shared for both Upcoming and Pending Appointments
class AppointmentListTab extends StatefulWidget {
  final bool isPending;

  const AppointmentListTab({super.key, required this.isPending});

  @override
  _AppointmentListTabState createState() => _AppointmentListTabState();
}

class _AppointmentListTabState extends State<AppointmentListTab> {
  late Future<List<dynamic>> appointments;

  @override
  void initState() {
    super.initState();
    appointments = fetchAppointments();
  }

  Future<List<dynamic>> fetchAppointments() async {
    final doctorData =
        Provider.of<DataStore>(context, listen: false).doctorData;
    String? baseUrl = dotenv.env['API_URL'];
    final apiUrl =
        '$baseUrl/api/appointments?filters[doctor][id]=${doctorData?['id']}&populate=patient';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        return json.decode(response.body)['data'];
      } else {
        throw Exception('Failed to load appointments');
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: appointments,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No appointments found.'));
        } else {
          final appointmentsList = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: appointmentsList.length,
            itemBuilder: (context, index) {
              final appointment = appointmentsList[index];
              final patient =
                  appointment['attributes']['patient']['data']['attributes'];
              return AppointmentCard(
                patientName: '${patient['firstName']} ${patient['lastName']}',
                patientAge:
                    calculateAge(DateTime.parse(patient['dateOfBirth'])),
                appointmentDate: appointment['attributes']['appointment_date'],
                appointmentTime: appointment['attributes']['appointment_time'],
                imageUrl: 'assets/images/patient.png',
                isPending: widget.isPending,
              );
            },
          );
        }
      },
    );
  }

  int calculateAge(DateTime birthDate) {
    final currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;

    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month &&
            currentDate.day < birthDate.day)) {
      age--;
    }

    return age;
  }
}

// Reusable AppointmentCard Widget

class AppointmentCard extends StatelessWidget {
  final String patientName;
  final int patientAge;
  final String appointmentDate;
  final String appointmentTime;
  final String? imageUrl; // Make imageUrl nullable
  final bool isPending;

  const AppointmentCard({
    super.key,
    required this.patientName,
    required this.patientAge,
    required this.appointmentDate,
    required this.appointmentTime,
    this.imageUrl, // Optional image URL
    required this.isPending,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row: Image and Patient Info
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
                      ? AssetImage(imageUrl!) // Use image if available
                      : null, // No image
                  child: imageUrl == null || imageUrl!.isEmpty
                      ? const Icon(Icons.person,
                          size: 30) // Display icon if no image
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patientName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('Age: $patientAge years'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Row: Date and Time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 8),
                    Text(
                      'Date: $appointmentDate',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.access_time),
                    const SizedBox(width: 8),
                    Text(
                      'Time: $appointmentTime',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Row: Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle Reschedule Action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Reschedule'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle Proceed Action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isPending ? Colors.orangeAccent : Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(isPending ? 'Confirm' : 'Proceed'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
