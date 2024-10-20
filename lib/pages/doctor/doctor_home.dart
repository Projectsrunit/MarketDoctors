// ignore_for_file: unnecessary_string_interpolations, unused_field

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:market_doctor/main.dart';
import 'package:market_doctor/pages/choose_action.dart';
import 'package:market_doctor/pages/doctor/bottom_nav_bar.dart';
import 'package:market_doctor/pages/doctor/doctor_appbar.dart';
import 'package:market_doctor/pages/doctor/doctor_cases.dart';
import 'package:market_doctor/pages/doctor/pharmacy.dart';
import 'package:market_doctor/pages/doctor/upcoming_appointment.dart';
import 'package:market_doctor/pages/patient/advertisement_carousel.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  IO.Socket? socket;
  List<Map<String, dynamic>> unsentMessages = [];
  bool _isSocketInitialized = false;
  ChatStore? chatStore;
  bool isLoading = true;
  bool hasError = false;
  List<dynamic> appointments = [];
  @override
  void initState() {
    super.initState();
    if (!_isSocketInitialized) {
      _initializeSocket();
      _isSocketInitialized = true;
    }
    chatStore = context.read<ChatStore>();
    chatStore?.addListener(_sendPendingUpdates);
    _fetchAppointments();
  }

  @override
  void dispose() {
    super.dispose();
    socket?.disconnect();
    _isSocketInitialized = false;
  }

  void _initializeSocket() {
    ChatStore chatStore = context.read<ChatStore>();
    int? hostId = Provider.of<DataStore>(context, listen: false).doctorData?['id'];

    if (hostId != null) {
      final String socketUrl = dotenv.env['API_URL']!;

      setState(() {
        socket = IO.io(socketUrl, <String, dynamic>{
          'transports': ['websocket'],
          'autoConnect': false,
        });

        socket!.connect();
        socket!.emit('authenticate', {'own_id': hostId});

        socket!.on('connect', (_) {
          // print('Socket connected');
          _resendUnsentMessages();
        });

        socket!.on('unread_messages', (messages) {
          _handleArrayOfMessages(messages, hostId);
        });

        socket!.on('new_message', (message) {
          int guestId = (message['sender'] == hostId)
              ? message['receiver']
              : message['sender'];
          chatStore.addMessage(message, guestId);
          socket!.emit('update_delivery_status', {'message_id': message['id']});
        });

        socket!.on('older_messages', (messages) {
          _handleArrayOfMessages(messages, hostId);
        });

        socket!.on('delivery_status_updated', (message) {
          int guestId = (message['sender'] == hostId)
              ? message['receiver']
              : message['sender'];
          chatStore.receiveDeliveryStatus(message, guestId);
        });

        socket!.on('read_status_updated', (message) {
          int guestId = (message['sender'] == hostId)
              ? message['receiver']
              : message['sender'];
          chatStore.receiveReadStatus(message, guestId);
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

  Future<void> _fetchAppointments() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });
    final doctorData =
        Provider.of<DataStore>(context, listen: false).doctorData;
    String? baseUrl = dotenv.env['API_URL'];

    final String apiUrl =
        "$baseUrl/api/appointments?filters[doctor][id]=${doctorData?['id']}&populate=*";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          appointments = responseData['data'] ?? [];
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
        print('Response: ${response.body}');
      }
    } catch (error) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  void _handleArrayOfMessages(List<dynamic> messages, int hostId) {
    final addMessage = context.read<ChatStore>().addMessage;
    final unreadList = context.read<ChatStore>().tempData['idsWithUnreadMessages'];
    for (Map<String, dynamic> message in messages) {
      int? guestId = (message['sender'] == hostId)
          ? message['receiver']
          : message['sender'];
      if (guestId != null) {//because some messages in backend had a missing sender or receiver
        addMessage(message, guestId);        
      }
      if (message['delivery_status'] != true) {
        socket!.emit('update_delivery_status', {'message_id': message['id']});
      }
      if (!unreadList.contains(message['id'])) {
        unreadList.add(message['id']);
      }
    }
  }

  void _sendPendingUpdates() {
    ChatStore chatStore = context.read<ChatStore>();
    int hostId = context.read<DataStore>().doctorData?['id'];

    if (chatStore.latestMessage.isNotEmpty) {
      int messageId = chatStore.latestMessage['id'];
      if (socket!.connected) {
        socket!.emitWithAck(
          'new_message',
          chatStore.latestMessage,
          ack: (response) {
            if (response['success'] == true) {
              Map<String, dynamic> newMessage = response['message'];
              int guestId = newMessage['receiver'];
              chatStore.addMessage(newMessage, guestId);
              if (newMessage['id'] != messageId) {
                chatStore.removeMessage(guestId, messageId);
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

    if (chatStore.tempData['readStatusAndOlderMessagesCall'] == true) {
      for (int id in chatStore.tempData['readStatusFor']) {
        socket!.emit('update_read_status', {'message_id': id});
        // print('sending update for read status of message $id');
      }
      chatStore.resetReadId();
    }

    if (chatStore.tempData['getOlderMessagesFor'] != null) {
      socket!.emit('get_older_messages', {
        'own_id': hostId,
        'other_id': chatStore.tempData['getOlderMessagesFor']
      });
      // print('emitting to get older messages for id ${chatStore.tempData['getOlderMessagesFor']} ======');
      chatStore.tempData['loadedOlderMessages']
          .add(chatStore.tempData['getOlderMessagesFor']);
      // print('added new id to loadedoldermessages: ${chatStore.tempData['loadedOlderMessages']}');
      chatStore.tempData['getOlderMessagesFor'] = null;
      // print('now nullified getoldermessagesfor int: ${chatStore.tempData['getOlderMessagesFor']}');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Accessing the doctorData from Provider
    final doctorData = Provider.of<DataStore>(context).doctorData;
    // final String? userId = doctorData?['id']?.toString();
    final int? userId = doctorData?['id'];
    if (doctorData == null) {
      return PopScope(canPop: false, child: ChooseActionPage());
    } else {
      return PopScope(
        canPop: false,
        child: Scaffold(
          appBar: DoctorApp(),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchbar(),
                const SizedBox(height: 16),
                _buildDashboardCards(userId),
                const SizedBox(height: 16),
                AdvertisementCarousel(),
                const SizedBox(height: 16),
                _buildNextAppointmentSection(),
              ],
            ),
          ),
          bottomNavigationBar: DoctorBottomNavBar(),
        ),
      );
    }
  }

  Widget _buildSearchbar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Cases, Appointment, Pharmacy',
                hintStyle: TextStyle(color: Colors.grey[500]),
                prefixIcon: const Icon(Icons.search, color: Colors.black),
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextButton.icon(
            onPressed: () {
              // Handle filter action
            },
            icon: const Icon(Icons.filter_list, color: Colors.black),
            label: const Text('Filter', style: TextStyle(color: Colors.black)),
            style: TextButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardCards(int? userId) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      crossAxisSpacing: 10,
      mainAxisSpacing: 16,
      children: [
        _buildDashboardCardWithLabel(
          image: const AssetImage('assets/images/cases-image.png'),
          label: 'Cases',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DoctorCasesPage()),
            );
          },
        ),
        _buildDashboardCardWithLabel(
          image: const AssetImage('assets/images/pills-image.png'),
          label: 'Pharmacy',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DoctorPharmacyListPage()),
            );
          },
        ),
        _buildDashboardCardWithLabel(
          icon: Icons.person_add_alt_1_outlined,
          label: 'Appointment',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UpcomingAppointmentPage()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDashboardCardWithLabel({
    AssetImage? image,
    IconData? icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              decoration: BoxDecoration(
                color: const Color(0xFF617DEF).withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: image != null
                    ? Image(image: image, fit: BoxFit.contain)
                    : Icon(icon, size: 40, color: const Color(0xFF617DEF)),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextAppointmentSection() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (hasError) {
      return Center(child: Text("Error fetching appointments"));
    }

    final upcomingAppointments = appointments.take(2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Upcoming Appointments",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent, // White text for title
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpcomingAppointmentPage(),
                  ),
                );
              },
              child: const Text(
                'See all',
                style: TextStyle(
                  color: Colors.blueAccent, // Link color
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white, // Card background color
            borderRadius: BorderRadius.circular(10), // Rounded corners
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.5, // Adjust the aspect ratio as needed
            ),
            itemCount: upcomingAppointments.length,
            itemBuilder: (context, index) {
              final appointment = upcomingAppointments[index]['attributes'];
              final patientAppointment =
                  appointment['patient']['data']['attributes'];
              return _buildAppointmentCard(appointment, patientAppointment);
            },
          ),
        ),
        const SizedBox(height: 16), // Add spacing between sections
      ],
    );
  }

  Widget _buildAppointmentCard(Map<String, dynamic> appointment,
      Map<String, dynamic> patientAppointment) {
    final String patientFullName =
        "${patientAppointment['firstName']} ${patientAppointment['lastName']}"; // Full name
    // final String appointmentDate = appointment['appointment_date'];
    final String appointmentTime = appointment['appointment_time'];

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.blueAccent, // Card background color
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Time: $appointmentTime",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white, // White text for appointment time
              ),
            ),
            Text(
              "Patient: $patientFullName", // Show full name
              style: TextStyle(
                color: Colors.white, // White text for patient name
              ),
            ),
          ],
        ),
      ),
    );
  }
}
