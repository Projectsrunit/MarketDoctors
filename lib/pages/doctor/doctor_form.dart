import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:market_doctor/pages/doctor/bottom_nav_bar.dart';
import 'package:market_doctor/pages/doctor/doctor_appbar.dart';
import 'package:market_doctor/pages/doctor/doctor_appointment.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class DoctorFormPage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String id;

  const DoctorFormPage({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.id,
  }) : super(key: key);

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
  final ImagePicker _picker = ImagePicker();

  File? _profileImage;
  DateTime? _selectedDate;
  List<String> _selectedTimeSlots = [];
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
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    String? baseUrl = dotenv.env['API_URL'];
    final uri = Uri.parse('$baseUrl/api/users/${widget.id}');

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        _yearsOfExperienceController.text =
            userData['yearsOfExperience']?.toString() ??
                ''; // Ensure this is a string
        _clinicHealthFacilityController.text =
            userData['clinicHealthFacility'] ?? '';
        _specializationController.text = userData['specialization'] ?? '';
        _languageController.text = userData['languages'] ?? '';
        _awardsAndRecognitionController.text =
            userData['awardsAndRecognition'] ?? '';

        if (userData['date'] != null) {
          _selectedDate = DateTime.parse(userData['date']);
        }
        // Update UI
        setState(() {});
      } else {
        _showSnackBar('Failed to fetch user data: ${response.reasonPhrase}');
      }
    } catch (e) {
      _showSnackBar('Error: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateUser() async {
    if (_formKey.currentState!.validate()) {
      String? baseUrl = dotenv.env['API_URL'];
      final uri = Uri.parse('$baseUrl/api/users/${widget.id}');
      final request = http.MultipartRequest('PUT', uri);
      request.fields['yearsOfExperience'] = _yearsOfExperienceController.text;
      request.fields['clinicHealthFacility'] =
          _clinicHealthFacilityController.text;
      request.fields['specialization'] = _specializationController.text;
      request.fields['languages'] = _languageController.text;
      request.fields['awardsAndRecognition'] =
          _awardsAndRecognitionController.text;
      request.fields['date'] = _selectedDate != null
          ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
          : '';
      request.fields['timeSlots'] = jsonEncode(_selectedTimeSlots);

      if (_profileImage != null) {
        final imageFile = await http.MultipartFile.fromPath(
            'profile_picture', _profileImage!.path);
        request.files.add(imageFile);
      }

      try {
        final response = await request.send();
        if (response.statusCode == 200) {
          _showSnackBar('User updated successfully!');
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DoctorAppointmentPage(
                firstName: widget.firstName,
                lastName: widget.lastName,
                id: widget.id,
              ),
            ),
          );
        } else {
          _showSnackBar('Failed to update user: ${response.reasonPhrase}');
        }
      } catch (e) {
        _showSnackBar('Error: $e');
      }
    }
  }

  Widget _buildProfileImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Profile Image',
            style: TextStyle(fontSize: 16, color: Colors.black87)),
        const SizedBox(height: 8),
        Row(
          children: [
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Pick Image'),
            ),
            const SizedBox(width: 16),
            _profileImage != null
                ? Image.file(_profileImage!,
                    width: 100, height: 100, fit: BoxFit.cover)
                : Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[300],
                    child: const Icon(Icons.camera_alt, color: Colors.white),
                  ),
          ],
        ),
      ],
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
              const SizedBox(height: 16),
              _buildProfileImagePicker(),
              const SizedBox(height: 30),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: DoctorBottomNavBar(
        firstName: widget.firstName,
        lastName: widget.lastName,
        id: widget.id,
      ),
    );
  }

 Widget _buildLabeledTextField({
  required TextEditingController controller,
  required String labelText,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start, // Align to the top
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
          keyboardType: labelText == 'Years of Experience'
              ? TextInputType.number // Set keyboard type to number
              : TextInputType.text, // Default keyboard type
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            hintText: labelText == 'Awards & Recognition' 
                ? 'Enter your awards and recognitions' 
                : null, // No hint for other fields
          ),
          maxLines: labelText == 'Awards & Recognition' ? 4 : 1, // Allow multi-line for awards
          validator: (value) {
            if (labelText == 'Years of Experience') {
              if (value == null || value.isEmpty) {
                return 'Please enter your years of experience';
              }
              // Ensure it's a valid number
              final int? years = int.tryParse(value);
              if (years == null || years < 0) {
                return 'Please enter a valid number';
              }
            } else if (labelText == 'Awards & Recognition') {
              if (value == null || value.isEmpty) {
                return 'Please enter your awards and recognitions';
              }
            }
            return null;
          },
        ),
      ),
    ],
  );
}


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
        onPressed: _updateUser,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
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
