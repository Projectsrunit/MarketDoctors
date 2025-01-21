import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_doctor/data_store.dart';
import 'package:market_doctor/pages/chew/bottom_nav_bar.dart';
import 'package:market_doctor/pages/chew/case_instance_details.dart';
import 'package:market_doctor/pages/chew/chew_app_bar.dart';
import 'package:http/http.dart' as http;
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
