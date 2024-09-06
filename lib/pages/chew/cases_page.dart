import 'package:flutter/material.dart';

enum IconType { information, edit, delete }

class CasesPage extends StatefulWidget {
  @override
  _CasesPageState createState() => _CasesPageState();
}

class _CasesPageState extends State<CasesPage> {
  int? _activeIconIndex;
  int? _activeDetailsIndex;

  void _onIconTapped(int index, IconType iconType) {
    setState(() {
      if (_activeIconIndex == index) {
        // Toggle off
        _activeIconIndex = null;
        _activeDetailsIndex = null;
      } else {
        _activeIconIndex = index;
        if (iconType == IconType.delete) {
          _showDeleteConfirmationDialog(index);
        } else {
          _activeDetailsIndex = index;
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
                  _activeIconIndex = null;
                });
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Handle delete action
                setState(() {
                  _activeIconIndex = null;
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
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text('Search cases'),
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search cases...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Text(
          'Cases',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ...List.generate(6, (index) {
          return Column(
            children: [
              CaseInstance(
                index: index,
                isActive: _activeIconIndex == index,
                onIconTapped: (iconType) => _onIconTapped(index, iconType),
              ),
              if (_activeDetailsIndex == index)
                CaseInstanceDetails(
                  editable: _activeIconIndex == index &&
                      _activeIconIndex == index
                          ? true
                          : false,
                ),
            ],
          );
        }),
      ],
    );
  }
}

class CaseInstance extends StatelessWidget {
  final int index;
  final bool isActive;
  final Function(IconType) onIconTapped;

  CaseInstance({
    required this.index,
    required this.isActive,
    required this.onIconTapped,
  });

  @override
  Widget build(BuildContext context) {
    final Color iconColor = isActive ? Colors.blue : Colors.white;

    return Row(
      children: [
        Expanded(
          child: Text('Person ${index + 1}'),
        ),
        IconButton(
          icon: Icon(Icons.info, color: iconColor),
          onPressed: () => onIconTapped(IconType.information),
        ),
        IconButton(
          icon: Icon(Icons.edit, color: iconColor),
          onPressed: () => onIconTapped(IconType.edit),
        ),
        IconButton(
          icon: Icon(Icons.delete, color: iconColor),
          onPressed: () => onIconTapped(IconType.delete),
        ),
      ],
    );
  }
}

class CaseInstanceDetails extends StatefulWidget {
  final bool editable;

  CaseInstanceDetails({required this.editable});

  @override
  _CaseInstanceDetailsState createState() => _CaseInstanceDetailsState();
}

class _CaseInstanceDetailsState extends State<CaseInstanceDetails> {
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
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
    // Here you would make your API call and initialize the controllers with data
    // For example:
    // _fetchDataFromApi();
  }

  void _saveData() {
    // Handle save data to API
    // For example:
    // Api.saveData({
    //   'email': _emailController.text,
    //   'phone': _phoneController.text,
    //   // Add other fields here
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField('Email', _emailController),
        _buildTextField('Phone Number', _phoneController),
        SizedBox(height: 20),
        Text(
          'Medical Details',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        _buildTextField('Blood Pressure', _bloodPressureController, 'mmHg'),
        _buildTextField('Gender', _genderController),
        _buildTextField('Weight', _weightController, 'kg'),
        _buildTextField('Height', _heightController, 'cm'),
        _buildTextField('BMI', _bmiController),
        _buildTextField('Blood Glucose', _bloodGlucoseController, 'mg/dL'),
        _buildTextField('Existing Condition', _existingConditionController),
        _buildTextField('Current Prescription', _currentPrescriptionController),
        _buildTextArea('CHEW\'s Notes', _chewsNotesController),
        SizedBox(height: 20),
        if (widget.editable)
          ElevatedButton(
            onPressed: _saveData,
            child: Text('Save'),
          ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, [String? unit]) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        suffixText: unit,
        border: OutlineInputBorder(),
        enabled: widget.editable,
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