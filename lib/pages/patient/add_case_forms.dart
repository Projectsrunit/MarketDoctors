import 'package:flutter/material.dart';
import 'package:market_doctor/pages/patient/bottom_nav_bar.dart';
import 'package:market_doctor/pages/patient/patient_app_bar.dart';

class AddCaseForms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PatientAppBar(),
      body: AddCaseForm1(),
      bottomNavigationBar: PatientBottomNavBar(),
    );
  }
}

class AddCaseForm1 extends StatefulWidget {
  @override
  AddCaseForm1State createState() => AddCaseForm1State();
}

class AddCaseForm1State extends State<AddCaseForm1> {
  String? _selectedDropDown1;
  String? _selectedDropDown2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
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
                      Text(
                        'Choose a partner',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[700]
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            value: _selectedDropDown1,
                            isExpanded: true,
                            items:
                                ['String1', 'String2', 'String3'].map((item) {
                              return DropdownMenuItem(
                                value: item,
                                child: Text(item),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedDropDown1 = value;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Outreach location',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[700]
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            value: _selectedDropDown2,
                            isExpanded: true,
                            items:
                                ['String4', 'String5', 'String6'].map((item) {
                              return DropdownMenuItem(
                                value: item,
                                child: Text(item),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedDropDown2 = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          FractionallySizedBox(
            widthFactor: 0.8,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddCaseForm2()),
                );
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
              child: Text("Proceed"),
            ),
          ),
        ],
      ),
    );
  }
}

class AddCaseForm2 extends StatefulWidget {
  @override
  AddCaseForm2State createState() => AddCaseForm2State();
}

class AddCaseForm2State extends State<AddCaseForm2> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedSex;
  String? _existingCondition;
  final TextEditingController _prescriptionController = TextEditingController();

  void pushNewCase() {
    print('going to push1');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PatientAppBar(),
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
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'example@example.com',
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          hintText: '123-456-7890',
                        ),
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
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
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
                            value: _selectedSex,
                            isExpanded: true,
                            items: ['Male', 'Female'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedSex = newValue;
                              });
                            },
                            hint: Text('Sex'),
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
                  controller: _prescriptionController,
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
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => AddCaseForm2()),
                        // );
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
      bottomNavigationBar: PatientBottomNavBar(),
    );
  }
}
