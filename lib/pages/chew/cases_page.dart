import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_doctor/main.dart';
import 'package:market_doctor/pages/chew/bottom_nav_bar.dart';
import 'package:market_doctor/pages/chew/chew_app_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:market_doctor/pages/show_custom_toast.dart';
import 'package:provider/provider.dart';

enum IconType { information, edit, delete }

class CasesPage extends StatefulWidget {
  @override
  CasesPageState createState() => CasesPageState();
}

class CasesPageState extends State<CasesPage> {
  int? _activeCaseIndex;
  IconType? _activeIconType;

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _onIconTapped(int caseIndex, IconType iconType, [int? caseId]) {
    setState(() {
      if (_activeCaseIndex == caseIndex && _activeIconType == iconType) {
        _activeCaseIndex = null;
        _activeIconType = null;
      } else {
        _activeCaseIndex = caseIndex;
        _activeIconType = iconType;

        if (iconType == IconType.delete) {
          _showDeleteConfirmationDialog(caseIndex, caseId);
        }
      }
    });
  }

  void _showDeleteConfirmationDialog(int index, int? caseId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Are you sure you want to delete this case?',
            style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _activeCaseIndex = null;
                  _activeIconType = null;
                });
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () async {
                final String baseUrl = dotenv.env['API_URL']!;
                final Uri url = Uri.parse('$baseUrl/api/cases/$caseId');
                try {
                  final response = await http.delete(url);
                  if (response.statusCode == 200) {
                    context.read<DataStore>().removeCase(index);
                    Fluttertoast.showToast(
                      msg: 'Deleted successfully',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  } else {
                    print('this is the response ${response.body}');
                    throw Exception('Failed to delete');
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
                setState(() {
                  _activeCaseIndex = null;
                  _activeIconType = null;
                });
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void updateCases(int index, Map<String, dynamic> updatedCase) {
    // setState(() {
    //   cases[index] = {
    //     ...cases[index],
    //     'attributes': {...cases[index], ...updatedCase}
    //   };
    // });
  }

  @override
  Widget build(BuildContext context) {
    List? cases = context.watch<DataStore>().chewData?['cases'];

    return Scaffold(
      appBar: ChewAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Search cases",
                                hintStyle: GoogleFonts.nunito(
                                  textStyle: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 8), // Reduce vertical padding
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            // Handle search action
                          },
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(Icons.people),
                        Text(
                          'Cases',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ]),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (cases != null && cases.isNotEmpty)
                      ...cases.asMap().entries.map<Widget>((entry) {
                        final index = entry.key;
                        final caseData = entry.value;
                        return Column(
                          children: [
                            CaseInstance(
                              firstName: caseData['first_name'],
                              lastName: caseData['last_name'],
                              isActive: _activeCaseIndex == index,
                              activeIconType: _activeIconType,
                              onIconTapped: (iconType) => _onIconTapped(
                                  index, iconType, caseData['id']),
                            ),
                            if (_activeCaseIndex == index)
                              CaseInstanceDetails(
                                editable: _activeCaseIndex == index &&
                                    _activeIconType == IconType.edit,
                                saveId: caseData['id'],
                                caseData: Map<String, dynamic>.from(caseData),
                                index: index,
                              ),
                          ],
                        );
                      })
                    else ...[
                      SizedBox(
                        height: 100,
                        child: Center(child: Text('No Cases Currently')),
                      )
                    ]
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

class CaseInstance extends StatelessWidget {
  final String firstName;
  final String lastName;
  final bool isActive;
  final IconType? activeIconType;
  final Function(IconType) onIconTapped;

  CaseInstance({
    required this.firstName,
    required this.lastName,
    required this.isActive,
    required this.activeIconType,
    required this.onIconTapped,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.light;
    final Color infoIconColor =
        isActive && activeIconType == IconType.information
            ? Colors.blue
            : (isDarkMode ? Colors.black : Colors.white);
    final Color editIconColor = isActive && activeIconType == IconType.edit
        ? Colors.blue
        : (isDarkMode ? Colors.black : Colors.white);
    final Color deleteIconColor = isActive && activeIconType == IconType.delete
        ? Colors.blue
        : (isDarkMode ? Colors.black : Colors.white);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Text('$firstName $lastName'),
            ),
            IconButton(
              icon: Icon(Icons.info, color: infoIconColor),
              onPressed: () => onIconTapped(IconType.information),
            ),
            IconButton(
              icon: Icon(Icons.edit, color: editIconColor),
              onPressed: () => onIconTapped(IconType.edit),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: deleteIconColor),
              onPressed: () => onIconTapped(IconType.delete),
            ),
          ],
        ),
      ),
    );
  }
}

class CaseInstanceDetails extends StatefulWidget {
  final Map<String, dynamic> caseData;
  final bool editable;
  final int saveId;
  final int index;

  CaseInstanceDetails({
    Key? key,
    required this.caseData,
    required this.editable,
    required this.saveId,
    required this.index,
  }) : super(key: key);

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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveData(index) async {
showCustomToast(context, 'Saving...');
    final String baseUrl = dotenv.env['API_URL']!;
    final Uri url = Uri.parse('$baseUrl/api/cases/${widget.saveId}');
    try {
      final updatedData = {
        'gender': _selectedGender,
        'email': _emailController.text,
        'phone_number': _phoneController.text,
        'blood_pressure': _bloodPressureController.text.isNotEmpty ? _bloodPressureController.text : null,
        'weight': _weightController.text.isNotEmpty ? _weightController.text : null,
        'height': _heightController.text.isNotEmpty ? _heightController.text : null,
        'bmi': _bmiController.text.isNotEmpty ? _bmiController.text : null,
        'blood_glucose': _bloodGlucoseController.text.isNotEmpty ? _bloodGlucoseController.text : null,
        'existing_condition': _existingConditionController.text,
        'current_prescription': _currentPrescriptionController.text,
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
        showCustomToast(context, 'Data successfully updated');
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
