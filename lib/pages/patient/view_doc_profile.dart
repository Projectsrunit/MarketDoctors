import 'package:flutter/material.dart';
import 'package:market_doctor/pages/chew/bottom_nav_bar.dart';
import 'package:market_doctor/pages/patient/patient_app_bar.dart';
import 'package:market_doctor/pages/chew/doctor_like_card.dart';

class ViewDocProfile extends StatefulWidget {
  final Map<String, dynamic> doctorCard;

  ViewDocProfile({required this.doctorCard});

  @override
  State<ViewDocProfile> createState() => _ViewDocProfileState();
}

class _ViewDocProfileState extends State<ViewDocProfile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PatientAppBar(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Flex(
          direction: Axis.vertical,
          children: [
            DocLikeCard(
              imageUrl: widget.doctorCard['profile_picture'] ??
                  'https://res.cloudinary.com/dqkofl9se/image/upload/v1727171512/Mobklinic/qq_jz1abw.jpg',
              name:
                  'Dr. ${widget.doctorCard['firstName']} ${widget.doctorCard['lastName']}',
              profession: (widget.doctorCard['specialisation'] != null &&
                      widget.doctorCard['specialisation'].isNotEmpty)
                  ? widget.doctorCard['specialisation']
                  : 'General Practice',
              rating: 4.5,
              onChatPressed: () {},
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Icon(Icons.groups, size: 30),
                      SizedBox(width: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '1000+',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text('patients'),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.work, size: 30),
                      SizedBox(width: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '10 years',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'experience',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 30),
                      SizedBox(width: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Any District', style: TextStyle(fontSize: 14)),
                          Text('Nigeria', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About doctor',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                        },
                        child: RichText(
                          text: TextSpan(
                            text: _isExpanded
                                ? widget.doctorCard['email']
                                : widget.doctorCard['createdAt'],
                            style: TextStyle(color: Colors.black),
                            children: [
                              if (!_isExpanded)
                                TextSpan(
                                  text: '... read more',
                                  style: TextStyle(color: Colors.blue),
                                ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Availability',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Monday-Friday'),
                          Text('9am - 5pm'),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Specialisation',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      widget.doctorCard['specialisation'] != null  ? 
                      Text(widget.doctorCard['specialisation']) : Text('Undeclared'),
                      SizedBox(height: 20),
                      Text(
                        'Languages',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      widget.doctorCard['languages'] != null &&
                              widget.doctorCard['languages'].isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                  widget.doctorCard['languages'].length,
                                  (index) {
                                return Text(
                                    widget.doctorCard['languages'][index]);
                              }),
                            )
                          : Text('Undeclared'),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Center(
                child: FractionallySizedBox(
                  widthFactor: 0.6,
                  child: ElevatedButton(
                    onPressed: () {
                      // if (_formKey.currentState!.validate()) {
                      //   Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => AddCaseForm2(
                      //             outreach: _outreachLocationController.text,
                      //             partner: _choosePartnerController.text),
                      //       ));
                      // }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context)
                              .textButtonTheme
                              .style
                              ?.backgroundColor
                              ?.resolve({}) ??
                          Colors.blue,
                      foregroundColor: Theme.of(context)
                              .textButtonTheme
                              .style
                              ?.foregroundColor
                              ?.resolve({}) ??
                          Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text("Send message"),
                  ),
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
