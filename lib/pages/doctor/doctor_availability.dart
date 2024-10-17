import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:market_doctor/main.dart';
import 'package:market_doctor/pages/doctor/bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
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
        "$baseUrl/api/availabilities?filters[users_permissions_user][id]=${doctorData?['id']}&populate=*'";
    // final String token = Provider.of<DataStore>(context, listen: false).authToken;

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
      );

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

  // Show a snackbar for error messages
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    ));
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Doctor Availabilities')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : hasError
              ? Center(child: Text('Failed to load availabilities.'))
              : availabilities.isNotEmpty
                  ? ListView.builder(
                      itemCount: availabilities.length,
                      itemBuilder: (context, index) {
                        final availability = availabilities[index];
                        // Null-check on 'availability' and nested objects
                        final date = availability['attributes']?['date'] ??
                            'Unknown Date';
                        final availableTime =
                            availability['attributes']?['available_time'] ?? [];
                        final startTime = availableTime.isNotEmpty
                            ? availableTime[0]['start_time']
                            : 'N/A';
                        final endTime = availableTime.isNotEmpty
                            ? availableTime[0]['end_time']
                            : 'N/A';

                        return ListTile(
                          title: Text('Date: $date'),
                          subtitle: Text('Time: $startTime - $endTime'),
                        );
                      },
                    )
                  : Center(child: Text('No availabilities found.')),
    );
  }

  // Build list of availabilities
  Widget _buildAvailabilityList() {
    if (availabilities.isEmpty) {
      return Center(child: Text('No availabilities found.'));
    }

    return ListView.builder(
      itemCount: availabilities.length,
      itemBuilder: (context, index) {
        final availability = availabilities[index]['attributes'];
        final doctor =
            availability['users_permissions_user']['data']['attributes'];

        return Card(
          child: ListTile(
            title: Text(
              '${doctor['firstName']} ${doctor['lastName']} - ${doctor['specialisation']}',
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Date: ${availability['date']}'),
                Text(
                    'Available from ${availability['available_time'][0]['start_time']} to ${availability['available_time'][0]['end_time']}'),
                Text('Facility: ${doctor['facility']}'),
              ],
            ),
            leading: doctor['profile_picture'] != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(doctor['profile_picture']),
                  )
                : CircleAvatar(child: Icon(Icons.person)),
          ),
        );
      },
    );
  }
}
