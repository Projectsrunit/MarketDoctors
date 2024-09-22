import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:market_doctor/pages/doctor/bottom_nav_bar.dart';
import 'package:market_doctor/pages/doctor/doctor_appbar.dart';

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
                    fontSize: 22,
                    color: Colors.black,
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
              const SizedBox(height: 16),
              _buildCalendar(context),
              if (_selectedDate != null) ...[
                const SizedBox(height: 16),
                _buildTimeSlots(), // Show time slots after date selection
              ],
              const SizedBox(height: 16),
              _buildLabeledTextField(
                controller: _languageController,
                labelText: 'Languages',
              ),
              const SizedBox(height: 16),
              _buildLabeledTextField(
                controller: _awardsAndRecognitionController,
                labelText: 'Awards & Recognition',
              ),
              const SizedBox(height: 16),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: DoctorBottomNavBar(),
    );
  }

  // Build a labeled text field with the label on the left and the text input on the right
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
            style: const TextStyle(fontSize: 16),
          ),
        ),
        // Input field on the right
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  // Build the calendar widget
  Widget _buildCalendar(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 150,
          child: const Text(
            "Select a Date",
            style: TextStyle(fontSize: 16),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Text(
                _selectedDate != null
                    ? DateFormat.yMMMd().format(_selectedDate!)
                    : "No date selected",
                style: const TextStyle(fontSize: 16),
              ),
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () =>
                    _selectDate(context), // Trigger the calendar picker
              ),
            ],
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
        const Text('Available Time Slots'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          children: [
            _buildTimeSlotButton(time: '09:30 AM'),
            _buildTimeSlotButton(time: '11:00 AM'),
            _buildTimeSlotButton(time: '01:00 PM'),
            _buildTimeSlotButton(time: '03:30 PM'),
            _buildTimeSlotButton(time: '05:00 PM'),
            _buildTimeSlotButton(time: '07:00 PM'),
            _buildTimeSlotButton(time: '09:00 PM'),
            _buildTimeSlotButton(time: '11:00 PM'),
            _buildTimeSlotButton(time: '01:30 AM'),
            _buildTimeSlotButton(time: '03:30 AM'),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeSlotButton({required String time}) {
    final isSelected = _selectedTimeSlots.contains(time);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          // primary: isSelected ? Colors.green : Colors.blue, // Highlight if selected
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
      child: Text(time),
    );
  }

  Widget _buildSaveButton() {
    return TextButton(
      onPressed: () {
        // Handle form submission logic
      },
      child: const Text('Save'),
    );
  }
}
