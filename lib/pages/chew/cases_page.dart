import 'package:flutter/material.dart';
import 'package:market_doctor/main.dart';
import 'package:market_doctor/pages/chew/bottom_nav_bar.dart';
import 'package:market_doctor/pages/chew/chew_app_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

enum IconType { information, edit, delete }

class CasesPage extends StatefulWidget {
  @override
  CasesPageState createState() => CasesPageState();
}

class CasesPageState extends State<CasesPage> {
  int? _activeCaseIndex;
  IconType? _activeIconType;
  List<dynamic> cases = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchCases();
  }

  Future<void> fetchCases() async {
    int chewId = context.watch<DataStore>().chewData?['user']['id'] ??
        11; //remove the 11 after testing

    final String baseUrl = dotenv.env['API_URL']!;
    final Uri url = Uri.parse('$baseUrl/api/cases?filters[chew][id]=$chewId');
    try {
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
    } catch (e) {
      print('this is the error: $e');
      Fluttertoast.showToast(
        msg: 'Failed to load. Try again',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
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
          title: Text('Are you sure you want to delete this case?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _activeCaseIndex = null;
                  _activeIconType = null;
                });
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final String baseUrl = dotenv.env['API_URL']!;
                final Uri url = Uri.parse('$baseUrl/api/cases/$caseId');
                try {
                  final response = await http.delete(url);
                  if (response.statusCode == 200) {
                    Fluttertoast.showToast(
                      msg: 'Deleted successfully',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                    setState(() {
                      cases.removeAt(index);
                    });
                  } else {
                    print('this is the response ${response.body}');
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
                }
                setState(() {
                  _activeCaseIndex = null;
                  _activeIconType = null;
                });
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void updateCases(int index, Map<String, dynamic> updatedCase) {
    setState(() {
      cases[index] = {
        ...cases[index],
        'attributes': {...cases[index]['attributes'], ...updatedCase}
      };
    });
  }

  @override
  Widget build(BuildContext context) {
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
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search cases...',
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
                              onIconTapped: (iconType) => _onIconTapped(
                                  index, iconType, caseData['id']),
                            ),
                            if (_activeCaseIndex == index)
                              CaseInstanceDetails(
                                editable: _activeCaseIndex == index &&
                                    _activeIconType == IconType.edit,
                                saveId: caseData['id'],
                                caseData: Map<String, dynamic>.from(
                                    caseData['attributes']),
                                index: index,
                                updateCases: updateCases,
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
  final Function(int, Map<String, dynamic>) updateCases;

  CaseInstanceDetails(
      {Key? key,
      required this.caseData,
      required this.editable,
      required this.saveId,
      required this.index,
      required this.updateCases})
      : super(key: key);

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
    _selectedGender = widget.caseData['gender']?.isEmpty ?? true
        ? null
        : widget.caseData['gender'];
  }

  @override
  Widget build(BuildContext context) {
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
              _buildTextField(
                  'Blood Pressure', _bloodGlucoseController, 'mmHg'),
              SizedBox(
                height: 4,
              ),
              _buildGenderDropdown(),
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
              _buildTextArea('CHEW\'s Notes', _chewsNotesController),
              SizedBox(height: 20),
              if (widget.editable)
                ElevatedButton(
                  onPressed: () async {
                    final updatedData = await _saveData();
                    widget.updateCases(widget.index, updatedData);
                  },
                  child: Text('Save'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Map<String, Object?>> _saveData() async {
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
        Fluttertoast.showToast(
          msg: 'Data successfully updated',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return updatedData;
      } else {
        print('this is the response ${response.body}');
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
    return {};
  }

  double? _parseNumber(String text) {
    final value = double.tryParse(text);
    return value != null ? value : null;
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
                child: Text(genderOption ?? 'Select Gender'),
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
