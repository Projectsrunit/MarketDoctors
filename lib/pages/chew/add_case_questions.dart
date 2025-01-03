import 'package:flutter/material.dart';
import 'package:market_doctor/main.dart';
import 'package:market_doctor/pages/chew/bottom_nav_bar.dart';
import 'package:market_doctor/pages/chew/chew_app_bar.dart';
import 'package:provider/provider.dart';

class AddCaseQuestions extends StatefulWidget {
  final String selectedKey;

  const AddCaseQuestions({
    Key? key,
    required this.selectedKey,
  }) : super(key: key);

  @override
  _AddCaseQuestionsState createState() => _AddCaseQuestionsState();
}

class _AddCaseQuestionsState extends State<AddCaseQuestions> {
  final Map<String, String?> selectedAnswers = {};

  @override
  Widget build(BuildContext context) {
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
                          // Answers in a Wrap (no background)
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: answers.map((answer) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedAnswers[questionText] = answer;
                                  });
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio<String>(
                                      value: answer,
                                      groupValue: selectedAnswers[questionText],
                                      onChanged: (String? value) {
                                        setState(() {
                                          selectedAnswers[questionText] = value;
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
