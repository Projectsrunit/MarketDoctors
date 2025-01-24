import 'package:flutter/material.dart';
import 'package:market_doctor/data_store.dart';
import 'package:market_doctor/pages/chew/add_case_form2.dart';
import 'package:market_doctor/pages/chew/bottom_nav_bar.dart';
import 'package:market_doctor/pages/chew/chew_app_bar.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class AddCaseFormOne extends StatefulWidget {
  @override
  AddCaseFormOneState createState() => AddCaseFormOneState();
}

class AddCaseFormOneState extends State<AddCaseFormOne> {
  final _formKey = GlobalKey<FormState>();
  String _selectedGender = 'Male';
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
  // final TextEditingController _existingConditionController = TextEditingController();

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
    Map<String, dynamic> caseData =
        context.read<DataStore>().addCaseData['caseData']!;
    List<String> tempSymptoms = context.read<DataStore>().tempSymptoms;

    if (caseData.isNotEmpty) {
      _firstNameController.text = caseData['first_name'] ?? '';
      _lastNameController.text = caseData['last_name'] ?? '';
      _prescriptionController.text = caseData['current_prescription'] ?? '';
      _chewsNotesController.text = caseData['chews_notes'] ?? '';
      _emailController.text = caseData['email'] ?? '';
      _bloodPressureController.text =
          caseData['blood_pressure']?.toString() ?? '';
      _weightController.text = caseData['weight']?.toString() ?? '';
      _bmiController.text = caseData['bmi']?.toString() ?? '';
      _phoneController.text = caseData['phone_number'] ?? '';
      _heightController.text = caseData['height']?.toString() ?? '';
      _bloodGlucoseController.text =
          caseData['blood_glucose']?.toString() ?? '';
      _selectedGender = caseData['gender'];
    }

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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue,),
                ),
                SizedBox(height: 10),
                
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _firstNameController,
                        decoration: InputDecoration(
                          labelText: 'First Name *',
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
                          labelText: 'Last Name *',
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
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                          )),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'Phone Number *',
                        ),
                        // validator: (value) {
                        //   if (value == null || value.isEmpty) {
                        //     return 'This field is required';
                        //   }
                        //   return null;
                        // },
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Patient Medical Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue,),
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
                                child: Text(
                                  value,
                                  style: TextStyle(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedGender = newValue!;
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
                  'Symptoms',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue,),
                ),
                SizedBox(height: 10),
                if (tempSymptoms.isNotEmpty)
                  ...List<String>.from(tempSymptoms).map(
                    (symptom) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Card(
                        child: ListTile(
                          title: Text(symptom),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              tempSymptoms.remove(symptom);
                              context
                                  .read<DataStore>()
                                  .updateCaseSymptom(tempSymptoms);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                if (tempSymptoms.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('No symptoms added yet'),
                  ),
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
                      child: Text("Add Symptom"),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Prescriptions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue,),
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue,),
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
                SizedBox(height: 20),
                Center(
                  child: FractionallySizedBox(
                    widthFactor: 0.8,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _uploadData(chewId);
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
                      child: Text("Save Case Data"),
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
      'current_prescription': _prescriptionController.text,
      'symptoms': context.read<DataStore>().tempSymptoms,
      'chews_notes': _chewsNotesController.text,
      'chew': chewId
    };

    context.read<DataStore>().changeTheCaseData(caseData);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddCaseFormTwo()));
  }

  Future<void> _uploadData(chewId) async {
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
      'current_prescription': _prescriptionController.text,
      'symptoms': context.read<DataStore>().tempSymptoms,
      'chews_notes': _chewsNotesController.text,
      'chew': chewId
    };

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
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'data': caseData}),
      );

      if (response.statusCode == 200) {
        context.read<DataStore>().changeTheCaseData({});
        context.read<DataStore>().updateCaseSymptom([]);
        var jsoned = jsonDecode(response.body);
        context.read<DataStore>().addCase(
            {'id': jsoned['data']['id'], ...jsoned['data']['attributes']});

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
            context, MaterialPageRoute(builder: (context) => AddCaseFormOne()));
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
    return value;
  }
}
