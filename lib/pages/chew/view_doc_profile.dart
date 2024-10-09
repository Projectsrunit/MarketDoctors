import 'package:flutter/material.dart';
import 'package:market_doctor/pages/chew/bottom_nav_bar.dart';
import 'package:market_doctor/pages/chew/chatting_page.dart';
import 'package:market_doctor/pages/chew/chew_app_bar.dart';
import 'package:market_doctor/pages/chew/doctor_like_card.dart';
import 'package:intl/intl.dart';

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
      appBar: ChewAppBar(),
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
              onChatPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChattingPage(
                            doctorName:
                                'Dr. ${widget.doctorCard['firstName']} ${widget.doctorCard['lastName']}',
                            doctorImage: widget.doctorCard['profile_picture'] ??
                                'https://res.cloudinary.com/dqkofl9se/image/upload/v1727171512/Mobklinic/qq_jz1abw.jpg',
                            doctorPhoneNumber: widget.doctorCard['phone'],
                            doctorId: widget.doctorCard['id'],
                          ))),
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
                      Flex(
                        direction: Axis.vertical,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            (widget.doctorCard['doctor_appoint'] != null &&
                                    widget
                                        .doctorCard['doctor_appoint'].isNotEmpty
                                ? '${widget.doctorCard['doctor_appoint'].length}+'
                                : '1+'),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'patients',
                            style: TextStyle(fontSize: 14),
                          )
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
                            (widget.doctorCard['years_of_experience'] != null
                                ? '${widget.doctorCard['years_of_experience']} years'
                                : '1+ years'),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'experience',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 30),
                      SizedBox(width: 5),
                      Container(
                        constraints: BoxConstraints(maxWidth: 100),
                        child: Text(
                          widget.doctorCard['facility'] ?? 'Nigeria',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
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
                            fontSize: 18, fontWeight: FontWeight.bold),
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
                            text: widget.doctorCard['about'] == null
                                ? 'Doctor\'s description not yet set'
                                : (_isExpanded
                                    ? (widget.doctorCard['about']!.length > 150
                                        ? widget.doctorCard['about']
                                                .substring(0, 150) +
                                            '... read more'
                                        : widget.doctorCard['about'])
                                    : widget.doctorCard['about']),
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Availability',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      widget.doctorCard['doctor_availabilities'] != null &&
                              widget.doctorCard['doctor_availabilities']
                                  .isNotEmpty
                          ? SizedBox(
                              height: widget.doctorCard['doctor_availabilities']
                                          .length >
                                      3
                                  ? 100
                                  : (widget.doctorCard['doctor_availabilities']
                                          .length *
                                      40.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: widget
                                      .doctorCard['doctor_availabilities']
                                      .map<Widget>((availability) {
                                    DateTime date =
                                        DateTime.parse(availability['date']);
                                    String dayOfWeek =
                                        DateFormat('EEE').format(date);
                                    String dayOfMonth = date.day.toString();
                                    String month =
                                        DateFormat('MMMM').format(date);
                                    return Column(
                                      children: availability['available_time']
                                          .map<Widget>((time) {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                '$dayOfWeek $dayOfMonth $month'),
                                            Text(
                                                '${time['start_time']} - ${time['end_time']}'),
                                          ],
                                        );
                                      }).toList(),
                                    );
                                  }).toList(),
                                ),
                              ),
                            )
                          : Text('No availability data available.'),
                      SizedBox(height: 20),
                      Text(
                        'Specialisation',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      widget.doctorCard['specialisation'] != null
                          ? Text(widget.doctorCard['specialisation'])
                          : Text('Undeclared'),
                      SizedBox(height: 20),
                      Text(
                        'Languages',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      widget.doctorCard['languages'] != null
                          ? Text(widget.doctorCard['languages'])
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChattingPage(
                            doctorName:
                                'Dr. ${widget.doctorCard['firstName']} ${widget.doctorCard['lastName']}',
                            doctorImage: widget.doctorCard['profile_picture'] ??
                                'https://res.cloudinary.com/dqkofl9se/image/upload/v1727171512/Mobklinic/qq_jz1abw.jpg',
                            doctorPhoneNumber: widget.doctorCard['phone'],
                            doctorId: widget.doctorCard['id'],
                          ),
                        ),
                      );
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
