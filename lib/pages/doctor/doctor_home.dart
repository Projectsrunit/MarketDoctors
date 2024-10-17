// ignore_for_file: unnecessary_string_interpolations, unused_field

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:market_doctor/main.dart';
import 'package:market_doctor/pages/choose_action.dart';
import 'package:market_doctor/pages/doctor/bottom_nav_bar.dart';
import 'package:market_doctor/pages/doctor/doctor_appbar.dart';
import 'package:market_doctor/pages/doctor/doctor_appointment.dart';
import 'package:market_doctor/pages/doctor/doctor_cases.dart';
import 'package:market_doctor/pages/doctor/pharmacy.dart';
import 'package:market_doctor/pages/patient/advertisement_carousel.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:provider/provider.dart';

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
          final deliverer = context.read<RealTimeDelivery>().addLatestsMessage;
          int docId = (message['sender'] == chewId)
              ? message['receiver']
              : message['sender'];
          chatStore.addMessage(message, docId);
          deliverer(docId, message);
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
      int? docId = (message['sender'] == chewId)
          ? message['receiver']
          : message['sender'];
      if (docId != null) {//because some messages in backend had a missing sender or receiver
      addMessage(message, docId);
      }
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
            padding: const EdgeInsets.all(16.0),
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
                  builder: (context) => const DoctorAppointmentPage()),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Next Appointment',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            GestureDetector(
              onTap: () {}, // Replace with your "See all" action
              child: const Text(
                'See all',
                style: TextStyle(
                  color: Color(0xFF4672ff),
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSmallAppointmentCard(time: '02:00 PM', date: 'April 2, 2024'),
            const SizedBox(width: 4),
            Container(width: 70, height: 2, color: const Color(0xFF4672ff)),
            const SizedBox(width: 4),
            _buildSmallAppointmentCard(time: '02:00 PM', date: 'April 2, 2024'),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildLargeAppointmentCard(
              label: 'Video Consultation',
              doctorName: 'Dr. Goodness Usorah',
              time: '02:00 PM',
              date: 'April 2, 2024',
            ),
            const SizedBox(width: 16),
            _buildLargeAppointmentCard(
              label: 'Audio Consultation',
              doctorName: 'Dr. John Ogundipe',
              time: '02:00 PM',
              date: 'April 2, 2024',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSmallAppointmentCard(
      {required String time, required String date}) {
    return Container(
      width: 120,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFF617DEF),
      ),
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(time, style: const TextStyle(color: Colors.white, fontSize: 12)),
          Text(date, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildLargeAppointmentCard({
    required String label,
    required String doctorName,
    required String time,
    required String date,
  }) {
    return Container(
      width: 170,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFF617DEF),
      ),
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.white, fontSize: 14)),
          const SizedBox(height: 8),
          Text(doctorName,
              style: const TextStyle(color: Colors.white, fontSize: 12)),
          const SizedBox(height: 4),
          Text(time, style: const TextStyle(color: Colors.white, fontSize: 12)),
          Text(date, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}
