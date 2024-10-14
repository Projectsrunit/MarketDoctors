import 'package:flutter/material.dart';
import 'package:market_doctor/main.dart';
import 'package:market_doctor/pages/patient/chatting_page.dart';
import 'package:market_doctor/pages/patient/advertisement_carousel.dart';
import 'package:market_doctor/pages/patient/bottom_nav_bar.dart';
import 'package:market_doctor/pages/patient/hospital.dart';
import 'package:market_doctor/pages/patient/pharmacy.dart';
import 'package:market_doctor/pages/patient/doctor_view.dart';
import 'package:market_doctor/pages/patient/patient_app_bar.dart';
import 'package:market_doctor/pages/patient/book_appointment.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:market_doctor/pages/patient/doctor_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:market_doctor/pages/patient/view_doc_profile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_doctor/pages/choose_action.dart';

class PatientHome extends StatefulWidget {
  @override
  State<PatientHome> createState() => _PatientHomeState();
}

class _PatientHomeState extends State<PatientHome> {
  final int doctorsOnline = 0;
  final int users = 0;
  IO.Socket? socket;
  List<Map<String, dynamic>> unsentMessages = [];
  bool _isSocketInitialized = false;
  ChatStore? chatStore;

  @override
  void initState() {
    super.initState();
    if (!_isSocketInitialized) {
      _initializeSocket();
      _isSocketInitialized = true;
    }
    chatStore = context.read<ChatStore>();
    chatStore?.addListener(_sendPendingUpdates);
    chatStore?.addListener(_sendPendingUpdates);
  }

  @override
  void dispose() {
    super.dispose();
    socket?.disconnect();
    _isSocketInitialized = false;
  }

  void _initializeSocket() {
    ChatStore chatStore = context.read<ChatStore>();
    int? chewId =
        Provider.of<DataStore>(context, listen: false).chewData?['id'];

    if (chewId != null) {
      final String socketUrl = dotenv.env['API_URL']!;

      setState(() {
        socket = IO.io(socketUrl, <String, dynamic>{
          'transports': ['websocket'],
          'autoConnect': false,
        });

        socket!.connect();
        socket!.emit('authenticate', {'own_id': chewId});

        socket!.on('connect', (_) {
          print('Socket connected');
          _resendUnsentMessages();
        });

        socket!.on('unread_messages', (messages) {
          _handleArrayOfMessages(messages, chewId);
        });

        socket!.on('new_message', (message) {
          int docId = (message['sender'] == chewId)
              ? message['receiver']
              : message['sender'];
          chatStore.addMessage(message, docId);
        });

        socket!.on('older_messages', (messages) {
          _handleArrayOfMessages(messages, chewId);
        });

        socket!.on('delivery_status_updated', (message) {
          int docId = (message['sender'] == chewId)
              ? message['receiver']
              : message['sender'];
          chatStore.receiveDeliveryStatus(message, docId);
        });

        socket!.on('read_status_updated', (message) {
          int docId = (message['sender'] == chewId)
              ? message['receiver']
              : message['sender'];
          chatStore.receiveReadStatus(message, docId);
        });
      });

      socket!.on('disconnect', (_) {
        print('Socket disconnected');
        _isSocketInitialized = false;
      });
    }
  }

  void _resendUnsentMessages() {
    if (unsentMessages.isNotEmpty) {
      for (Map<String, dynamic> message in unsentMessages) {
        socket!.emit('new_message', message);
      }
      unsentMessages.clear();
    }
  }

  void _handleArrayOfMessages(List<dynamic> messages, int chewId) {
    final addMessage = context.read<ChatStore>().addMessage;

    for (Map<String, dynamic> message in messages) {
      int docId = (message['sender'] == chewId)
          ? message['receiver']
          : message['sender'];
      addMessage(message, docId);
    }
  }

