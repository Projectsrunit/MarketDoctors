import 'package:flutter/material.dart';
import 'package:market_doctor/data_store.dart';
import 'package:market_doctor/pages/chew/bottom_nav_bar.dart';
import 'package:market_doctor/pages/chew/chew_app_bar.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:market_doctor/pages/chew/add_case_form1.dart';

class AddCaseFormQue extends StatefulWidget {
  final String selectedKey;

  const AddCaseFormQue({
    super.key,
    required this.selectedKey,
  });

  @override
  AddCaseFormQueState createState() => AddCaseFormQueState();
}

class AddCaseFormQueState extends State<AddCaseFormQue> {
  final Map<String, dynamic> selectedAnswers = {};

  Future<void> _uploadData(selectedAnswers) async {
    final caseData = context.read<DataStore>().addCaseData['caseData'];
    caseData['questionnaire'] = selectedAnswers;

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
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PopScope(canPop: false, child: AddCaseFormOne())),
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

  @override
  Widget build(BuildContext context) {
    selectedAnswers['title'] = widget.selectedKey;
    final Map<String, List<String>>? questions = context
        .read<DataStore>()
        .addCaseData['questionnaire']?[widget.selectedKey];

    return Scaffold(
      appBar: ChewAppBar(),
      body: questions == null
          ? Center(child: Text('No questionnaire available'))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Pre-Treatment Questionnaire',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: questions.length + 1,
                    itemBuilder: (context, index) {
                      if (index == questions.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text('Back'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  print('Selected Answers: $selectedAnswers');
                                  _uploadData(selectedAnswers);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text('Save'),
                              ),
                            ],
                          ),
                        );
                      }

                      final questionText = questions.keys.elementAt(index);
                      final answers = questions.values.elementAt(index);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Grey background for the question text
                          Container(
                            margin: const EdgeInsets.only(bottom: 8.0),
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              '\u2022 $questionText',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: answers.asMap().entries.map((entry) {
                              int ind = entry.key;
                              var answer = entry.value;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedAnswers[questionText] = [
                                      answers,
                                      ind
                                    ];
                                  });
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio<String>(
                                      value: answer,
                                      groupValue: selectedAnswers[questionText] != null ? answers[selectedAnswers[questionText]![1]] : null,
                                      onChanged: (String? value) {
                                        setState(() {
                                          selectedAnswers[questionText] = [
                                      answers,
                                      ind
                                    ];
                                        });
                                      },
                                    ),
                                    Text(answer),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(
                              height: 16.0), // Spacing between questions
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
