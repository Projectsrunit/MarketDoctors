import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:market_doctor/data_store.dart';
import 'package:market_doctor/main.dart';
import 'package:market_doctor/pages/doctor/doctor_availability.dart';
import 'package:market_doctor/pages/doctor/doctor_home.dart';
import 'package:market_doctor/pages/doctor/doctor_information.dart';
import 'package:market_doctor/pages/doctor/payments_main_widget.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:market_doctor/pages/doctor/bottom_nav_bar.dart';
import 'package:market_doctor/pages/doctor/update_profile_image.dart';
import 'package:market_doctor/pages/doctor/doctor_appbar.dart';
import 'package:market_doctor/chat_store.dart';
import 'package:market_doctor/pages/doctor/upcoming_appointment.dart';
import 'package:provider/provider.dart';

class DoctorProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DoctorAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Icon(Icons.person_outline),
                  SizedBox(width: 8),
                  Text('Doctor',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            _buildGeneralList(context),
            SizedBox(height: 8), // List of rows under "General"
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Icon(Icons.settings),
                  SizedBox(width: 8),
                  Text('System',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            _buildSystemList(context), // List of rows under "System"
          ],
        ),
      ),
      bottomNavigationBar: DoctorBottomNavBar(),
    );
  }

  Widget _buildGeneralList(context) {
    return Column(
      children: [
        _buildArrowRow(Icons.account_circle, "Profile information", () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => DoctorInformation()));
        }),
        Divider(color: Colors.grey[300], thickness: 1),
        _buildArrowRow(Icons.medical_services, "Patient Overview", () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UpcomingAppointmentPage()));
        }),
        Divider(color: Colors.grey[300], thickness: 1),
        _buildArrowRow(Icons.task_alt_outlined, "Task Management", () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => DoctorAvailability()));
        }),
        Divider(color: Colors.grey[300], thickness: 1),
        _buildArrowRow(Icons.medical_information_outlined, "Payment Accounts",
            () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ManagePaymentsDoctor()));
        }),
        Divider(color: Colors.grey[300], thickness: 2),
      ],
    );
  }

  Widget _buildSystemList(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);

    return Column(
      children: [
        _buildModeToggleRow(
            context, Icons.dark_mode, "Dark mode", themeNotifier.toggleTheme),
        Divider(color: Colors.grey[300], thickness: 1),
        _buildNoArrowRow(context, Icons.chat_rounded, "Communication Type",
            _showPasswordPopup),
        Divider(color: Colors.grey[300], thickness: 1),
        _buildNoArrowRow(
            context, Icons.notifications, "Emergency Alert", _showPinPopup),
        Divider(color: Colors.grey[300], thickness: 1),
        _buildNotifToggleRow(Icons.notifications, "Allow notifications", () {}),
        Divider(color: Colors.grey[300], thickness: 1),
        _buildArrowRow(Icons.medical_information_outlined,
            "Upload/ Update Profile Picture", () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DoctorUpdateProfileImage()));
        }),
        Divider(color: Colors.grey[300], thickness: 1),
        _buildNoArrowRow(context, Icons.logout, "Log out", () {
          context.read<DataStore>().updateDoctorData(null);
          context.read<ChatStore>().resetStore();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => DashboardPage()));
        }),
      ],
    );
  }

  Widget _buildModeToggleRow(BuildContext context, IconData icon, String label,
      VoidCallback onToggle) {
    return InkWell(
      onTap: onToggle,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
        child: Row(
          children: [
            Icon(icon, size: 20),
            SizedBox(width: 8),
            Expanded(
              child: Text(label),
            ),
            Transform.scale(
              scale: 0.8,
              child: Switch(
                value: Theme.of(context).brightness == Brightness.dark,
                onChanged: (value) {
                  onToggle();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildNotifToggleRow(
      IconData icon, String label, VoidCallback onToggle) {
    return InkWell(
      onTap: onToggle,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
        child: Row(
          children: [
            Icon(icon, size: 20),
            SizedBox(width: 8),
            Expanded(
              child: Text(label),
            ),
            Transform.scale(
              scale: 0.8,
              child: Switch(
                value: true,
                onChanged: (value) {
                  onToggle();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildArrowRow(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
        child: Row(
          children: [
            Icon(icon, size: 20),
            SizedBox(width: 8),
            Text(label),
            Spacer(),
            Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  // Update this function to use pushReplacement and ensure the user cannot go back
  Widget _buildNoArrowRow(
      BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap, // Pass the onTap function
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
        child: Row(
          children: [
            Icon(icon, size: 20),
            SizedBox(width: 8),
            Text(label),
          ],
        ),
      ),
    );
  }

  void _showPasswordPopup() {
    // Show dialog for changing password
  }

  void _showPinPopup() {
    // Show dialog for changing transaction pin
  }
}

class ManagePaymentsDoctor extends StatefulWidget {
  @override
  ManagePaymentsDoctorState createState() => ManagePaymentsDoctorState();
}

class ManagePaymentsDoctorState extends State<ManagePaymentsDoctor> {
  String backendUrl = dotenv.env['API_URL']!;

  void _showAddBankAccountPopup(int doctorId) {
    final TextEditingController bankNameController = TextEditingController();
    final TextEditingController accountNumberController =
        TextEditingController();
    final TextEditingController accountHolderController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add a new bank account'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: bankNameController,
                  decoration: InputDecoration(labelText: 'Bank name'),
                ),
                TextField(
                  controller: accountNumberController,
                  decoration: InputDecoration(labelText: 'Account No.'),
                ),
                TextField(
                  controller: accountHolderController,
                  decoration: InputDecoration(labelText: 'Account name'),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                Map paymentData = {
                  'accountHolder': accountHolderController.text,
                  'bankName': bankNameController.text,
                  'accountNumber': accountNumberController.text,
                  'user': doctorId
                };
                try {
                  final response = await http.post(
                    Uri.parse('$backendUrl/api/payments'),
                    headers: {
                      'Content-Type': 'application/json',
                    },
                    body: jsonEncode({'data': paymentData}),
                  );

                  if (response.statusCode == 200) {
                    context.read<DataStore>().addPayment(paymentData);

                    Fluttertoast.showToast(
                      msg: 'Saved successfully',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );

                    Navigator.of(context).pop();
                  } else {
                    throw Exception('Failed to delete');
                  }
                } catch (e) {
                  Fluttertoast.showToast(
                    msg: 'Failed. Please try again',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 3,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                  print('Error: $e');
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(listIndex, id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm delete'),
          content: Text('Are you sure you want to delete this bank account?'),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                Fluttertoast.showToast(
                  msg: 'Deleting...',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
                try {
                  final response = await http
                      .delete(Uri.parse('$backendUrl/api/payments/$id'));

                  if (response.statusCode == 200) {
                    context.read<DataStore>().removePayment(listIndex);

                    Fluttertoast.showToast(
                      msg: 'Deleted successfully',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );

                    Navigator.of(context).pop();
                  } else {
                    Fluttertoast.showToast(
                      msg: 'Failed. Please try again',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 3,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                    print('Failed to delete payment from backend');
                  }
                } catch (e) {
                  Fluttertoast.showToast(
                    msg: 'Failed. Please try again',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 3,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                  print('Error: $e');
                }
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Map? doctorData = context.watch<DataStore>().doctorData;
    return Scaffold(
      appBar: DoctorAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bank accounts',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ImportantRemindersWidget(),
            Divider(thickness: 2),
            Expanded(
              child: doctorData?['payments'] != null &&
                      doctorData?['payments'].isNotEmpty
                  ? ListView.builder(
                      itemCount: doctorData?['payments'].length,
                      itemBuilder: (context, index) {
                        var payment = doctorData?['payments'][index];
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: DottedBorder(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                            strokeWidth: 2,
                            dashPattern: [6, 3],
                            borderType: BorderType.RRect,
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          payment['accountHolder'] ?? 'No Name',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                            'Bank: ${payment['bankName'] ?? 'No Bank Name'}'),
                                        Text(
                                            'Account Number: ${payment['accountNumber'] ?? 'No Account'}'),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  SizedBox(
                                    width: 80,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? Colors.grey[700]
                                                : Colors.grey[400],
                                        foregroundColor:
                                            Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? Colors.white
                                                : Colors.black,
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: () =>
                                          _confirmDelete(index, payment['id']),
                                      child: Text('Delete'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'No bank accounts added yet',
                        style: TextStyle(
                            fontSize: 16, fontStyle: FontStyle.italic),
                      ),
                    ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => _showAddBankAccountPopup(doctorData?['id']),
                child: Text('Add a new bank account'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: DoctorBottomNavBar(),
    );
  }
}

class UpdateProfileDoctor extends StatefulWidget {
  @override
  UpdateProfileDoctorState createState() => UpdateProfileDoctorState();
}

class UpdateProfileDoctorState extends State<UpdateProfileDoctor> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  void _sendOTP(String type) {
    int otp = _generateOTP();
    // Call API to send OTP (Simulated here)
    print("Sending OTP $otp to $type");

    _showOTPPopup(type);
  }

  int _generateOTP() {
    var random = Random();
    return random.nextInt(900000) + 100000; // Generates a 6-digit OTP
  }

  void _showOTPPopup(String type) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter the OTP sent to your $type'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Enter OTP'),
              ),
              SizedBox(height: 10),
              Text("Did not receive code? Ask for resend"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Future<int> _updateDoctorProfile(doctorId) async {
    Fluttertoast.showToast(
      msg: 'Updating...',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    final String baseUrl = dotenv.env['API_URL']!;
    final Uri url = Uri.parse('$baseUrl/api/users/$doctorId');

    try {
      Map body = {
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'email': emailController.text,
        'phone': phoneNumberController.text
      };

      final response = await http.put(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(body));

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: 'Updated successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return 200;
      } else {
        throw Exception('Failed to update');
      }
    } catch (e) {
      print('this is the error: $e');
      Fluttertoast.showToast(
        msg: 'Failed to update data. Try again',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
    return 400;
  }

  @override
  Widget build(BuildContext context) {
    Map? doctorData = context.read<DataStore>().doctorData!;

    firstNameController.text = doctorData['firstName'] ?? '';
    lastNameController.text = doctorData['lastName'] ?? '';
    emailController.text = doctorData['email'] ?? '';
    phoneNumberController.text = doctorData['phone'] ?? '';

    return Scaffold(
      appBar: DoctorAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Text(
                'Update Profile',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Flex(
                    direction: Axis.vertical,
                    children: [
                      TextField(
                        controller: firstNameController,
                        decoration: InputDecoration(labelText: 'First Name'),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: lastNameController,
                        decoration: InputDecoration(labelText: 'Last Name'),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: phoneNumberController,
                              decoration:
                                  InputDecoration(labelText: 'Phone Number'),
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () => _sendOTP('number'),
                            child: Text('Verify'),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: emailController,
                              decoration: InputDecoration(labelText: 'Email'),
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () => _sendOTP('email'),
                            child: Text('Verify'),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            final updated =
                                await _updateDoctorProfile(doctorData['id']);
                            if (updated == 200) {
                              context.read<DataStore>().updateDoctorData({
                                ...doctorData,
                                'firstName': firstNameController.text,
                                'lastName': lastNameController.text,
                                'email': emailController.text,
                                'phone': phoneNumberController.text
                              });

                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 32,
                            ),
                            backgroundColor: const Color(0xFF617DEF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Update',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: DoctorBottomNavBar(),
    );
  }
}