  void _sendPendingUpdates() {
    ChatStore chatStore = context.read<ChatStore>();

    if (chatStore.latestMessage.isNotEmpty) {
      int messageId = chatStore.latestMessage['id'];
      if (socket!.connected) {
        socket!.emitWithAck(
          'new_message',
          chatStore.latestMessage,
          ack: (response) {
            if (response['success'] == true) {
              Map<String, dynamic> newMessage = response['message'];
              int docId = newMessage['receiver'];
              chatStore.addMessage(newMessage, docId);
              if (newMessage['id'] != messageId) {
                chatStore.removeMessage(docId, messageId);
              }
            } else {
              print('Error: ${response['error']}');
            }
          },
        );
      } else {
        setState(() {
          unsentMessages.add(chatStore.latestMessage);
        });
      }
      chatStore.resetNewMessageFlag();
    }

    if (chatStore.readStatusForId != null) {
      socket!.emit(
          'update_read_status', {'message_id': chatStore.readStatusForId});
      chatStore.resetReadId();
    }

    if (chatStore.deliveryStatusForId != null) {
      socket!.emit('update_delivery_status',
          {'message_id': chatStore.deliveryStatusForId});
      chatStore.resetDeliveryId();
    }

    if (chatStore.getOlderMessagesFor != null) {
      socket!.emit('get_older_messages', chatStore.getOlderMessagesFor);
      chatStore.resetOlderMessages();
    }
  }

  @override
  Widget build(BuildContext context) {
    Map? patientData = Provider.of<DataStore>(context).patientData;

    if (patientData == null) {
      return PopScope(canPop: false, child: ChooseActionPage());
    } else {
      return PopScope(
        canPop: false,
        child: Scaffold(
          appBar: PatientAppBar(),
          body: PatientHomeBody(),
          bottomNavigationBar: PatientBottomNavBar(),
        ),
      );
    }
  }
}

class PatientHomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Advertisement carousel
          Container(
            margin: EdgeInsets.only(bottom: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40, // Adjust the height as needed
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search doctor, field, drugs",
                        hintStyle: GoogleFonts.nunito(
                          textStyle: TextStyle(
                            fontSize: 14, // Adjust the font size as needed
                            fontWeight: FontWeight
                                .normal, // Change the weight if necessary
                            color: Colors
                                .grey, // Change the color if you want a different hint color
                          ),
                        ),
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10), // Reduce vertical padding
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    // Add search functionality here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    'Search',
                    style: GoogleFonts.nunito(
                      textStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Remaining widgets...
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Cases icon
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HospitalListPage()));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(28.0),
                        color: Colors.lightBlue[50], // Light blue background
                        child: Icon(
                          FontAwesomeIcons.hospital,
                          size: 40,
                          color: Colors.blue, // Blue icon
                        ),
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      'Hospitals',
                      style: GoogleFonts.nunito(
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 5.0),
              // Doctors icon
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DoctorView()));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(28.0),
                        color: Colors.lightBlue[50], // Light blue background
                        child: Icon(
                          FontAwesomeIcons.stethoscope,
                          size: 40,
                          color: Colors.blue, // Blue icon
                        ),
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      'Doctors',
                      style: GoogleFonts.nunito(
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 5.0),
              // Patients icon
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PharmacyListPage()));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(28.0),
                        color: Colors.lightBlue[50], // Light blue background
                        child: Icon(
                          FontAwesomeIcons.pills,
                          size: 40,
                          color: Colors.blue, // Blue icon
                        ),
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      'Pharmacy',
                      style: GoogleFonts.nunito(
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Container(
              height: 170,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: Row(children: [
                AdvertisementCarousel(),
              ])),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popular Doctors',
                style: GoogleFonts.nunito(
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DoctorView()));
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: const Color.fromARGB(0, 202, 23, 23),
                ),
                child: Text(
                  'See all',
                  style: GoogleFonts.nunito(
                    textStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Populars(),
        ],
      ),
    );
  }
}

