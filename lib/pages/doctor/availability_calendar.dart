// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:market_doctor/data_store.dart';
import 'package:market_doctor/pages/doctor/bottom_nav_bar.dart';
import 'package:market_doctor/pages/doctor/doctor_home.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // For date formatting
import 'package:flutter_dotenv/flutter_dotenv.dart'; // For environment variables
import 'package:market_doctor/pages/doctor/doctor_appbar.dart';
import 'package:provider/provider.dart';

class AvailabilityCalendar extends StatefulWidget {
  const AvailabilityCalendar({super.key});

  @override
  State<AvailabilityCalendar> createState() => _AvailabilityCalendarState();
}

class _AvailabilityCalendarState extends State<AvailabilityCalendar> {
  DateTime? _selectedDate;
  List<String> _selectedTimeSlots = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DoctorAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCalendar(),
              const SizedBox(height: 16),
              if (_selectedDate != null) _buildTimeSlots(),
              const SizedBox(height: 16),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: DoctorBottomNavBar(),
    );
  }

  Widget _buildCalendar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Date Available',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TableCalendar(
          focusedDay: _selectedDate ?? DateTime.now(),
          firstDay: DateTime(2000),
          lastDay: DateTime(2101),
          calendarFormat: CalendarFormat.month,
          selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDate = selectedDay;
              _selectedTimeSlots
                  .clear(); // Clear previous time slots on new date selection
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
      ],
    );
  }

  Widget _buildTimeSlots() {
    final List<String> timeSlots = [
      '09:00 AM',
      '10:00 AM',
      '11:00 AM',
      '12:00 PM',
      '01:00 PM',
      '02:00 PM',
      '03:00 PM',
      '04:00 PM',
      '05:00 PM',
      '06:00 PM',
      '07:00 PM',
      '08:00 PM',
      '09:00 PM',
      '10:00 PM',
      '11:00 PM',
      '00:00 AM',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Time Slots',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10.0,
          children: timeSlots.map((time) {
            final isSelected = _selectedTimeSlots.contains(time);
            return ChoiceChip(
              label: Text(time),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedTimeSlots.add(time);
                  } else {
                    _selectedTimeSlots.remove(time);
                  }
                });
              },
            );
          }).toList(),
        ),
        if (_selectedTimeSlots.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              '${_selectedTimeSlots.length} time slot(s) selected',
              style: const TextStyle(color: Colors.green),
            ),
          ),
      ],
    );
  }

  String formatTime(String time) {
    final DateFormat inputFormat = DateFormat('hh:mm a'); // '09:00 AM'
    final DateFormat outputFormat = DateFormat('HH:mm:ss'); // '09:00:00'
    DateTime dateTime = inputFormat.parse(time);
    return outputFormat.format(dateTime);
  }

// List of time slots with start and end times
  List<Map<String, String>> generateTimeSlotPairs(
      List<String> selectedTimeSlots) {
    List<Map<String, String>> timePairs = [];

    for (int i = 0; i < selectedTimeSlots.length - 1; i++) {
      timePairs.add({
        'start_time': formatTime(selectedTimeSlots[i]),
        'end_time': formatTime(selectedTimeSlots[i + 1]),
      });
    }

    return timePairs;
  }

  Future<void> _saveAvailability() async {
    final doctorData =
        Provider.of<DataStore>(context, listen: false).doctorData;

    if (_selectedDate == null || _selectedTimeSlots.isEmpty) {
      _showSnackBar('Please select a date and at least one time slot.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String? baseUrl = dotenv.env['API_URL'];
    final uri = Uri.parse('$baseUrl/api/availabilities');

    // Generate time slot pairs with start and end times
    List<Map<String, String>> timeSlotPairs =
        generateTimeSlotPairs(_selectedTimeSlots);

    final body = jsonEncode({
      "data": {
        "date": DateFormat('yyyy-MM-dd').format(_selectedDate!),
        "users_permissions_user": doctorData?['id'],
        "available_time": timeSlotPairs, // Provide the array of time slots
      },
    });

    final headers = {
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(uri, body: body, headers: headers);
      if (response.statusCode == 200) {
        _showSnackBar('Availability saved successfully!');
        setState(() {
          _selectedDate = null;
          _selectedTimeSlots.clear();
        });
         Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DashboardPage(),
            ),
          );
      } else {
        print('Response body: ${response.body}');
        _showSnackBar('Failed to save: ${response.reasonPhrase}');
      }
    } catch (e) {
      _showSnackBar('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildSaveButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: _isLoading
            ? null
            : _saveAvailability, // Disable button when loading
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.blueAccent,
        ),
        child: _isLoading
            ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Save',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
      ),
    );
  }
}
