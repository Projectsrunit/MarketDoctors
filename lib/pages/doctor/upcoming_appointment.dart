// ignore_for_file: use_build_context_synchronously

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
              Tab(text: 'Confirmed Appointments'),
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

Future<bool> confirmAppointment(int appointmentId) async {
  String? baseUrl = dotenv.env['API_URL'];
  final apiUrl = '$baseUrl/api/appointments/$appointmentId';
  final headers = {'Content-Type': 'application/json'};

  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: headers,
      body: json.encode({
        "data": {"status": "confirmed"}
      }),
    );

    if (response.statusCode == 200) {
      return true; // Confirmation successful
    } else {
      print('Failed to confirm appointment: ${response.body}');
      return false; // Confirmation failed
    }
  } catch (e) {
    print('Error confirming appointment: $e');
    return false;
  }
}

Future<bool> rescheduleAppointment(
    int appointmentId, String newDate, String newTime) async {
  String? baseUrl = dotenv.env['API_URL'];
  final apiUrl = '$baseUrl/api/appointments/$appointmentId';
  final headers = {'Content-Type': 'application/json'};

  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: headers,
      body: json.encode({
        "data": {
          "status": "pending",
          "appointment_date": newDate,
          "appointment_time": newTime
        }
      }),
    );

    if (response.statusCode == 200) {
      return true; // Reschedule successful
    } else {
      print('Failed to reschedule appointment: ${response.body}');
      return false; // Reschedule failed
    }
  } catch (e) {
    print('Error rescheduling appointment: $e');
    return false;
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
        List<dynamic> allAppointments = json.decode(response.body)['data'];
        List<dynamic> filteredAppointments =
            allAppointments.where((appointment) {
          String status = appointment['attributes']['status'];
          return widget.isPending ? status == 'pending' : status == 'confirmed';
        }).toList();
        return filteredAppointments;
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
                appointmentId: appointment['id'],
                patientName: '${patient['firstName']} ${patient['lastName']}',
                patientAge:
                    calculateAge(DateTime.parse(patient['dateOfBirth'])),
                appointmentDate: appointment['attributes']['appointment_date'],
                appointmentTime: appointment['attributes']['appointment_time'],
                imageUrl: 'assets/images/patient.png',
                isPending: widget.isPending,
                onAppointmentConfirmed: () {
                  setState(() {
                    appointments = fetchAppointments(); // Refresh list
                  });
                },
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
  final int appointmentId;
  final String patientName;
  final int patientAge;
  final String appointmentDate;
  final String appointmentTime;
  final String? imageUrl; // Make imageUrl nullable
  final bool isPending;
  final VoidCallback onAppointmentConfirmed;

  const AppointmentCard({
    super.key,
    required this.appointmentId,
    required this.patientName,
    required this.patientAge,
    required this.appointmentDate,
    required this.appointmentTime,
    this.imageUrl, // Optional image URL
    required this.isPending,
    required this.onAppointmentConfirmed,
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
                            fontSize: 18, fontWeight: FontWeight.bold),
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
                  onPressed: () async {
                    // Select new date
                    DateTime? newDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );

                    // If a new date is selected, show time picker
                    if (newDate != null) {
                      TimeOfDay? newTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );

                      if (newTime != null) {
                        // Convert DateTime and TimeOfDay to desired string format
                        String formattedDate =
                            "${newDate.year}-${newDate.month.toString().padLeft(2, '0')}-${newDate.day.toString().padLeft(2, '0')}";
                        String formattedTime =
                            "${newTime.hour.toString().padLeft(2, '0')}:${newTime.minute.toString().padLeft(2, '0')}:00.000";

                        // Call the reschedule function with selected date and time
                        bool success = await rescheduleAppointment(
                            appointmentId, formattedDate, formattedTime);
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Appointment rescheduled')),
                          );
                          onAppointmentConfirmed(); // Refresh the list
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Failed to reschedule appointment')),
                          );
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5.0,
                    shadowColor: Colors.black54,
                  ),
                  child: const Text(
                    'Reschedule',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                ElevatedButton(
                  onPressed: isPending
                      ? () async {
                          bool success =
                              await confirmAppointment(appointmentId);
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Appointment confirmed')),
                            );
                            onAppointmentConfirmed(); // Trigger list refresh
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Failed to confirm appointment')),
                            );
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isPending ? Colors.orangeAccent : Colors.greenAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5.0,
                    shadowColor: Colors.black54,
                  ),
                  child: Text(
                    isPending ? 'Confirm' : 'Proceed',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
