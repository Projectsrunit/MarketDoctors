import 'package:flutter/material.dart';
import 'package:market_doctor/pages/doctor/availability_calendar.dart';
import 'package:market_doctor/pages/doctor/bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:market_doctor/pages/doctor/doctor_appbar.dart';
import 'package:market_doctor/main.dart';
import 'package:intl/intl.dart';

class DoctorAvailability extends StatefulWidget {
  const DoctorAvailability({super.key});

  @override
  State<DoctorAvailability> createState() => _DoctorAvailabilityState();
}

class _DoctorAvailabilityState extends State<DoctorAvailability> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _yearsOfExperienceController =
      TextEditingController();
  final TextEditingController _clinicHealthFacilityController =
      TextEditingController();
  final TextEditingController _specializationController =
      TextEditingController();
  final TextEditingController _awardsAndRecognitionController =
      TextEditingController();
  final TextEditingController _languageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final doctorData =
        Provider.of<DataStore>(context, listen: false).doctorData;
    if (doctorData != null) {
      _yearsOfExperienceController.text =
          doctorData['yearsOfExperience']?.toString() ?? '';
      _clinicHealthFacilityController.text =
          doctorData['clinicHealthFacility'] ?? '';
      _specializationController.text = doctorData['specialization'] ?? '';
      _languageController.text = doctorData['languages'] ?? '';
      _awardsAndRecognitionController.text =
          doctorData['awardsAndRecognition'] ?? '';
    } else {
      _showSnackBar('No doctor data found.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildDoctorProfile() {
    final doctorData =
        Provider.of<DataStore>(context, listen: false).doctorData;
    final name = doctorData != null
        ? '${doctorData['firstName']} ${doctorData['lastName']}'
        : 'Unknown Doctor';
    final specialization = doctorData?['specialisation'] ?? 'Not Specified';
    final profilePic = doctorData?['profile_picture'];
    final availabilities = doctorData?['doctor_availabilities'] ?? [];

    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    final DateTime currentDate = DateTime.now();

    // Filter availabilities to show only current and future dates
    final upcomingAvailabilities = availabilities.where((availability) {
      final DateTime availabilityDate = DateTime.parse(availability['date']);
      return availabilityDate.isAfter(currentDate) ||
          availabilityDate.isAtSameMomentAs(currentDate);
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile section
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: profilePic != null
                    ? NetworkImage(profilePic)
                    : const AssetImage('assets/images/placeholder.png')
                        as ImageProvider,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(specialization,
                      style: const TextStyle(fontSize: 16, color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Availability section
          const Text('Availability:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          upcomingAvailabilities.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: upcomingAvailabilities.map<Widget>((availability) {
                    final date = availability['date'];
                    final availableTimes = availability['available_time'];

                    return Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9, // Wider card
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Date: $date',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue, // Blue color for the date
                              ),
                            ),
                            const SizedBox(height: 5),
                            availableTimes != null && availableTimes.isNotEmpty
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children:
                                        availableTimes.map<Widget>((time) {
                                      return Text(
                                          'Time: ${time['start_time']} - ${time['end_time']}');
                                    }).toList(),
                                  )
                                : const Text('No available time'),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                )
              : const Center(
                  child: Text(
                    'No upcoming availabilities',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Align(
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AvailabilityCalendar(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.blueAccent,
        ),
        child: const Text(
          'Add Availability',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DoctorApp(),
      backgroundColor: Colors.grey[200], // Background color set to grey
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  'Doctor Availability',
                  style: TextStyle(
                    fontSize: 26,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              _buildDoctorProfile(),
              const SizedBox(height: 50),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: DoctorBottomNavBar(),
    );
  }
}
