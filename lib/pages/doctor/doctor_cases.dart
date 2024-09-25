import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:market_doctor/pages/doctor/bottom_nav_bar.dart';
import 'package:market_doctor/pages/doctor/doctor_appbar.dart';

enum IconType { information, edit, delete }

class DoctorCasesPage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String id;

  DoctorCasesPage(
      {required this.firstName, required this.lastName, required this.id});

  @override
  DoctorCasesPageState createState() => DoctorCasesPageState();
}

class DoctorCasesPageState extends State<DoctorCasesPage> {
  int? _activeCaseIndex;
  IconType? _activeIconType;
  List<dynamic> cases = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCases();
  }

  Future<void> fetchCases() async {
    final String baseUrl = dotenv.env['API_URL']!;
    final Uri url = Uri.parse('$baseUrl/api/cases?filters[chew][id]=11');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List<dynamic> data = jsonData['data'];
      setState(() {
        cases = data;
        isLoading = false;
      });
    } else {
      print('Failed to load doctors');
    }
  }

  void _onIconTapped(int caseIndex, IconType iconType) {
    setState(() {
      if (_activeCaseIndex == caseIndex && _activeIconType == iconType) {
        _activeCaseIndex = null;
        _activeIconType = null;
      } else {
        _activeCaseIndex = caseIndex;
        _activeIconType = iconType;

        if (iconType == IconType.delete) {
          _showDeleteConfirmationDialog(caseIndex);
        }
      }
    });
  }

  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Are you sure you want to delete this file?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _activeCaseIndex = null;
                  _activeIconType = null;
                });
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Handle delete action (you can add specific logic here)
                setState(() {
                  _activeCaseIndex = null;
                  _activeIconType = null;
                });
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          doctorAppBar(firstName: widget.firstName, lastName: widget.lastName),
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
                          child: TextField(
                            decoration: InputDecoration(
                              prefixIcon:
                                  const Icon(Icons.search, color: Colors.black),
                              hintText: 'Search Cases, Appointment , Pharmacy',
                              hintStyle: TextStyle(color: Colors.grey[500]),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                            ),
                          ),
                        ),
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
                    if (isLoading) ...[
                      SizedBox(
                        height: 100,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ] else if (cases.isNotEmpty)
                      ...cases.asMap().entries.map<Widget>((entry) {
                        final index = entry.key;
                        final caseData = entry.value;
                        return Column(
                          children: [
                            CaseInstance(
                              firstName: caseData['attributes']['first_name'],
                              lastName: caseData['attributes']['last_name'],
                              isActive: _activeCaseIndex == index,
                              activeIconType: _activeIconType,
                              onIconTapped: (iconType) =>
                                  _onIconTapped(index, iconType),
                            ),
                            if (_activeCaseIndex == index)
                              CaseInstanceDetails(
                                  editable: _activeCaseIndex == index &&
                                      _activeIconType == IconType.edit,
                                  saveId: caseData['id'],
                                  caseData: caseData['attributes']),
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
      bottomNavigationBar: DoctorBottomNavBar(
        firstName: widget.firstName,
        lastName: widget.lastName,
        id: widget.id,
      ),
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

  CaseInstanceDetails(
      {Key? key,
      required this.caseData,
      required this.editable,
      required this.saveId})
      : super(key: key);

  @override
  State<CaseInstanceDetails> createState() => _CaseInstanceDetailsState();
}

class _CaseInstanceDetailsState extends State<CaseInstanceDetails> {
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _homeAddressController = TextEditingController();
  final _bloodPressureController = TextEditingController();
  final _genderController = TextEditingController();
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
    _emailController.text = widget.caseData['email'] ?? '';
    _phoneController.text = widget.caseData['phone_number'] ?? '';
    _homeAddressController.text = widget.caseData['home_address'] ?? '';
    _dateOfBirthController.text = widget.caseData['date_of_birth'] ?? '';
    _bloodPressureController.text = widget.caseData['blood_pressure'] ?? '';
    _genderController.text = widget.caseData['gender'] ?? '';
    _weightController.text = widget.caseData['weight'] ?? '';
    _heightController.text = widget.caseData['height'] ?? '';
    _bmiController.text = widget.caseData['bmi'] ?? '';
    _bloodGlucoseController.text = widget.caseData['blood_glucose'] ?? '';
    _existingConditionController.text =
        widget.caseData['existing_condition'] ?? '';
    _currentPrescriptionController.text =
        widget.caseData['current_prescription'] ?? '';
    _chewsNotesController.text = widget.caseData['doctors_note'] ?? '';

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
              _buildTextField('Date Of Birth', _dateOfBirthController),
              SizedBox(
                height: 4,
              ),
              _buildGenderDropdown(_genderController),
              SizedBox(
                height: 4,
              ),
              _buildTextField('Phone Number', _phoneController),
              SizedBox(
                height: 4,
              ),
              _buildTextField('Address No', _homeAddressController),
              SizedBox(
                height: 4,
              ),
              _buildTextField('Email Address', _emailController),
              SizedBox(height: 20),
              Text(
                'Medical History',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildTextField(
                  'Blood Pressure', _bloodGlucoseController, 'mmHg'),
              SizedBox(
                height: 4,
              ),
              _buildTextField('Weight', _weightController, 'kg'),
              SizedBox(
                height: 4,
              ),
              _buildTextField('Height', _heightController, 'cm'),
              SizedBox(
                height: 4,
              ),
              _buildTextField('BMI', _bmiController),
              SizedBox(
                height: 4,
              ),
              _buildTextField(
                  'Blood Glucose', _bloodGlucoseController, 'mg/dL'),
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
              _buildTextArea('Doctor\'s Notes', _chewsNotesController),
              SizedBox(height: 20),
              if (widget.editable)
                ElevatedButton(
                  onPressed: () async {
                    await _saveData();
                  },
                  child: Text('Save'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveData() async {
    final String baseUrl = dotenv.env['API_URL']!;
    final Uri url = Uri.parse('$baseUrl/api/cases/${widget.saveId}');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': _emailController.text,
        'date_of_birth': _dateOfBirthController.text,
        'phone_number': _phoneController.text,
        'blood_pressure': _bloodPressureController.text,
        'gender': _genderController.text,
        'home_address': _homeAddressController.text,
        'weight': _weightController.text,
        'height': _heightController.text,
        'bmi': _bmiController.text,
        'blood_glucose': _bloodGlucoseController.text,
        'existing_condition': _existingConditionController.text,
        'current_prescription': _currentPrescriptionController.text,
        'doctor_note': _chewsNotesController.text,
        'chew': 11,
      }),
    );

    if (response.statusCode == 200) {
      print('Data successfully updated');
      // Handle success (e.g., show a confirmation message or navigate back)
    } else {
      print('Failed to update data: ${response.body}');
      // Handle failure (e.g., show an error message)
    }
  }

  Widget _buildTextField(String label, TextEditingController controller,
      [String? unit]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          suffixText: unit,
          border: OutlineInputBorder(),
        ),
        enabled: widget.editable,
      ),
    );
  }

  Widget _buildGenderDropdown(TextEditingController controller) {
    final String? gender = controller.text.isNotEmpty ? controller.text : null;

    return DropdownButtonFormField<String?>(
      value: gender,
      onChanged: widget.editable
          ? (String? value) {
              setState(() {
                controller.text = value ?? '';
              });
            }
          : null,
      items: ['Male', 'Female']
          .map((genderOption) => DropdownMenuItem<String?>(
                value: genderOption,
                child: Text(genderOption),
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
