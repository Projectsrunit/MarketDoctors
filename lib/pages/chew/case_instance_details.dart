import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:market_doctor/data_store.dart';
import 'package:provider/provider.dart';
import 'package:market_doctor/pages/chew/add_case_form1.dart';

class CaseInstanceDetails extends StatefulWidget {
  final Map<String, dynamic> caseData;
  final bool editable;
  final int saveId;
  final int index;

  CaseInstanceDetails({
    super.key,
    required this.caseData,
    required this.editable,
    required this.saveId,
    required this.index,
  });

  @override
  State<CaseInstanceDetails> createState() => _CaseInstanceDetailsState();
}

class _CaseInstanceDetailsState extends State<CaseInstanceDetails> {
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  String? _selectedGender;
  String? selectedBodyPart;
  String? selectedCategory;
  String? selectedExample;
  List<Map<String, dynamic>> _controllersList = [];
  bool showAddSymptom = false;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.caseData['email']?.toString() ?? '';
    _phoneController.text = widget.caseData['phone_number']?.toString() ?? '';
    _ageController.text = widget.caseData['age']?.toString() ?? '';
    _selectedGender = widget.caseData['gender']?.isEmpty ?? true
        ? null
        : widget.caseData['gender'];

    _initializeCaseVisits();
  }

  void _initializeCaseVisits() {
    List<dynamic> caseVisits = widget.caseData['casevisits'] ?? [];

    _controllersList = caseVisits.map((visit) {
      var heightController =
          TextEditingController(text: visit['height']?.toString() ?? '');
      var weightController =
          TextEditingController(text: visit['weight']?.toString() ?? '');
      var bmiController = TextEditingController();

      heightController.addListener(
          () => _calcBmi(heightController, weightController, bmiController));
      weightController.addListener(
          () => _calcBmi(heightController, weightController, bmiController));

      return {
        'id': visit['id'].toString(),
        'date': visit['date'],
        'bloodPressure': TextEditingController(
            text: visit['blood_pressure']?.toString() ?? ''),
        'weight': weightController,
        'height': heightController,
        'bmi': bmiController,
        'bloodGlucose': TextEditingController(
            text: visit['blood_glucose']?.toString() ?? ''),
        'currentPrescription': TextEditingController(
            text: visit['current_prescription']?.toString() ?? ''),
        'chewsNotes':
            TextEditingController(text: visit['chews_notes']?.toString() ?? ''),
        'symptoms': List<String>.from(visit['symptoms'] ?? []),
      };
    }).toList();
  }

  void _calcBmi(TextEditingController heightCtrl,
      TextEditingController weightCtrl, TextEditingController bmiCtrl) {
    final height = double.tryParse(heightCtrl.text);
    final weight = double.tryParse(weightCtrl.text);

    if (height != null && weight != null && height > 0) {
      bmiCtrl.text = (weight * 10000 / (height * height)).toStringAsFixed(1);
    } else {
      bmiCtrl.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> caseVisits = widget.caseData['casevisits'] ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField('Email', _emailController),
          SizedBox(height: 4),
          _buildTextField('Phone Number', _phoneController),
          SizedBox(height: 4),
          _buildGenderDropdown(),
          SizedBox(height: 4),
          _buildTextField('Age', _ageController),
          SizedBox(height: 20),
          Text(
            'Medical Details',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ...caseVisits.asMap().entries.map((entry) {
            int index = entry.key;
            var visit = entry.value;
            Map<String, dynamic> controllers;            
            try {
              controllers = _controllersList[index];
            } catch (e) {
              return SizedBox();
            }
            return Container(
              margin: EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    visit['date']?.toString() ?? 'Unset Date',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  _buildTextField(
                      'Blood Pressure', controllers['bloodPressure'],
                      unit: 'mmHg', isDigitsOnly: true),
                  _buildTextField('Weight', controllers['weight'],
                      unit: 'kg', isDigitsOnly: true),
                  _buildTextField('Height', controllers['height'],
                      unit: 'cm', isDigitsOnly: true),
                  _buildTextField('Blood Glucose', controllers['bloodGlucose'],
                      unit: 'mg/dL', isDigitsOnly: true),
                  _buildTextField('Current Prescription',
                      controllers['currentPrescription']),
                  _buildTextArea('CHEW\'s Notes', controllers['chewsNotes']),
                  buildVisitSymptoms(context, controllers['symptoms']),
                ],
              ),
            );
          }),
          if (widget.editable)
            ElevatedButton(
              onPressed: () => _saveData(widget.index),
              child: Text('Save'),
            )
          else
            ElevatedButton(
              onPressed: () {
                Map<String, dynamic> caseData = {
                  'first_name': widget.caseData['first_name'],
                  'last_name': widget.caseData['last_name'],
                  'gender': _selectedGender,
                  'email': _emailController.text,
                  if (_parseNumber(_ageController.text) != null)
                    'age': _parseNumber(_ageController.text),
                  if (_parseNumber(_phoneController.text) != null)
                    'phone_number': _phoneController.text
                };
                final datastore = context.read<DataStore>();
                datastore.changeTheCaseData(caseData);
                datastore.setUpdatingId(widget.saveId);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddCaseFormOne()),
                );
              },
              child: Text('New Visit'),
            ),
        ],
      ),
    );
  }

  double? _parseNumber(String text) {
    final value = double.tryParse(text);
    return value;
  }

  Padding buildVisitSymptoms(BuildContext context, symptoms) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Symptoms',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            if (symptoms.isNotEmpty)
              ...symptoms.map(
                (symptom) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Card(
                    child: ListTile(
                      title: Text(symptom),
                      trailing: IconButton(
                        icon: Icon(Icons.delete,
                            color: widget.editable ? Colors.red : Colors.grey),
                        onPressed: () {
                          if (widget.editable) {
                            setState(() {
                              symptoms.remove(symptom);
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            if (symptoms.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text('No symptoms added'),
              ),
            const SizedBox(height: 16.0),
            if (showAddSymptom && widget.editable)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DropdownButton<String>(
                    value: selectedBodyPart,
                    hint: const Text('Choose body part'),
                    onChanged: (newValue) {
                      setState(() {
                        selectedBodyPart = newValue;
                        selectedCategory = null;
                        selectedExample = null;
                      });
                    },
                    items: context
                        .read<DataStore>()
                        .addCaseData['symptoms']!
                        .keys
                        .map<DropdownMenuItem<String>>(
                          (bodyPart) => DropdownMenuItem(
                            value: bodyPart,
                            child: Text(bodyPart),
                          ),
                        )
                        .toList(),
                  ),
                  if (selectedBodyPart != null)
                    DropdownButton<String>(
                      value: selectedCategory,
                      hint: const Text('Choose category'),
                      onChanged: (newValue) {
                        setState(() {
                          selectedCategory = newValue;
                          selectedExample = null;
                        });
                      },
                      items: context
                          .read<DataStore>()
                          .addCaseData['symptoms']![selectedBodyPart]!
                          .keys
                          .map<DropdownMenuItem<String>>(
                            (String category) => DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            ),
                          )
                          .toList(),
                    ),
                  if (selectedCategory != null)
                    DropdownButton<String>(
                      value: selectedExample,
                      hint: const Text('Choose symptom example'),
                      onChanged: (newValue) {
                        setState(() {
                          selectedExample = newValue;
                        });
                      },
                      items: context
                          .read<DataStore>()
                          .addCaseData['symptoms']![selectedBodyPart]![
                              selectedCategory]!
                          .map<DropdownMenuItem<String>>(
                            (String example) => DropdownMenuItem<String>(
                              value: example,
                              child: Text(example),
                            ),
                          )
                          .toList(),
                    ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: selectedExample == null
                            ? null
                            : () {
                                setState(() {
                                  symptoms.add(selectedExample!);
                                  showAddSymptom = false;
                                });
                              },
                        child: const Text('Add'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showAddSymptom = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                        ),
                        child: const Text('Back'),
                      ),
                    ],
                  ),
                ],
              )
            else if (widget.editable)
              Center(
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showAddSymptom = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context)
                              .textButtonTheme
                              .style
                              ?.backgroundColor
                              ?.resolve({}) ??
                          const Color(0xFF617DEF),
                      foregroundColor: Theme.of(context)
                              .textButtonTheme
                              .style
                              ?.foregroundColor
                              ?.resolve({}) ??
                          Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("Add Symptom"),
                  ),
                ),
              ),
          ],
        ));
  }

  Future<void> _saveData(index) async {
    Fluttertoast.showToast(
      msg: 'Saving...',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    Map<String, Map<String, dynamic>> updatedCaseVisits = {};
    List<Map<String, dynamic>> localCaseUpdates = [];

    for (var controllers in _controllersList) {
      String id = controllers['id'];
      var map = {
        if (_parseNumber(controllers['bloodPressure'].text) != null)
        'blood_pressure': _parseNumber(controllers['bloodPressure'].text),
        if (_parseNumber(controllers['weight'].text) != null)
        'weight': _parseNumber(controllers['weight'].text),
        if (_parseNumber(controllers['height'].text) != null)
        'height': _parseNumber(controllers['height'].text),
        if (_parseNumber(controllers['bloodGlucose'].text) != null)
        'blood_glucose': _parseNumber(controllers['bloodGlucose'].text),
        'current_prescription': controllers['currentPrescription'].text,
        'chews_notes': controllers['chewsNotes'].text,
        'symptoms': controllers['symptoms'],
      };
      updatedCaseVisits[id] = map;
      localCaseUpdates.add(map);
      localCaseUpdates.last['date'] = controllers['date']; //add date only this side
    }

    final String baseUrl = dotenv.env['API_URL']!;
    final Uri url =
        Uri.parse('$baseUrl/api/casewithvisit/edit');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'data': {'visitData': updatedCaseVisits}
        }),
      );

      if (response.statusCode == 200) {
        context.read<DataStore>().updateCase(index, localCaseUpdates);
        Fluttertoast.showToast(
          msg: 'Data successfully updated',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        print('this is the response ${response.body}');
        throw Exception('Something went wrong.');
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

  Widget _buildTextField(String label, TextEditingController controller,
      {String? unit, bool isDigitsOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          suffixText: unit,
          border: OutlineInputBorder(),
        ),
        keyboardType: isDigitsOnly
            ? TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        inputFormatters: isDigitsOnly
            ? <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ]
            : null,
        enabled: label == 'BMI' ? false : widget.editable,
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String?>(
      value: _selectedGender,
      onChanged: widget.editable
          ? (String? value) {
              setState(() {
                _selectedGender = value;
              });
            }
          : null,
      items: [null, 'Male', 'Female']
          .map((genderOption) => DropdownMenuItem<String?>(
                value: genderOption,
                child: Text(
                  genderOption ?? 'Select Gender',
                  style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black),
                ),
              ))
          .toList(),
      decoration: InputDecoration(
        labelText: 'Gender',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildTextArea(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      maxLines: 4,
      enabled: widget.editable,
    );
  }
}
