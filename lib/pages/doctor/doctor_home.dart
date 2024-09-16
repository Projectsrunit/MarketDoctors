import 'package:flutter/material.dart';

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
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable back button
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.person_2_rounded, color: Colors.black),
                  onPressed: () {}, // Clock action
                ),
                const SizedBox(width: 8),
                const Text('@user',
                    style: TextStyle(color: Colors.black, fontSize: 15)),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.access_time_outlined,
                      color: Colors.black),
                  onPressed: () {}, // Clock action
                ),
                IconButton(
                  icon: const Icon(Icons.notification_add_outlined,
                      color: Colors.black),
                  onPressed: () {}, // Notification action
                ),
              ],
            ),
          ],
        ),
      ),
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
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildSearchbar() {
  return Row(
    children: [
      // Search bar with shadow
      Expanded(
        child: Container(
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
              hintStyle: TextStyle(color: Colors.grey[500]), // Subtle hint color
              prefixIcon: const Icon(Icons.search, color: Colors.black), // Search icon inside
              contentPadding: const EdgeInsets.symmetric(vertical: 12.0), // Comfortable padding
              border: InputBorder.none, 
            ),
          ),
        ),
      ),
      const SizedBox(width: 10), 
      Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2), // Shadow position
            ),
          ],
          borderRadius: BorderRadius.circular(10), // Matching the button's border radius
        ),
        child: TextButton.icon(
          onPressed: () {
            // Handle filter action
          },
          icon: const Icon(Icons.filter_list, color: Colors.black), // Filter icon
          label: const Text(
            'Filter',
            style: TextStyle(color: Colors.black), // Text for the filter button
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0), // Consistent padding
            backgroundColor: Colors.white, // White background for consistency with search bar
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
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildDashboardCard(
          icon: Icons.cases,
          label: 'Cases',
          onTap: () {}, // Replace with your cases action
        ),
        _buildDashboardCard(
          icon: Icons.local_pharmacy,
          label: 'Pharmacy',
          onTap: () {}, // Replace with your pharmacy action
        ),
        _buildDashboardCard(
          icon: Icons.calendar_today,
          label: 'Appointment',
          onTap: () {}, // Replace with your appointment action
        ),
        _buildDashboardCard(
          icon: Icons.payment,
          label: 'Payment',
          onTap: () {}, // Replace with your payment action
        ),
      ],
    );
  }

  Widget _buildDashboardCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blueAccent.withOpacity(0.2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blueAccent),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: const DecorationImage(
          image: AssetImage('assets/images/doctor-image.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black.withOpacity(0.5),
        ),
        child: const Text(
          'Discover the Secret to the Perfect Smile\n"Whitegate"',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildNextAppointmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Next Appointment',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildAppointmentCard(
              icon: Icons.videocam,
              label: 'Video Consultation',
              doctorName: 'Dr. Goodness Usorah',
              time: '02:00 PM',
              date: 'April 2, 2024',
            ),
            _buildAppointmentCard(
              icon: Icons.mic,
              label: 'Audio Consultation',
              doctorName: 'Dr. John Ogundipe',
              time: '02:00 PM',
              date: 'April 2, 2024',
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () {}, // Replace with your "See all" action
          child: const Text('See all'),
        ),
      ],
    );
  }

  Widget _buildAppointmentCard({
    required IconData icon,
    required String label,
    required String doctorName,
    required String time,
    required String date,
  }) {
    return Container(
      width: 150,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.blueAccent),
          const SizedBox(height: 4),
          Text(label),
          const SizedBox(height: 4),
          Text('$doctorName'),
          const SizedBox(height: 4),
          Text('$time, $date'),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.cases),
          label: 'Cases',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.payment),
          label: 'Payment',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
