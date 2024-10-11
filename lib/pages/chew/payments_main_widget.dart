import 'package:flutter/material.dart';
import 'package:market_doctor/main.dart';
import 'package:market_doctor/pages/chew/bottom_nav_bar.dart';
import 'package:market_doctor/pages/chew/chew_app_bar.dart';
import 'package:provider/provider.dart';

class PaymentsMainWidget extends StatefulWidget {
  @override
  PaymentsMainWidgetState createState() => PaymentsMainWidgetState();
}

class PaymentsMainWidgetState extends State<PaymentsMainWidget> {
  bool _isPaymentsSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChewAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isPaymentsSelected
                          ? Color(0xFF617DEF)
                          : Colors.white,
                      foregroundColor: _isPaymentsSelected
                          ? Colors.white
                          : Color(0xFF617DEF),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8), // Rounded corners
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _isPaymentsSelected = true;
                      });
                    },
                    child: Text('Payments'),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !_isPaymentsSelected
                          ? Color(0xFF617DEF)
                          : Colors.white,
                      foregroundColor: !_isPaymentsSelected
                          ? Colors.white
                          : Color(0xFF617DEF),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8), // Rounded corners
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _isPaymentsSelected = false;
                      });
                    },
                    child: Text('My Earnings'),
                  ),
                ),
              ],
            ),
            _isPaymentsSelected ? PaymentsWidget() : MyEarningsWidget(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

class PaymentsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List? cases = context.watch<DataStore>().chewData?['cases'];
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Add search functionality here
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    minimumSize: Size(40, 40),
                    backgroundColor:Colors.grey[700],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Search users'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Cases',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Amount',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                if (cases != null)
                  ...cases
                      .map((caseItem) => PaymentCase(caseItem: caseItem))
                      ,
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentCase extends StatelessWidget {
  final Map caseItem;

  PaymentCase({required this.caseItem});

  int _calculateAge(String dateOfBirth) {
    DateTime dob = DateTime.parse(dateOfBirth);
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - dob.year;
    if (currentDate.month < dob.month ||
        (currentDate.month == dob.month && currentDate.day < dob.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${caseItem['first_name']} ${caseItem['last_name']}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Age: ${caseItem['date_of_birth'] != null ? _calculateAge(caseItem['date_of_birth']) : 'Not Set'}',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  'Location: ${caseItem['home_address'] ?? 'unset'}',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          // Column for amount input
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 80,
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 8,),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              foregroundColor: Colors.white,
              backgroundColor: Colors.grey[700]
            ),
            onPressed: () {
              // Handle button press
            },
            child: Text('Enter'),
          ),
        ],
      ),
    );
  }
}

class MyEarningsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ImportantRemindersWidget(),
        Divider(
          color: Theme.of(context).dividerColor, // Line color based on theme
          thickness: 1.0, // Line thickness
          height: 20.0, // Space above and below the line
        ),
        TextButton(
          onPressed: () {
            // Handle button press
          },
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).brightness == Brightness.light
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).primaryColor,
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            minimumSize: Size(0, 0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Download transaction history',
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                  ? Theme.of(context).colorScheme.onSurface
                  : Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
        ...List.generate(4, (index) => EarningsInstance(index: index)),
      ],
    );
  }
}

class ImportantRemindersWidget extends StatelessWidget {
  const ImportantRemindersWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.grey[200]
              : Colors.grey[800],
          borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Important reminders:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('1. Payments are disbursed on the last day of the month.'),
            Text('2. All account numbers must match the name of the profile.'),
            Text(
                '3. Earnings must be greater than N20,000 before disbursement is made.'),
          ],
        ),
      ),
    );
  }
}

class EarningsInstance extends StatelessWidget {
  final int index; // Add this parameter to pass the index

  EarningsInstance({required this.index});

  @override
  Widget build(BuildContext context) {
    // Generate random month and year
    final randomMonth = (DateTime.now().month + index) % 12 + 1;
    final randomYear = DateTime.now().year;

    // Generate random amount
    final randomAmount = (index + 1) * 5000;

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.grey[200]
              : Colors.grey[800],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$randomMonth/$randomYear'),
              Text('₦$randomAmount'),
            ],
          ),
        ),
      ),
    );
  }
}
