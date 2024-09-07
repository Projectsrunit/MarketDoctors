import 'package:flutter/material.dart';

class PaymentsMainWidget extends StatefulWidget {
  @override
  _PaymentsMainWidgetState createState() => _PaymentsMainWidgetState();
}


class _PaymentsMainWidgetState extends State<PaymentsMainWidget> {
  bool _isPaymentsSelected = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isPaymentsSelected ? Colors.blue : Colors.white,
                  foregroundColor: _isPaymentsSelected ? Colors.white : Colors.blue,
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
                  backgroundColor: !_isPaymentsSelected ? Colors.blue : Colors.white,
                  foregroundColor: !_isPaymentsSelected ? Colors.white : Colors.blue,
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
    );
  }
}

class PaymentsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Search users',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextField(
          decoration: InputDecoration(
            hintText: 'Search...',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: Text('Cases', style: TextStyle(fontWeight: FontWeight.bold))),
            Expanded(child: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
        ...List.generate(6, (index) => PaymentCase(index: index)),
      ],
    );
  }
}

class PaymentCase extends StatelessWidget {
  final int index; // Add this parameter to pass the index

  PaymentCase({required this.index}); //

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('John Doe'),
              Text('Age: 30'),
              Text('Location: Lagos'),
            ],
          ),
        ),
        Text('₦${(index + 1) * 1000}'), // Random amount for example
      ],
    );
  }
}

class MyEarningsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Important reminders:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text('1. Payments are disbursed on the last day of the month.'),
        Text('2. All account numbers must match the name of the profile.'),
        Text('3. Earnings must be greater than N20,000 before disbursement is made.'),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Handle button press
          },
          child: Text('Download transaction history'),
        ),
        SizedBox(height: 20),
        ...List.generate(4, (index) => EarningsInstance(index: index)),
      ],
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('${randomMonth}/${randomYear}'),
        Text('₦${randomAmount}'),
      ],
    );
  }
}

