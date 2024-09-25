// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // For date formatting
import 'package:flutter_dotenv/flutter_dotenv.dart'; // For environment variables
import 'package:market_doctor/pages/doctor/doctor_appbar.dart';

class AvailabilityCalendar extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String id;

  const AvailabilityCalendar({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.id,
  });

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
      appBar:
          doctorAppBar(firstName: widget.firstName, lastName: widget.lastName),
      body: Padding(
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
    );
  }

  Widget _buildCalendar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Date',
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

  Future<void> _saveAvailability() async {
    if (_selectedDate == null || _selectedTimeSlots.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a date and at least one time slot.'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String? baseUrl = dotenv.env['API_URL'];
    final uri = Uri.parse('$baseUrl/api/availabilities');

    // Function to format time to HH:mm:ss
    String formatTime(String time) {
      final DateFormat inputFormat = DateFormat('hh:mm a'); // '09:00 AM'
      final DateFormat outputFormat = DateFormat('HH:mm:ss'); // '09:00:00'
      DateTime dateTime = inputFormat.parse(time);
      return outputFormat.format(dateTime);
    }

    // Map over selected time slots and format them
    List<String> formattedTimeSlots =
        _selectedTimeSlots.map(formatTime).toList();

    final body = jsonEncode({
      "data": {
        "date": DateFormat('yyyy-MM-dd').format(_selectedDate!),
        "time": formattedTimeSlots.join(','), // Join time slots if multiple
        "users_permissions_user": {"id": int.parse(widget.id)},
      },
    });

    // Log the request body
    print('Request body: $body');

    final headers = {
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(uri, body: body, headers: headers);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Availability saved successfully!')),
        );
        setState(() {
          _selectedDate = null;
          _selectedTimeSlots.clear();
        });
      } else {
        print('Response body: ${response.body}'); // Log the response body
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
