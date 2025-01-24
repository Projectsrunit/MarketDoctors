import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:market_doctor/data_store.dart';
import 'package:provider/provider.dart';

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
  final _bloodPressureController = TextEditingController();
  String? _selectedGender;
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _bmiController = TextEditingController();
  final _bloodGlucoseController = TextEditingController();
  final _existingConditionController = TextEditingController();
  final _currentPrescriptionController = TextEditingController();
  final _chewsNotesController = TextEditingController();
  List<String> symptoms = [];
  bool showAddSymptom = false;
  String? selectedBodyPart;
  String? selectedCategory;
  String? selectedExample;

  @override
  void initState() {
    super.initState();

    _emailController.text = widget.caseData['email']?.toString() ?? '';
    _phoneController.text = widget.caseData['phone_number']?.toString() ?? '';
    _bloodPressureController.text =
        widget.caseData['blood_pressure']?.toString() ?? '';
    _weightController.text = widget.caseData['weight']?.toString() ?? '';
    _heightController.text = widget.caseData['height']?.toString() ?? '';
    _bmiController.text = widget.caseData['bmi']?.toString() ?? '';
    _bloodGlucoseController.text =
        widget.caseData['blood_glucose']?.toString() ?? '';
    _existingConditionController.text =
        widget.caseData['existing_condition']?.toString() ?? '';
    _currentPrescriptionController.text =
        widget.caseData['current_prescription']?.toString() ?? '';
    _chewsNotesController.text =
        widget.caseData['chews_notes']?.toString() ?? '';

    _selectedGender = widget.caseData['gender']?.isEmpty ?? true
        ? null
        : widget.caseData['gender'];
    _heightController.addListener(_calcBmi);
    _weightController.addListener(_calcBmi);
    symptoms = List<String>.from(widget.caseData['symptoms']);
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 4,
              ),
              _buildTextField('Email', _emailController),
              SizedBox(
                height: 4,
              ),
              _buildTextField('Phone Number', _phoneController),
              SizedBox(height: 20),
              Text(
                'Medical Details',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              SizedBox(height: 10),
              _buildTextField('Blood Pressure', _bloodPressureController,
                  unit: 'mmHg', isDigitsOnly: true),
              SizedBox(
                height: 4,
              ),
              _buildGenderDropdown(),
              SizedBox(
                height: 4,
              ),
              _buildTextField('Weight', _weightController,
                  unit: 'kg', isDigitsOnly: true),
              SizedBox(
                height: 4,
              ),
              _buildTextField('Height', _heightController,
                  unit: 'meters', isDigitsOnly: true),
              SizedBox(
                height: 4,
              ),
              _buildTextField('BMI', _bmiController),
              SizedBox(
                height: 4,
              ),
              _buildTextField('Blood Glucose', _bloodGlucoseController,
                  unit: 'mg/dL', isDigitsOnly: true),
              SizedBox(
                height: 4,
              ),
              _buildTextField(
                  'Existing Condition', _existingConditionController),
              SizedBox(
                height: 4,
              ),
              _buildTextField(
                  'Current Prescription', _currentPrescriptionController),
              SizedBox(
                height: 4,
              ),
              _buildTextArea('CHEW\'s Notes', _chewsNotesController),
              SizedBox(height: 20),
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Symptoms',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
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
                                      color: widget.editable
                                          ? Colors.red
                                          : Colors.grey),
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
                                    .addCaseData['symptoms']![
                                        selectedBodyPart]![selectedCategory]!
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text("Add Symptom"),
                            ),
                          ),
                        ),
                    ],
                  )),
              if (widget.editable)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () => _saveData(widget.index),
                  child: Text(
                    'Save',
                  ),
                )
            ],
          ),
        ),
      ),
    );
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
    final String baseUrl = dotenv.env['API_URL']!;
    final Uri url = Uri.parse('$baseUrl/api/cases/${widget.saveId}');

    try {
      final updatedData = {
        'gender': _selectedGender,
        'email': _emailController.text,
        'phone_number': _phoneController.text,
        'blood_pressure': _bloodPressureController.text.isNotEmpty
            ? _bloodPressureController.text
            : null,
        'weight':
            _weightController.text.isNotEmpty ? _weightController.text : null,
        'height':
            _heightController.text.isNotEmpty ? _heightController.text : null,
        'bmi': _bmiController.text.isNotEmpty ? _bmiController.text : null,
        'blood_glucose': _bloodGlucoseController.text.isNotEmpty
            ? _bloodGlucoseController.text
            : null,
        'existing_condition': _existingConditionController.text,
        'current_prescription': _currentPrescriptionController.text,
        'symptoms': symptoms,
        'chews_notes': _chewsNotesController.text,
      };

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'data': updatedData}),
      );

      if (response.statusCode == 200) {
        context.read<DataStore>().updateCase(index, updatedData);
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
