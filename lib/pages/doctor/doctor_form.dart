import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:market_doctor/pages/doctor/bottom_nav_bar.dart';
import 'package:market_doctor/pages/doctor/doctor_appbar.dart';
import 'package:table_calendar/table_calendar.dart';

class DoctorFormPage extends StatefulWidget {
  const DoctorFormPage({Key? key}) : super(key: key);

  @override
  State<DoctorFormPage> createState() => _DoctorFormPageState();
}

class _DoctorFormPageState extends State<DoctorFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _yearsOfExperienceController = TextEditingController();
  final _clinicHealthFacilityController = TextEditingController();
  final _specializationController = TextEditingController();
  final _awardsAndRecognitionController = TextEditingController();
  final _languageController = TextEditingController();

  DateTime? _selectedDate;
  List<String> _selectedTimeSlots = [];

  // Function to open the date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _selectedTimeSlots
            .clear(); // Reset selected time slots for the new date
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: doctorAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Doctor Form',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              _buildLabeledTextField(
                controller: _yearsOfExperienceController,
                labelText: 'Years of Experience',
              ),
              const SizedBox(height: 16),
              _buildLabeledTextField(
                controller: _clinicHealthFacilityController,
                labelText: 'Clinic / Health Facility',
              ),
              const SizedBox(height: 16),
              _buildLabeledTextField(
                controller: _specializationController,
                labelText: 'Specialization',
              ),
              const SizedBox(height: 20),
              _buildCalendar(context),
              if (_selectedDate != null) ...[
                const SizedBox(height: 20),
                _buildTimeSlots(), // Show time slots after date selection
              ],
              const SizedBox(height: 20),
              _buildLabeledTextField(
                controller: _languageController,
                labelText: 'Languages',
              ),
              const SizedBox(height: 16),
              _buildLabeledTextField(
                controller: _awardsAndRecognitionController,
                labelText: 'Awards & Recognition',
              ),
              const SizedBox(height: 30),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: DoctorBottomNavBar(),
    );
  }

  Widget _buildLabeledTextField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Label on the left
        SizedBox(
          width: 150,
          child: Text(
            labelText,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
        // Input field on the right
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            ),
          ),
        ),
      ],
    );
  }

  // Build the calendar widget
  Widget _buildCalendar(BuildContext context) {
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

  // Build the time slots widget
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

  Widget _buildSaveButton() {
    return Align(
      alignment: Alignment.centerRight, 
      child: ElevatedButton(
        onPressed: () {
          // Handle form submission logic
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.blueAccent,
        ),
        child: const Text(
          'Save',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
