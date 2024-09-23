import 'package:flutter/material.dart';
import 'package:market_doctor/pages/doctor/bottom_nav_bar.dart';

class UpcomingAppointmentPage extends StatelessWidget {
  final String firstName;
  final String lastName;

  UpcomingAppointmentPage({
    required this.firstName,
    required this.lastName,
  });
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
            UpcomingAppointmentsTab(),
            PendingAppointmentsTab(),
          ],
        ),
        bottomNavigationBar: DoctorBottomNavBar(
          firstName: firstName,
          lastName: lastName,
        ),
      ),
    );
  }
}

// Widget for Upcoming Appointments Tab
class UpcomingAppointmentsTab extends StatelessWidget {
  const UpcomingAppointmentsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: 5, // Number of upcoming appointments
      itemBuilder: (context, index) {
        return AppointmentCard(
          patientName: 'John Doe',
          patientAge: 32,
          appointmentDate: '09/09/2024',
          appointmentTime: '10:30 AM',
          imageUrl: 'assets/images/patient.png',
          isPending: false,
        );
      },
    );
  }
}

// Widget for Pending Appointments Tab
class PendingAppointmentsTab extends StatelessWidget {
  const PendingAppointmentsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: 3, // Number of pending appointments
      itemBuilder: (context, index) {
        return AppointmentCard(
          patientName: 'Jane Smith',
          patientAge: 29,
          appointmentDate: '09/09/2024',
          appointmentTime: '1:00 PM',
          imageUrl: 'assets/images/patient.png',
          isPending: true,
        );
      },
    );
  }
}

// Reusable Appointment Card Widget
class AppointmentCard extends StatelessWidget {
  final String patientName;
  final int patientAge;
  final String appointmentTime;
  final String appointmentDate;
  final String imageUrl;
  final bool isPending;

  const AppointmentCard({
    Key? key,
    required this.patientName,
    required this.patientAge,
    required this.appointmentTime,
    required this.appointmentDate,
    required this.imageUrl,
    required this.isPending,
  }) : super(key: key);

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
            // First Row: Image and Patient Info
            Row(
              children: [
                // Patient Image
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(imageUrl),
                ),
                const SizedBox(width: 16),
                // Patient Name and Age
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
            const SizedBox(height: 20),

            // Second Row: Date and Time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.calendar_month),
                Text(
                  'Date: $appointmentDate',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Icon(Icons.punch_clock_sharp),
                Text(
                  'Time: $appointmentTime',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Third Row: Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle Schedule Action
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                  child: const Text('ReSchedule'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle Proceed Action
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isPending ? Colors.blueAccent : Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                  child: Text(isPending ? 'PrReScheduleoceed' : 'Proceed'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
