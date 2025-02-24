import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:market_doctor/chat_store.dart';
import 'package:market_doctor/data_store.dart';
import 'package:market_doctor/pages/chew/bottom_nav_bar.dart';
import 'package:market_doctor/pages/chew/chew_app_bar.dart';
import 'package:market_doctor/pages/chew_or_patient_card.dart';
import 'package:market_doctor/pages/chew/chatting_page.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

class ChatsWithDoc extends StatefulWidget {
  @override
  State<ChatsWithDoc> createState() => _ChatsWithDocState();
}

class _ChatsWithDocState extends State<ChatsWithDoc> {
  List<dynamic> docs = [];
  bool isDocLoading = true;

  @override
  void initState() {
    super.initState();
    if (docs.isEmpty) {
      fetchDocs();
    }
  }

  Future<void> insertIntoChatHistoryDb(List<dynamic> data) async {
    final db = context.read<ChatStore>().db;
    // await db!.execute('DROP TABLE IF EXISTS chatHistory');

    await db!.execute('''CREATE TABLE IF NOT EXISTS chatHistory (
            id INTEGER PRIMARY KEY,
            firstName TEXT,
            lastName TEXT,
            image TEXT,
            phone TEXT
          )''');

    final batch = db.batch();
    for (final doc in data) {
      batch.insert(
        'chatHistory',
        {
          'id': doc['id'],
          'firstName': doc['firstName'],
          'lastName': doc['lastName'],
          'image': doc['profile_picture'],
          'phone': doc['phone']
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(
        noResult:
            true); // Use noResult: true for better performance if you don't need the result
  }

  Future<void> docsFromChatHistory() async {
    final db = context.read<ChatStore>().db;
    final List<Map<String, dynamic>> data = await db!.query('chatHistory');
    setState(() {
      docs = data;
      isDocLoading = false;
    });
  }

  Future<void> fetchDocs() async {
    int chewId = context.read<DataStore>().doctorData?['id'];
    final String baseUrl = dotenv.env['API_URL']!;
    final Uri url = Uri.parse('$baseUrl/api/getchatsfor');
    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({'id': chewId, 'role': 3}));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          if (data is List) {
            docs = data;
          }
          isDocLoading = false;
          insertIntoChatHistoryDb(data);
        });
      } else {
        throw Exception('Failed to load chats');
      }
    } catch (e) {
      print('this is the error $e');
      Fluttertoast.showToast(
        msg: 'Failed to load chats. Checking offline data',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.grey[800],
        textColor: Colors.white,
        fontSize: 16.0,
      );
      docsFromChatHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChewAppBar(),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            if (isDocLoading)
              SizedBox(
                height: 200,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else if (docs.isNotEmpty)
              Flexible(
                child: ListView.separated(
                  itemCount: docs.length,
                  separatorBuilder: (context, index) => SizedBox(height: 8.0),
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    return ChewOrPatientCard(
                      id: doc['id'],
                      imageUrl: doc['profile_picture'] ??
                          'https://res.cloudinary.com/dqkofl9se/image/upload/v1727171512/Mobklinic/qq_jz1abw.jpg',
                      name: '${doc['firstName']} ${doc['lastName']}',
                      onChatPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChattingPage(
                                    doctorId: doc['id'],
                                    doctorName:
                                        '${doc['firstName']} ${doc['lastName']}',
                                    doctorImage: doc['profile_picture'] ??
                                        'https://res.cloudinary.com/dqkofl9se/image/upload/v1727171512/Mobklinic/qq_jz1abw.jpg',
                                    doctorPhoneNumber: doc['phone'],
                                  ))),
                    );
                  },
                ),
              )
            else
              SizedBox(
                height: 100,
                child: Center(child: Text('Your chats will appear here')),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