class Populars extends StatefulWidget {
  @override
  PopularsState createState() => PopularsState();
}

class PopularsState extends State<Populars> {
  List<dynamic> doctors = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    final String baseUrl =
        dotenv.env['API_URL']!; // Ensure this is correctly set
    final Uri url = Uri.parse(
        '$baseUrl/api/users?filters[role][\$eq]=3&populate=*&pagination[pageSize]=2&pagination[start]=0');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        doctors = data.map((doctor) {
          String fullImageUrl =
              'https://res.cloudinary.com/dqkofl9se/image/upload/v1727171512/Mobklinic/qq_jz1abw.jpg'; // Default image with base URL

          // Check if profile_picture is not null and has a valid URL
          if (doctor['profile_picture'] != null
              // && doctor['profile_picture']['formats'] != null &&
              //     doctor['profile_picture']['formats']['thumbnail'] != null &&
              //     doctor['profile_picture']['formats']['thumbnail']['url'] != null
              ) {
            fullImageUrl = '${doctor['profile_picture']}';
          }

          doctor['full_image_url'] = fullImageUrl;
          return doctor;
        }).toList();
        isLoading = false;
      });
    } else {
      print('Failed to load doctors');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isLoading) ...[
          SizedBox(
            height: 100,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ] else if (doctors.isNotEmpty) ...[
          DoctorCard(
            imageUrl: doctors[0]['full_image_url'], // Use full_image_url
            name: 'Dr. ${doctors[0]['firstName']} ${doctors[0]['lastName']}',
            profession: doctors[0]['specialisation'] ?? 'General Practice',
            rating: doctors[0]['total_overall_rating'] != null
                ? doctors[0]['total_overall_rating'] /
                    (doctors[0]['total_raters'] ?? 1)
                : 0,
            onChatPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChattingPage(
                                  guestId: doctors[0]['id'],
                                  guestName: '${doctors[0]['firstName']} ${doctors[0]['lastName']}',
                                  guestImage: doctors[0]['profile_picture'] ??
                                      'https://res.cloudinary.com/dqkofl9se/image/upload/v1727171512/Mobklinic/qq_jz1abw.jpg',
                                  guestPhoneNumber: doctors[0]['phone'],
                                ))),
            onViewProfilePressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewDocProfile(doctorCard: doctors[0]),
                ),
              );
            },
            onBookAppointmentPressed: () {
               Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DoctorAppointmentPag(doctorCard: doctors[0]),
                ),
              );
            },
          ),
          SizedBox(height: 16.0),
          if (doctors.length > 1) ...[
            DoctorCard(
              imageUrl: doctors[1]['full_image_url'], // Use full_image_url
              name: 'Dr. ${doctors[1]['firstName']} ${doctors[1]['lastName']}',
              profession: (doctors[1]['specialisation'] != null &&
                      doctors[1]['specialisation'].isNotEmpty)
                  ? doctors[1]['specialisation']
                  : 'General Practice',
              rating: 4.0,
              onChatPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChattingPage(
                                  guestId: doctors[1]['id'],
                                  guestName: '${doctors[1]['firstName']} ${doctors[1]['lastName']}',
                                  guestImage: doctors[1]['profile_picture'] ??
                                      'https://res.cloudinary.com/dqkofl9se/image/upload/v1727171512/Mobklinic/qq_jz1abw.jpg',
                                  guestPhoneNumber: doctors[1]['phone'],
                                ))),
              onViewProfilePressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ViewDocProfile(doctorCard: doctors[1]),
                  ),
                );
              },
              onBookAppointmentPressed: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DoctorAppointmentPag(doctorCard: doctors[1]),
                  ),
                );
              },
            ),
          ],
        ] else ...[
          SizedBox(
            height: 100,
            child: Center(child: Text('No doctors available')),
          )
        ]
      ],
    );
  }
}
