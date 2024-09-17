// ignore_for_file: unnecessary_string_interpolations, unused_field

import 'package:flutter/material.dart';
import 'package:market_doctor/pages/doctor/bottom_nav_bar.dart';
import 'package:market_doctor/pages/doctor/doctor_appbar.dart';
import 'package:market_doctor/pages/doctor/doctor_cases.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: doctorAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchbar(),
              const SizedBox(height: 16),
              _buildDashboardCards(),
              const SizedBox(height: 16),
              _buildBanner(),
              const SizedBox(height: 16),
              _buildNextAppointmentSection(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: DoctorBottomNavBar(),
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
              borderRadius:
                  BorderRadius.circular(10), // Border radius added here
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 2), // Shadow position
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Cases, Appointment, Pharmacy',
                hintStyle:
                    TextStyle(color: Colors.grey[500]), // Subtle hint color
                prefixIcon: const Icon(Icons.search,
                    color: Colors.black), // Search icon inside
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 12.0), // Comfortable padding
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(10), // Border radius here as well
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 2), // Shadow position
              ),
            ],
          ),
          child: TextButton.icon(
            onPressed: () {
              // Handle filter action
            },
            icon: const Icon(Icons.filter_list,
                color: Colors.black), // Filter icon
            label: const Text(
              'Filter',
              style:
                  TextStyle(color: Colors.black), // Text for the filter button
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                  horizontal: 15.0, vertical: 12.0), // Consistent padding
              backgroundColor: Colors.white, // White background for consistency
              foregroundColor: Colors.black, // Black text/icon color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Rounded corners
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardCards() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      crossAxisSpacing: 10,
      mainAxisSpacing: 16,
      children: [
        _buildDashboardCardWithLabel(
          image: AssetImage('assets/images/cases-image.png'),
          label: 'Cases',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      DoctorCasesPage()), // Replace with your CasesPage widget
            );
          },
        ),
        _buildDashboardCardWithLabel(
          image: AssetImage('assets/images/pills-image.png'),
          label: 'Pharmacy',
          onTap: () {},
        ),
        _buildDashboardCardWithLabel(
          icon: Icons.person_add_alt_1_outlined,
          label: 'Appointment',
          onTap: () {},
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
              // height: 100,
              decoration: BoxDecoration(
                color: Color(0xFF617DEF).withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: image != null
                    ? Image(image: image, fit: BoxFit.contain)
                    : Icon(icon,
                        size: 40,
                        color: Color(0xFF617DEF)), // Increased icon size
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

  Widget _buildBanner() {
    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xFF617DEF).withOpacity(0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: const Text(
                'Thought about secret \n to having the perfect \n smile..... “Whitegate”',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          // Image section on the right
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                  image: AssetImage('assets/images/advert-image.png'),
                  fit: BoxFit.cover,
                ),
              ),
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
        const SizedBox(
            height: 16), // Spacing between the heading and the card rows
        // Row for smaller cards showing time and date with a blue line in between
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSmallAppointmentCard(
              time: '02:00 PM',
              date: 'April 2, 2024',
            ),
            const SizedBox(width: 4), // Spacing between the card and the line
            Container(
              width: 70,
              height: 2,
              color: Color(0xFF4672ff),
            ),
            const SizedBox(width: 4),
            _buildSmallAppointmentCard(
              time: '02:00 PM',
              date: 'April 2, 2024',
            ),
            const SizedBox(width: 4), // Spacing between the card and the line

            Container(
              width: 30,
              height: 2,
              color: Color(0xFF4672ff),
            ),
          ],
        ),
        const SizedBox(height: 16), // Spacing between rows of cards
        // Row for larger cards showing label and doctor’s name
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildLargeAppointmentCard(
              label: 'Video Consultation',
              doctorName: 'Dr. Goodness Usorah',
              time: '02:00 PM',
              date: 'April 2, 2024',
            ),
            const SizedBox(width: 16), // Spacing between larger cards
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

  Widget _buildSmallAppointmentCard({
    required String time,
    required String date,
  }) {
    return Container(
      width: 120,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xFF617DEF),
      ),
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$time',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
          Text(
            '$date',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
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
        color: Color(0xFF617DEF),
      ),
      padding: const EdgeInsets.all(12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // White line on the left
          Container(
            width: 4, // Increased thickness of the white line
            height: 45, // Full height of the card
            color: Colors.white,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  doctorName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
