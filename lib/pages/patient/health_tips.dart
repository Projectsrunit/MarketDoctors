import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:market_doctor/pages/patient/bottom_nav_bar.dart';

class HealthTipsPage extends StatefulWidget {
  @override
  _HealthTipsPageState createState() => _HealthTipsPageState();
}

class _HealthTipsPageState extends State<HealthTipsPage> {
  List healthTips = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchHealthTips();
  }

  fetchHealthTips() async {
    final String baseUrl =
        dotenv.env['API_URL']!; // Ensure this is correctly set
    final Uri url = Uri.parse('$baseUrl/api/health-tips');
    final response = await http.get(url);
    // final respo = await http.get(Uri.parse('{{BASE_URL}}/api/health-tips'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        healthTips = data['data'];
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load health tips');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Market Doctor Health Tips',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: healthTips.length,
              itemBuilder: (context, index) {
                final tip = healthTips[index]['attributes'];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 5,
                    color: const Color.fromARGB(255, 215, 244, 248),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image section
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          child: Image.network(
                            tip['feauture_image'],
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tip['title'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isDarkMode ? Colors.grey[800] : Colors.black,
                                ),
                              ),
                              SizedBox(height: 8),
                              // Text(
                              //   tip['description'],
                              //   style: TextStyle(fontSize: 16),
                              // ),
                              Text(
                                tip['description'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isDarkMode ? Colors.grey[600] : Colors.grey[800],
                                ),
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    tip['category'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: isDarkMode
                                          ? Colors.grey[600]
                                          : Colors.green,
                                    ),
                                  ),
                                  Text(
                                    'Published on ${tip['publishedAt'].substring(0, 10)}',
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 12,
                                        color: isDarkMode
                                            ? Colors.grey[600]
                                            : Colors.black),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: PatientBottomNavBar(),
    );
  }
}
