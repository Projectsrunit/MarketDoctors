import 'package:flutter/material.dart';
import 'package:market_doctor/pages/doctor/doctor_appbar.dart';

class UpcomingAppointmentPage extends StatefulWidget {
  const UpcomingAppointmentPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _UpcomingAppointmentPageState createState() =>
      _UpcomingAppointmentPageState();
}

class _UpcomingAppointmentPageState extends State<UpcomingAppointmentPage> {
  int _selectedIndex = 0; // Tracks which tab is selected

  // Widget to show based on the selected tab
  final List<Widget> _pages = [
    UpcomingAppointmentsTab(),
    PendingAppointmentsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: doctorAppBar(),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Upcoming Appointments Tab Button
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedIndex = 0; // Switch to the "Upcoming" tab
                  });
                },
                child: Text(
                  'Upcoming Appointments',
                  style: TextStyle(
                    color: _selectedIndex == 0 ? Colors.blue : Colors.black,
                    fontWeight: _selectedIndex == 0
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              // Pending Appointments Tab Button
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedIndex = 1; // Switch to the "Pending" tab
                  });
                },
                child: Text(
                  'Pending Appointments',
                  style: TextStyle(
                    color: _selectedIndex == 1 ? Colors.blue : Colors.black,
                    fontWeight: _selectedIndex == 1
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
          const Divider(), // Add a line to separate the tabs from content

          // Display the selected tab's content
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }
}

// Widget for Upcoming Appointments Tab
class UpcomingAppointmentsTab extends StatelessWidget {
  const UpcomingAppointmentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: 5, // Number of upcoming appointments
      itemBuilder: (context, index) {
        return AppointmentCard(
          patientName: 'John Doe',
          patientAge: 32,
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
  const PendingAppointmentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: 3, // Number of pending appointments
      itemBuilder: (context, index) {
        return AppointmentCard(
          patientName: 'Jane Smith',
          patientAge: 29,
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
  final String imageUrl;
  final bool isPending;

  const AppointmentCard({
    Key? key,
    required this.patientName,
    required this.patientAge,
    required this.appointmentTime,
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
        child: Row(
          children: [
            // Patient Image
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(imageUrl),
            ),
            const SizedBox(width: 16),
            // Patient Info and Appointment Time
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
                  const SizedBox(height: 8),
                  Text(
                    'Appointment: $appointmentTime',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            // Buttons: Schedule/Proceed
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle Schedule Action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: const Text('Schedule'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // Handle Proceed Action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isPending ? Colors.orange : Colors.green,
                  ),
                  child: Text(isPending ? 'Proceed' : 'Start'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
