import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import this package for date formatting
import 'package:market_doctor/pages/patient/bottom_nav_bar.dart';
import 'package:market_doctor/pages/patient/patient_app_bar.dart';
import 'package:market_doctor/pages/patient/doctor_like_card.dart';

class DoctorAppointmentPag extends StatefulWidget {
  final Map<String, dynamic> doctorCard;

  DoctorAppointmentPag({required this.doctorCard});

  @override
  State<DoctorAppointmentPag> createState() => _DoctorAppointmentPagState();
}

class _DoctorAppointmentPagState extends State<DoctorAppointmentPag> {
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
            // Video, Call, and Chat icons with grey border
            // Spacing between icons and next section

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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildIcon(Icons.call),
                SizedBox(width: 10), // Spacing between icons
                _buildIcon(Icons.video_call),
                SizedBox(width: 10),
                _buildIcon(Icons.chat),
              ],
            ),

            SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // About doctor section
                      _buildAboutDoctorSection(),

                      // Consultation Fee section
                      _buildConsultationFeeSection(),

                      // Availability section
                      _buildAvailabilitySection(),
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
                      // Your button functionality here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context)
                              .textButtonTheme
                              .style
                              ?.backgroundColor
                              ?.resolve({}) ??
                          Colors.white,
                      foregroundColor: Theme.of(context)
                              .textButtonTheme
                              .style
                              ?.foregroundColor
                              ?.resolve({}) ??
                          Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text("Book Appointment"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: PatientBottomNavBar(),
    );
  }

  Widget _buildIcon(IconData icon) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey), // Grey border
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: Colors.blue),
    );
  }

  // About Doctor section
  Widget _buildAboutDoctorSection() {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About doctor',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.blue[800],
            ),
          ),
          SizedBox(height: 10),
          widget.doctorCard['about'] != null &&
                  widget.doctorCard['about'].isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: RichText(
                    text: TextSpan(
                      text: _isExpanded
                          ? widget.doctorCard['about'] // Full description
                          : widget.doctorCard['about'].substring(
                              0,
                              widget.doctorCard['about'].length > 100
                                  ? 100
                                  : widget.doctorCard['about']
                                      .length), // Shortened description
                      style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 16),
                      children: [
                        if (!_isExpanded &&
                            widget.doctorCard['about'].length > 100)
                          TextSpan(
                            text: '... read more',
                            style: TextStyle(
                              color:
                                  isDarkMode ? Colors.white : Colors.blue[800],
                            ),
                          ),
                      ],
                    ),
                  ),
                )
              : Text('No description provided',
                  style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  // Consultation Fee Section
  // Consultation Fee Section
  Widget _buildConsultationFeeSection() {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    var consultationFee = widget.doctorCard['consultation_fee'] != null
        ? double.tryParse(widget.doctorCard['consultation_fee'].toString()) ??
            0.0
        : 0.0;

    const double bookingFee = 1000.0; // Constant booking fee
    double totalFee = consultationFee + bookingFee; // Calculate total fee

    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        // color: Colors.white,
        color: isDarkMode ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Consultation Fee',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.blue[800],
                ),
              ),
              Text(
                'N${consultationFee.toStringAsFixed(1)}', // Displaying the consultation fee
                style: TextStyle(
                  fontSize: 18,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 10), // Add spacing between lines
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Booking Fee',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.blue[800],
                ),
              ),
              Text(
                'N${bookingFee.toStringAsFixed(1)}', // Displaying the constant booking fee
                style: TextStyle(
                  fontSize: 18,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 10), // Add spacing between lines
          Divider(), // Optional: Add a divider for clarity
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Fee',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.blue[800],
                ),
              ),
              Text(
                'N${totalFee.toStringAsFixed(1)}', // Displaying the total fee
                style: TextStyle(
                  fontSize: 18,
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Availability section with date and time centered
  // Availability section with date and time centered
  Widget _buildAvailabilitySection() {
    DateTime today = DateTime.now(); // Get today's date
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Filter availabilities to only include today and future dates
    List<dynamic> upcomingAvailabilities =
        widget.doctorCard['doctor_availabilities'].where((availability) {
      DateTime availabilityDate = DateTime.parse(availability['date']);
      return availabilityDate.isAfter(today) ||
          availabilityDate.isAtSameMomentAs(today);
    }).toList();

    return Center(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.0),
        margin: EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[800] : Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Availability',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.blue[800],
              ),
            ),
            SizedBox(height: 10),
            upcomingAvailabilities.isNotEmpty
                ? Column(
                    children: List.generate(
                      upcomingAvailabilities.length,
                      (index) {
                        var availability = upcomingAvailabilities[index];
                        var formattedDate = DateFormat('dd-MM-yyyy')
                            .format(DateTime.parse(availability['date']));
                        bool isTimeVisible = false;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isTimeVisible = !isTimeVisible;
                                  });
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    color: isDarkMode
                                        ? Colors.grey[800]
                                        : Colors.blue[50],
                                    borderRadius: BorderRadius.circular(8.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blue.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 6,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Date: $formattedDate',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: isDarkMode
                                              ? Colors.white
                                              : Colors.blue[700],
                                          fontSize: 18,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      if (isTimeVisible)
                                        Column(
                                          children: List.generate(
                                            availability['available_time']
                                                .length,
                                            (timeIndex) {
                                              var timeSlot =
                                                  availability['available_time']
                                                      [timeIndex];
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 5.0),
                                                child: Text(
                                                  '${timeSlot['start_time']} - ${timeSlot['end_time']}',
                                                  style: TextStyle(
                                                    color: isDarkMode
                                                        ? Colors.white
                                                        : Colors.grey[800],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  )
                : Text('No availability times provided',
                    style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
