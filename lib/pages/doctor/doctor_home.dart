// ignore_for_file: unnecessary_string_interpolations, unused_field

import 'package:flutter/material.dart';
import 'package:market_doctor/main.dart';
import 'package:market_doctor/pages/doctor/availability_calendar.dart';
import 'package:market_doctor/pages/doctor/bottom_nav_bar.dart';
import 'package:market_doctor/pages/doctor/doctor_appbar.dart';
import 'package:market_doctor/pages/doctor/doctor_appointment.dart';
import 'package:market_doctor/pages/doctor/doctor_cases.dart';
import 'package:market_doctor/pages/patient/advertisement_carousel.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Accessing the doctorData from Provider
    final doctorData = Provider.of<DataStore>(context).doctorData;
    final String? userId = doctorData?['user']?['id'];

    return Scaffold(
      appBar:  DoctorApp(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchbar(),
            const SizedBox(height: 16),
            _buildDashboardCards(userId),
            const SizedBox(height: 16),
            AdvertisementCarousel(),
            const SizedBox(height: 16),
            _buildNextAppointmentSection(),
          ],
        ),
      ),
      bottomNavigationBar:  DoctorBottomNavBar(),
    );
  }

  Widget _buildSearchbar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Cases, Appointment, Pharmacy',
                hintStyle: TextStyle(color: Colors.grey[500]),
                prefixIcon: const Icon(Icons.search, color: Colors.black),
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextButton.icon(
            onPressed: () {
              // Handle filter action
            },
            icon: const Icon(Icons.filter_list, color: Colors.black),
            label: const Text('Filter', style: TextStyle(color: Colors.black)),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardCards(String? userId) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      crossAxisSpacing: 10,
      mainAxisSpacing: 16,
      children: [
        _buildDashboardCardWithLabel(
          image: const AssetImage('assets/images/cases-image.png'),
          label: 'Cases',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DoctorCasesPage()),
            );
          },
        ),
        _buildDashboardCardWithLabel(
          image: const AssetImage('assets/images/pills-image.png'),
          label: 'Pharmacy',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>  AvailabilityCalendar()),
            );
          },
        ),
        _buildDashboardCardWithLabel(
          icon: Icons.person_add_alt_1_outlined,
          label: 'Appointment',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const DoctorAppointmentPage()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDashboardCardWithLabel({
    AssetImage? image,
    IconData? icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              decoration: BoxDecoration(
                color: const Color(0xFF617DEF).withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: image != null
                    ? Image(image: image, fit: BoxFit.contain)
                    : Icon(icon, size: 40, color: const Color(0xFF617DEF)),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildNextAppointmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Next Appointment',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            GestureDetector(
              onTap: () {}, // Replace with your "See all" action
              child: const Text(
                'See all',
                style: TextStyle(
                  color: Color(0xFF4672ff),
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSmallAppointmentCard(time: '02:00 PM', date: 'April 2, 2024'),
            const SizedBox(width: 4),
            Container(width: 70, height: 2, color: const Color(0xFF4672ff)),
            const SizedBox(width: 4),
            _buildSmallAppointmentCard(time: '02:00 PM', date: 'April 2, 2024'),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildLargeAppointmentCard(
              label: 'Video Consultation',
              doctorName: 'Dr. Goodness Usorah',
              time: '02:00 PM',
              date: 'April 2, 2024',
            ),
            const SizedBox(width: 16),
            _buildLargeAppointmentCard(
              label: 'Audio Consultation',
              doctorName: 'Dr. John Ogundipe',
              time: '02:00 PM',
              date: 'April 2, 2024',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSmallAppointmentCard({required String time, required String date}) {
    return Container(
      width: 120,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFF617DEF),
      ),
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(time, style: const TextStyle(color: Colors.white, fontSize: 12)),
          Text(date, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildLargeAppointmentCard({
    required String label,
    required String doctorName,
    required String time,
    required String date,
  }) {
    return Container(
      width: 170,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFF617DEF),
      ),
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
          const SizedBox(height: 8),
          Text(doctorName, style: const TextStyle(color: Colors.white, fontSize: 12)),
          const SizedBox(height: 4),
          Text(time, style: const TextStyle(color: Colors.white, fontSize: 12)),
          Text(date, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}
