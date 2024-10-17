import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:market_doctor/main.dart';
import 'package:market_doctor/pages/doctor/availability_calendar.dart';
import 'package:market_doctor/pages/doctor/bottom_nav_bar.dart';
import 'package:market_doctor/pages/doctor/doctor_appbar.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class DoctorAvailability extends StatefulWidget {
  const DoctorAvailability({super.key});

  @override
  State<DoctorAvailability> createState() => _DoctorAvailabilityState();
}

class _DoctorAvailabilityState extends State<DoctorAvailability> {
  bool isLoading = true;
  bool hasError = false;
  List<dynamic> availabilities = [];

  @override
  void initState() {
    super.initState();
    _fetchAvailabilities();
  }

  // Fetch doctor availabilities from the API
  Future<void> _fetchAvailabilities() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });
    final doctorData =
        Provider.of<DataStore>(context, listen: false).doctorData;
    String? baseUrl = dotenv.env['API_URL'];

    final String apiUrl =
        "$baseUrl/api/availabilities?filters[users_permissions_user][id]=${doctorData?['id']}&populate=*";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          availabilities = responseData['data'] ?? [];
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
        _showSnackBar('Failed to load availabilities.');
        print('Response: ${response.body}');
      }
    } catch (error) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
      _showSnackBar('Error fetching data: $error');
    }
  }

  // Update availability
  // Function to update availability
  Future<void> _updateAvailability(String appointmentId, String newDate,
      String startTime, String endTime) async {
    String? baseUrl = dotenv.env['API_URL'];
    final String apiUrl =
        "$baseUrl/api/availabilities/${appointmentId.toString()}"; // Ensure ID is a string

    final Map<String, dynamic> body = {
      "data": {
        "date": newDate,
        "available_time": [
          {
            "start_time": startTime,
            "end_time": endTime,
          }
        ]
      }
    };

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        _showSnackBar('Availability updated successfully.');
        _fetchAvailabilities(); // Refresh the list
      } else {
        _showSnackBar('Failed to update availability.');
        print('Response: ${response.body}');
      }
    } catch (error) {
      _showSnackBar('Error updating availability: $error');
    }
  }

  // Delete availability
// Delete availability
  Future<void> _deleteAvailability(String appointmentId) async {
    String? baseUrl = dotenv.env['API_URL'];

    final String apiUrl =
        "$baseUrl/api/availabilities/${appointmentId.toString()}";
    print('AppointmentId $appointmentId');

    try {
      final response = await http.delete(
        Uri.parse(apiUrl),
      );

      if (response.statusCode == 204 || response.statusCode == 200) {
        _showSnackBar('Availability deleted successfully.');
        _fetchAvailabilities(); // Refresh the list
      } else {
        _showSnackBar('Failed to delete availability.');
        print('Response: ${response.statusCode} ${response.body}');
      }
    } catch (error) {
      _showSnackBar('Error deleting availability: $error');
    }
  }

  // Show a snackbar for error messages
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    ));
  }

  // Show dialog for updating availability
  void _showUpdateDialog(String appointmentId, String currentDate,
      String currentStartTime, String currentEndTime) {
    TextEditingController dateController =
        TextEditingController(text: currentDate);
    TextEditingController startTimeController =
        TextEditingController(text: currentStartTime);
    TextEditingController endTimeController =
        TextEditingController(text: currentEndTime);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Availability'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: dateController,
                decoration: InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
              ),
              TextField(
                controller: startTimeController,
                decoration: InputDecoration(labelText: 'Start Time (HH:mm:ss)'),
              ),
              TextField(
                controller: endTimeController,
                decoration: InputDecoration(labelText: 'End Time (HH:mm:ss)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _updateAvailability(
                  appointmentId,
                  dateController.text,
                  startTimeController.text,
                  endTimeController.text,
                );
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  // Confirm delete action
  void _confirmDelete(String appointmentId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Availability'),
          content: Text('Are you sure you want to delete this availability?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteAvailability(appointmentId);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DoctorApp(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : hasError
                          ? Center(
                              child: Text('Failed to load availabilities.'))
                          : availabilities.isNotEmpty
                              ? ListView.builder(
                                  physics:
                                      NeverScrollableScrollPhysics(), // Prevent the ListView from scrolling
                                  shrinkWrap: true, // Use only the space needed
                                  itemCount: availabilities.length,
                                  itemBuilder: (context, index) {
                                    final availability = availabilities[index];
                                    final appointmentId = availability['id'];
                                    final date = availability['attributes']
                                            ?['date'] ??
                                        'Unknown Date';
                                    final availableTime =
                                        availability['attributes']
                                                ?['available_time'] ??
                                            [];
                                    final startTime = availableTime.isNotEmpty
                                        ? availableTime[0]['start_time']
                                        : 'N/A';
                                    final endTime = availableTime.isNotEmpty
                                        ? availableTime[0]['end_time']
                                        : 'N/A';

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 16.0),
                                      child: Card(
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Date: $date',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                              SizedBox(height: 8.0),
                                              Text(
                                                'Time: $startTime - $endTime',
                                                style:
                                                    TextStyle(fontSize: 14.0),
                                              ),
                                              SizedBox(height: 14.0),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  IconButton(
                                                    icon: Icon(Icons.edit,
                                                        color:
                                                            Colors.blueAccent),
                                                    onPressed: () {
                                                      _showUpdateDialog(
                                                          appointmentId
                                                              .toString(),
                                                          date,
                                                          startTime,
                                                          endTime);
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: Icon(Icons.delete,
                                                        color: Colors.red),
                                                    onPressed: () {
                                                      _confirmDelete(
                                                          appointmentId
                                                              .toString());
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Center(child: Text('No availabilities found.')),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          _buildSaveButton(),
          const SizedBox(height: 16.0),
        ],
      ),
      bottomNavigationBar: DoctorBottomNavBar(),
    );
  }

// Build Save Button
  Widget _buildSaveButton() {
    return Align(
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AvailabilityCalendar(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
        ),
        child: const Text(
          'Add Availability',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}
