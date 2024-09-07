import 'package:flutter/material.dart';

class StatsRow extends StatefulWidget {
  const StatsRow({Key? key}) : super(key: key);

  @override
  _StatsRowState createState() => _StatsRowState();
}

class _StatsRowState extends State<StatsRow> {
  int cases = 0;
  int doctorsOnline = 0;
  int users = 0;

  @override
  void initState() {
    super.initState();
    fetchStats();
  }

  Future<void> fetchStats() async {
    // Simulate fetching data from an API
    // await Future.delayed(Duration(seconds: 1)); // Replace this with actual API call
    setState(() {
      cases = 1000;
      doctorsOnline = 200;
      users = 5000;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding: EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatItem("Cases", cases,
              textColor: Colors.white, labelFontSize: 18),
          _buildStatItem("Doctors online", doctorsOnline,
              textColor: Colors.white, labelFontSize: 18),
          _buildStatItem("Users", users,
              textColor: Colors.white, labelFontSize: 18),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int value,
      {Color textColor = Colors.black, double labelFontSize = 14}) {
    return Column(
      children: [
        Text(
          "$value",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: labelFontSize,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
