import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:market_doctor/main.dart';
import 'dart:convert';
import 'package:market_doctor/pages/chew/bottom_nav_bar.dart';
import 'package:market_doctor/pages/chew/chew_app_bar.dart';
import 'package:provider/provider.dart';

class AddCaseForms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChewAppBar(),
      body: AddCaseForm1(),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

class AddCaseForm1 extends StatefulWidget {
  @override
  AddCaseForm1State createState() => AddCaseForm1State();
}

class AddCaseForm1State extends State<AddCaseForm1> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _choosePartnerController =
      TextEditingController();
  final TextEditingController _outreachLocationController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 60),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Text(
                            'Choose a partner',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: _choosePartnerController,
                          maxLines: 1,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'This field is required';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Text(
                            'Outreach location',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: _outreachLocationController,
                          // maxLines: 1,
                          decoration: InputDecoration(
                            // labelText: 'Location',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'This field is required';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          FractionallySizedBox(
            widthFactor: 0.8,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddCaseForm2(
                            outreach: _outreachLocationController.text,
                            partner: _choosePartnerController.text),
                      ));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context)
                        .textButtonTheme
                        .style
                        ?.backgroundColor
                        ?.resolve({}) ??
                    Colors.blue,
                foregroundColor: Theme.of(context)
                        .textButtonTheme
                        .style
                        ?.foregroundColor
                        ?.resolve({}) ??
                    Colors.white,
                padding: EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text("Proceed"),
            ),
          ),
        ],
      ),
    );
  }
}

class AddCaseForm2 extends StatefulWidget {
  final String outreach;
  final String partner;

  AddCaseForm2({required this.outreach, required this.partner});

  @override
  AddCaseForm2State createState() => AddCaseForm2State();
}

class AddCaseForm2State extends State<AddCaseForm2> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedGender;
  final TextEditingController _prescriptionController = TextEditingController();
  final TextEditingController _chewsNotesController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bloodGlucoseController = TextEditingController();
  final TextEditingController _bloodPressureController =
      TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _bmiController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _existingConditionController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _heightController.addListener(_calcBmi);
    _weightController.addListener(_calcBmi);
  }

  void _calcBmi() {
    final input1 = double.tryParse(_heightController.text);
    final input2 = double.tryParse(_weightController.text);

    if (input1 != null && input2 != null) {
      _bmiController.text = (((input2 * 10) / input1).round() / 10).toString();
    } else {
      setState(() {
        _bmiController.text = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int chewId = context.watch<DataStore>().chewData?['id'];

    return Scaffold(
      appBar: ChewAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Patient Personal Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text('Name'),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _firstNameController,
                        decoration: InputDecoration(
                          labelText: 'First Name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _lastNameController,
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text('Contact Details'),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Patient Medical Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _bloodPressureController,
                        decoration: InputDecoration(
                          labelText: 'Blood Pressure',
                          suffixText: 'mmHg',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _heightController,
                        decoration: InputDecoration(
                          labelText: 'Height',
                          suffixText: 'meters',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _weightController,
                        decoration: InputDecoration(
                          labelText: 'Weight',
                          suffixText: 'kg',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _bmiController,
                        decoration: InputDecoration(
                          labelText: 'BMI',
                        ),
                        keyboardType: TextInputType.number,
                        enabled: false,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _bloodGlucoseController,
                        decoration: InputDecoration(
                          labelText: 'Blood Glucose',
                          suffixText: 'mg/dL',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[700]
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedGender,
                            isExpanded: true,
                            items: ['Male', 'Female'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,
                                style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedGender = newValue;
                              });
                            },
                            hint: Text('Gender'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Existing Condition',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _existingConditionController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Enter existing condition',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Current Prescriptions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _prescriptionController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Enter current prescriptions',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'CHEW\'s notes',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _chewsNotesController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Enter note of a patient\'s health challenge',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    onPressed: () {
                      // Save button functionality
                    },
                    child: Text('Save'),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: FractionallySizedBox(
                    widthFactor: 0.8,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _saveData(chewId);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context)
                                .textButtonTheme
                                .style
                                ?.backgroundColor
                                ?.resolve({}) ??
                            Color(0xFF617DEF),
                        foregroundColor: Theme.of(context)
                                .textButtonTheme
                                .style
                                ?.foregroundColor
                                ?.resolve({}) ??
                            Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text("Finish"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }

  Future<void> _saveData(chewId) async {
    Fluttertoast.showToast(
          msg: 'Saving...',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
    final String baseUrl = dotenv.env['API_URL']!;
    final Uri url = Uri.parse('$baseUrl/api/cases');
    try {
      final caseData = {
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'gender': _selectedGender,
        'email': _emailController.text,
        if (_parseNumber(_phoneController.text) != null)
          'phone_number': _phoneController.text,
        if (_parseNumber(_bloodPressureController.text) != null)
          'blood_pressure': _parseNumber(_bloodPressureController.text),
        if (_parseNumber(_weightController.text) != null)
          'weight': _parseNumber(_weightController.text),
        if (_parseNumber(_heightController.text) != null)
          'height': _parseNumber(_heightController.text),
        if (_parseNumber(_bmiController.text) != null)
          'bmi': _parseNumber(_bmiController.text),
        if (_parseNumber(_bloodGlucoseController.text) != null)
          'blood_glucose': _parseNumber(_bloodGlucoseController.text),
        'existing_condition': _existingConditionController.text,
        'current_prescription': _prescriptionController.text,
        'chews_notes': _chewsNotesController.text,
        'chew': chewId
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'data': caseData}),
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: 'Case added successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PopScope(canPop: false, child: AddCaseForms())),
        );
      } else {
        print('this is the response ${response.body}');
        throw Exception('Something went wrong');
      }
    } catch (e) {
      print('this is the error: $e');
      Fluttertoast.showToast(
        msg: 'Failed. Please try again',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  double? _parseNumber(String text) {
    final value = double.tryParse(text);
    return value != null ? value : null;
  }
}
