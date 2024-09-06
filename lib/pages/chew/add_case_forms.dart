import 'package:flutter/material.dart';


class AddCaseForm1 extends StatefulWidget {
  final PageController pageController;

  AddCaseForm1({required this.pageController});

  @override
  _AddCaseForm1State createState() => _AddCaseForm1State();
}

class _AddCaseForm1State extends State<AddCaseForm1> {
  String? _selectedDropDown1;
  String? _selectedDropDown2;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Report a new case',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          'Choose partner',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        ),
        DropdownButton(
          value: _selectedDropDown1,
          items: ['String1', 'String2', 'String3'].map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedDropDown1 = value as String?;
            });
          },
        ),
        Text(
          'Outreach location',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        ),
        DropdownButton(
          value: _selectedDropDown2,
          items: ['String4', 'String5', 'String6'].map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedDropDown2 = value as String?;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(),
            TextButton(
              onPressed: () {
                widget.pageController.jumpToPage(6);
              },
              child: Text("Next"),
            ),
          ],
        ),
      ],
    );
  }
}

class AddCaseForm3 extends StatefulWidget {
  final void Function() pushNewCase;

  AddCaseForm3({required this.pushNewCase});

  @override
  _AddCaseForm3State createState() => _AddCaseForm3State();
}

class _AddCaseForm3State extends State<AddCaseForm3> {
  final _formKey = GlobalKey<FormState>();
  String? _existingCondition;
  final TextEditingController _prescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading: Existing Condition
            Text(
              'Existing Condition',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Dropdown for Existing Condition
            DropdownButtonFormField<String>(
              value: _existingCondition,
              decoration: InputDecoration(
                labelText: 'Select an option',
              ),
              items: ['Yes', 'No', 'Another'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _existingCondition = value;
                });
              },
            ),
            SizedBox(height: 20),

            // Heading: Current Prescriptions
            Text(
              'Current Prescriptions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // TextArea for Current Prescriptions
            TextFormField(
              controller: _prescriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Enter current prescriptions',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Finish button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Perform actions like saving form data
                    widget.pushNewCase();
                  }
                },
                child: Text('Finish'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddCaseForm2 extends StatefulWidget {
  final PageController pageController;

  AddCaseForm2({required this.pageController});

  @override
  _AddCaseForm2State createState() => _AddCaseForm2State();
}

class _AddCaseForm2State extends State<AddCaseForm2> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading: Patient Personal Details
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
                    decoration: InputDecoration(
                      labelText: 'First Name',
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Contact Details'),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'example@example.com',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Phone Number',
                hintText: '123-456-7890',
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),

            // Heading: Patient Medical Details
            Text(
              'Patient Medical Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Medical Inputs: Blood Pressure, Height, Weight, BMI, etc.
            Row(
              children: [
                Expanded(
                  child: TextFormField(
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
                    decoration: InputDecoration(
                      labelText: 'Height',
                      suffixText: 'cm',
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
                    decoration: InputDecoration(
                      labelText: 'BMI',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Gender selection
            Text('Gender'),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Male'),
                    value: 'Male',
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Female'),
                    value: 'Female',
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                  ),
                ),
              ],
            ),

            // Blood Glucose Input
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Blood Glucose',
                suffixText: 'mg/dL',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),

            // Next button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.pageController.jumpToPage(7);
                  }
                },
                child: Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
