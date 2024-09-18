import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Assuming you're using SVG icons
import 'package:intl/intl.dart';

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

  DateTime _selectedDate = DateTime.now();
  List<String> _selectedTimeSlots = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Form'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {}, // Replace with your notification action
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {}, // Replace with your settings action
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                controller: _yearsOfExperienceController,
                labelText: 'Years of Experience',
              ),
              _buildTextField(
                controller: _clinicHealthFacilityController,
                labelText: 'Clinic / Health Facility',
              ),
              _buildTextField(
                controller: _specializationController,
                labelText: 'Specialization',
              ),
              // _buildCalendar(),
              _buildTimeSlots(),
              _buildTextField(
                controller: _awardsAndRecognitionController,
                labelText: 'Awards & Recognition',
              ),
              const SizedBox(height: 16),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
      ),
    );
  }

  // Widget _buildCalendar() {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
  //     child: CalendarCarousel(
  //       weekdays: const ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'],
  //       weekendDays: [CalendarCarousel.defaultSaturday, CalendarCarousel.defaultSunday],
  //       todayButtonColor: Colors.grey[200],
  //       selectedDateTime: _selectedDate,
  //       onDayPressed: (DateTime date) {
  //         setState(() {
  //           _selectedDate = date;
  //         });
  //       },
  //     ),
  //   );
  // }

  Widget _buildTimeSlots() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Availability'),
        const SizedBox(height: 8),
        Wrap(
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
    return ElevatedButton(
      onPressed: () {
        // Handle time slot selection logic
        setState(() {
          if (_selectedTimeSlots.contains(time)) {
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
    return ElevatedButton(
      onPressed: () {
        // Handle form submission logic
      },
      child: const Text('Save'),
    );
  }
}