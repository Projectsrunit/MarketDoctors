import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:market_doctor/pages/doctor/bottom_nav_bar.dart';
import 'package:market_doctor/pages/doctor/doctor_appbar.dart';
import 'package:market_doctor/pages/doctor/upcoming_appointment.dart';
import 'package:table_calendar/table_calendar.dart';

class DoctorAppointmentPage extends StatefulWidget {
  final String firstName;
  final String lastName;

  const DoctorAppointmentPage({
    super.key,
    required this.firstName,
    required this.lastName,
  });

  @override
  State<DoctorAppointmentPage> createState() => _DoctorAppointmentPageState();
}

class _DoctorAppointmentPageState extends State<DoctorAppointmentPage> {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();
  DateTime? _selectedDate;
  List<String> _selectedTimeSlots = [];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Widget _buildDoctorInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/doctor-image.png'),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Dr. Samuel Jason',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('Surgeon'),
                    Text('Available: 24 Hours'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.call),
                  onPressed: () {
                    // Handle phone call action
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.videocam),
                  onPressed: () {
                    // Handle video call action
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.message),
                  onPressed: () {
                    // Handle messaging action
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarSection(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title on the left
        SizedBox(
          width: 100, // Adjust the width as needed
          child: Text(
            'Select Date',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.bold, // Added for emphasis
            ),
          ),
        ),
        const SizedBox(width: 10), // Space between title and calendar

        // Calendar with grey background on the right
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8.0), // Padding for better spacing
            color: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TableCalendar(
                  focusedDay: _selectedDate ?? DateTime.now(),
                  firstDay: DateTime(2000),
                  lastDay: DateTime(2101),
                  calendarFormat: CalendarFormat.month,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDate, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDate = selectedDay;
                    });
                  },
                  calendarStyle: const CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Colors.lightBlueAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                ),
                if (_selectedDate != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Selected Date: ${DateFormat.yMMMd().format(_selectedDate!)}",
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlots() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Available Time Slots',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10.0,
          runSpacing: 8.0,
          children: [
            _buildTimeSlotButton(time: '09:30 AM'),
            _buildTimeSlotButton(time: '11:00 AM'),
            _buildTimeSlotButton(time: '01:00 PM'),
            _buildTimeSlotButton(time: '03:30 PM'),
            _buildTimeSlotButton(time: '05:00 PM'),
            _buildTimeSlotButton(time: '07:00 PM'),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeSlotButton({required String time}) {
    final isSelected = _selectedTimeSlots.contains(time);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.green : Colors.grey[300],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      onPressed: () {
        // Handle time slot selection logic
        setState(() {
          if (isSelected) {
            _selectedTimeSlots.remove(time);
          } else {
            _selectedTimeSlots.add(time);
          }
        });
      },
      child: Text(time, style: TextStyle(color: Colors.black)),
    );
  }

  Widget _buildNoteSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Schedule',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _noteController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter additional notes for your appointment',
          ),
          maxLines: 4,
        ),
      ],
    );
  }

  Widget _buildAppointmentButton() {
    return SizedBox(
      width: double.infinity, // Full-width button
      child: ElevatedButton(
        onPressed: () {
          // if (_selectedDate != null) {
          //   // Handle appointment scheduling logic here
          // } else {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     const SnackBar(content: Text('Please select a date')),
          //   );
          // }

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => UpcomingAppointmentPage(
                firstName: widget.firstName,
                lastName: widget.lastName,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.blueAccent,
        ),
        child: const Text(
          'Make an Appointment',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          doctorAppBar(firstName: widget.firstName, lastName: widget.lastName),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDoctorInfoCard(),
              const SizedBox(height: 16),
              _buildCalendarSection(context),
              if (_selectedDate != null) ...[
                const SizedBox(height: 20),
                _buildTimeSlots(), // Show time slots after date selection
              ],
              const SizedBox(height: 16),
              _buildNoteSection(),
              const SizedBox(height: 32),
              _buildAppointmentButton(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: DoctorBottomNavBar(
        firstName: widget.firstName,
        lastName: widget.lastName,
      ),
    );
  }
}
