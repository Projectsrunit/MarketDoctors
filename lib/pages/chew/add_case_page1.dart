import 'package:flutter/material.dart';
import 'package:market_doctor/main.dart';
import 'package:market_doctor/pages/chew/add_case_questions.dart';
import 'package:market_doctor/pages/chew/bottom_nav_bar.dart';
import 'package:market_doctor/pages/chew/chew_app_bar.dart';
import 'package:provider/provider.dart';

class AddCasePage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChewAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.48,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/silh.jpeg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 16,
                left: 16,
                child: Text(
                  'Click on body part for possible complications',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
              Positioned(
                top: 36,
                left: 16,
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Logic for the button
                      },
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(12),
                        backgroundColor:
                            Colors.white, // Button background color
                        foregroundColor: Colors.blue, // Icon color
                      ),
                      child: Icon(Icons.sync,
                          size: 24), // Replace with desired icon
                    ),
                    SizedBox(height: 8), // Spacing between the button and text
                    Text(
                      'Flip for Posterior view',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey, // Text color
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search body parts",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // Logic for search button
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    minimumSize:
                        Size(40, 40), // This makes button height consistent
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Icon(Icons.arrow_forward, color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<DataStore>().addCaseData['stage1Tap'] =
                                'Head';
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AddCaseSigns(buttonName: 'Head')));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            elevation: 8,
                            shadowColor: Colors.black.withOpacity(0.4),
                            padding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              side: BorderSide(
                                  color: Colors.grey[300]!, width: 1),
                            ),
                          ),
                          child: Text(
                            'Head',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<DataStore>().addCaseData['stage1Tap'] =
                                'Hand';
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AddCaseSigns(buttonName: 'Hand')));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            elevation: 8,
                            shadowColor: Colors.black.withOpacity(0.4),
                            padding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              side: BorderSide(
                                  color: Colors.grey[300]!, width: 1),
                            ),
                          ),
                          child: Text(
                            'Hand',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<DataStore>().addCaseData['stage1Tap'] =
                                'Neck';
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AddCaseSigns(buttonName: 'Neck')));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            elevation: 8,
                            shadowColor: Colors.black.withOpacity(0.4),
                            padding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              side: BorderSide(
                                  color: Colors.grey[300]!, width: 1),
                            ),
                          ),
                          child: Text(
                            'Neck',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<DataStore>().addCaseData['stage1Tap'] =
                                'Leg';
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AddCaseSigns(buttonName: 'Leg')));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            elevation: 8,
                            shadowColor: Colors.black.withOpacity(0.4),
                            padding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              side: BorderSide(
                                  color: Colors.grey[300]!, width: 1),
                            ),
                          ),
                          child: Text(
                            'Leg',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

class AddCaseSigns extends StatefulWidget {
  final String buttonName;

  AddCaseSigns({required this.buttonName});

  @override
  State<AddCaseSigns> createState() => _AddCaseSignsState();
}

class _AddCaseSignsState extends State<AddCaseSigns> {
  String? selectedItem;
  @override
  Widget build(BuildContext context) {
    final data =
        context.read<DataStore>().addCaseData['headings'][widget.buttonName];
    List? greyList = data['greyList'];
    List? whiteButtons = data['whiteButtons'];

    return Scaffold(
      appBar: ChewAppBar(),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.48,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/silh.jpeg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 16,
                left: 16,
                child: Text(
                  'Click on body part for possible complications',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
              Positioned(
                top: 36,
                left: 16,
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Logic for the button
                      },
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(12),
                        backgroundColor:
                            Colors.white, // Button background color
                        foregroundColor: Colors.blue, // Icon color
                      ),
                      child: Icon(Icons.sync,
                          size: 24), // Replace with desired icon
                    ),
                    SizedBox(height: 8), // Spacing between the button and text
                    Text(
                      'Flip for Posterior view',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey, // Text color
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Blue button heading
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: Text(widget.buttonName,
                          style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  SizedBox(height: 16),

                  if (whiteButtons != null)
                    Wrap(
                      spacing: 16, // Space between buttons horizontally
                      runSpacing: 16, // Space between rows of buttons
                      alignment: WrapAlignment.center,
                      children: whiteButtons.map((name) {
                        return ElevatedButton(
                          onPressed: () {
                            context.read<DataStore>().addCaseData['stage1Tap'] =
                                name;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AddCaseSigns(buttonName: name)));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            elevation: 4,
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      }).toList(),
                    ),
                  if (whiteButtons != null) SizedBox(height: 24),

                  // Grey area (if any)
                  if (greyList != null)
                    Container(
                        color: Colors.grey[300],
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        margin: EdgeInsets.only(
                            bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Possible Complications',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: greyList.map((item) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedItem = item;
                                    });
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddCaseQuestions(selectedKey: selectedItem!)));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: Text(
                                      item,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: selectedItem == item
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('Back', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
