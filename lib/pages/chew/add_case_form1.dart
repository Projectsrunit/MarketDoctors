import 'package:flutter/material.dart';
import 'package:market_doctor/data_store.dart';
import 'package:market_doctor/pages/chew/add_case_form2.dart';
import 'package:market_doctor/pages/chew/bottom_nav_bar.dart';
import 'package:market_doctor/pages/chew/chew_app_bar.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class AddCaseFormOne extends StatefulWidget {
  final int? updatingId;

  const AddCaseFormOne({Key? key, this.updatingId}) : super(key: key);

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
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _heightController.addListener(_calcBmi);
    _weightController.addListener(_calcBmi);
    _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  void _calcBmi() {
    final height = double.tryParse(_heightController.text);
    final weight = double.tryParse(_weightController.text);

    if (height != null && weight != null) {
      _bmiController.text =
          ((weight / (height * height)).round() / 10 * 10).toString();
    } else {
      setState(() {
        _bmiController.text = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final datastore = context.read<DataStore>();
    int? chewId = context.watch<DataStore>().chewData?['id'];
    Map<String, dynamic> caseData = datastore.addCaseData['caseData']!;
    Map<String, dynamic> caseVisitData =
        datastore.addCaseData['caseVisitData']!;
    List<String> tempSymptoms = datastore.tempSymptoms;

    if (caseData.isNotEmpty) {
      _firstNameController.text = caseData['first_name'] ?? '';
      _lastNameController.text = caseData['last_name'] ?? '';
      _emailController.text = caseData['email'] ?? '';
      _phoneController.text = caseData['phone_number'] ?? '';
      _selectedGender = caseData['gender'];
      _ageController.text = caseData['age']?.toString() ?? '';
    }

    if (caseVisitData.isNotEmpty) {
      _prescriptionController.text = caseData['current_prescription'] ?? '';
      _chewsNotesController.text = caseData['chews_notes'] ?? '';
      _bloodPressureController.text =
          caseData['blood_pressure']?.toString() ?? '';
      _weightController.text = caseData['weight']?.toString() ?? '';
      _heightController.text = caseData['height']?.toString() ?? '';
      _bloodGlucoseController.text =
          caseData['blood_glucose']?.toString() ?? '';
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
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _ageController,
                        decoration: InputDecoration(
                          labelText: 'Age',
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    SizedBox(width: 10),
                    dateWidget(context),
                  ],
                ),
                SizedBox(height: 10),
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
                          _saveData();
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

  Expanded dateWidget(BuildContext context) {
    return Expanded(
      child: TextFormField(
        controller: _dateController,
        readOnly: true,
        decoration: const InputDecoration(
          labelText: 'Date registered',
          suffixIcon: Icon(Icons.calendar_today),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (pickedDate != null) {
            _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
          }
        },
      ),
    );
  }

  Future<void> _saveData() async {
    final caseData = {
      'first_name': _firstNameController.text,
      'last_name': _lastNameController.text,
      'gender': _selectedGender,
      'email': _emailController.text,
      if (_parseNumber(_ageController.text) != null)
        'age': _parseNumber(_ageController.text),
      if (_parseNumber(_phoneController.text) != null)
        'phone_number': _phoneController.text
    };

    final caseVisitData = {
      if (_parseNumber(_bloodPressureController.text) != null)
        'blood_pressure': _parseNumber(_bloodPressureController.text),
      if (_parseNumber(_weightController.text) != null)
        'weight': _parseNumber(_weightController.text),
      if (_parseNumber(_heightController.text) != null)
        'height': _parseNumber(_heightController.text),
      if (_parseNumber(_bloodGlucoseController.text) != null)
        'blood_glucose': _parseNumber(_bloodGlucoseController.text),
      'current_prescription': _prescriptionController.text,
      'symptoms': context.read<DataStore>().tempSymptoms,
      'chews_notes': _chewsNotesController.text,
      'date':
          DateFormat('yyyy-MM-dd').format(DateTime.parse(_dateController.text)),
    };

    context.read<DataStore>().changeTheCaseData(caseData);
    context.read<DataStore>().changeTheCaseVisitData(caseVisitData);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddCaseFormTwo()));
  }

  Future<void> _uploadData(chewId, [int? updatingId]) async {
    final caseData = {
      'first_name': _firstNameController.text,
      'last_name': _lastNameController.text,
      'gender': _selectedGender,
      'email': _emailController.text,
      if (_parseNumber(_ageController.text) != null)
        'age': _parseNumber(_ageController.text),
      if (_parseNumber(_phoneController.text) != null)
        'phone_number': _phoneController.text,
      'chew': chewId
    };

    print('Date from controller: ${_dateController.text}');

    final caseVisitData = {
      if (_parseNumber(_bloodPressureController.text) != null)
        'blood_pressure': _parseNumber(_bloodPressureController.text),
      if (_parseNumber(_weightController.text) != null)
        'weight': _parseNumber(_weightController.text),
      if (_parseNumber(_heightController.text) != null)
        'height': _parseNumber(_heightController.text),
      if (_parseNumber(_bloodGlucoseController.text) != null)
        'blood_glucose': _parseNumber(_bloodGlucoseController.text),
      'current_prescription': _prescriptionController.text,
      'symptoms': context.read<DataStore>().tempSymptoms,
      'chews_notes': _chewsNotesController.text,
      'date':
          DateFormat('yyyy-MM-dd').format(DateTime.parse(_dateController.text)),
      if (updatingId != null) 'case': updatingId
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

    final Uri urlAdd = Uri.parse('$baseUrl/api/casewithvisit/add');
    final Uri urlEdit = Uri.parse('$baseUrl/api/casevisits');

    try {
      var response;
      if (updatingId == null) {

        response = await http.post(
          urlAdd,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'data': {'caseData': caseData, 'visitData': caseVisitData}
          }),
        );
      } else {
        response = await http.post(
          urlEdit,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({'data': caseVisitData}),
        );
      }

      if (response.statusCode == 200) {
        final datastore = context.read<DataStore>();
        datastore.changeTheCaseData({});
        datastore.updateCaseSymptom([]);
        datastore.changeTheCaseVisitData({});

        var jsoned = jsonDecode(response.body);
        context.read<DataStore>().addCase({...jsoned['case'], 'casevisits': [jsoned['caseVisit']]});

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
