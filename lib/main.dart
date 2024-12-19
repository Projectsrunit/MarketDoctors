import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:market_doctor/pages/choose_action.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  await Firebase.initializeApp();
  await initializeNotifications();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatStore()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => DataStore()),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  await requestNotificationPermission();
}

Future<void> requestNotificationPermission() async {
  if (Platform.isAndroid && await _isAndroid13OrAbove()) {
    var status = await Permission.notification.status;
    if (status.isDenied) {
      status = await Permission.notification.request();
    }

    if (status.isGranted) {
      print("Notification permission granted.");
    } else {
      print("Notification permission denied.");
    }
  }
}

Future<bool> _isAndroid13OrAbove() async {
  final androidInfo = await DeviceInfoPlugin().androidInfo;
  return androidInfo.version.sdkInt >= 33;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  TextStyle _buildTextStyle(double fontSize, {Color? color}) {
    return TextStyle(
      fontSize: fontSize,
      backgroundColor: Colors.transparent,
      wordSpacing: 0,
      decorationThickness: 0,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color.fromARGB(255, 111, 136, 223),
        textTheme: GoogleFonts.nunitoTextTheme(
          Theme.of(context).textTheme.copyWith(
                bodyLarge: _buildTextStyle(18),
                bodyMedium: _buildTextStyle(16),
                headlineLarge: _buildTextStyle(32),
                headlineMedium: _buildTextStyle(28),
                headlineSmall: _buildTextStyle(24),
                bodySmall: _buildTextStyle(12),
              ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.blueGrey,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.black,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: const Color.fromARGB(255, 111, 136, 223),
        textTheme: GoogleFonts.nunitoTextTheme(
          Theme.of(context).textTheme.copyWith(
                bodyLarge: _buildTextStyle(18, color: Colors.white),
                bodyMedium: _buildTextStyle(16, color: Colors.white),
                headlineLarge: _buildTextStyle(32, color: Colors.white),
                headlineMedium: _buildTextStyle(28, color: Colors.white),
              ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 111, 136, 223),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.blueGrey,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey,
        ),
      ),
      themeMode: themeNotifier.themeMode,
      home: FutureBuilder<bool>(
        future: _checkFirstTimeUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data == true) {
            return OnboardingScreen();
          } else {
            return const ChooseActionPage();
          }
        },
      ),
    );
  }

  Future<bool> _checkFirstTimeUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isFirstTimeUser') ?? true;
  }
}

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}

class ChatStore extends ChangeNotifier {
  Map<int, Map<int, Map<String, dynamic>>> _messages = {};
  Map<String, dynamic>? _latestMessage;
  Map<String, dynamic> tempData = {
    'loadedOlderMessages': [],
    'readStatusFor': [],
    'idsWithUnreadMessages': [],
    'getOlderMessagesFor': null,
    'readStatusAndOlderMessagesCall': false
  };

  Map<int, Map<int, Map<String, dynamic>>> get messages => _messages;
  Map<String, dynamic> get latestMessage => _latestMessage ?? {};

  void addMessage(Map<String, dynamic> message, int docId) {
    int messageId = message['id'];
    if (!_messages.containsKey(docId)) {
      _messages[docId] = {};
    }
    _messages[docId]![messageId] = message;
    notifyListeners();
  }

  void sendMessage(Map<String, dynamic> message, int docId) {
    int messageId = message['id'];

    if (!_messages.containsKey(docId)) {
      _messages[docId] = {};
    }

    _messages[docId]![messageId] = message;
    _latestMessage = message;
    notifyListeners();
  }

  void resetNewMessageFlag() {
    _latestMessage = null;
  }

  void receiveDeliveryStatus(Map<String, dynamic> updatedMessage, int docId) {
    int messageId = updatedMessage['id'];

    if (_messages.containsKey(docId) &&
        _messages[docId]!.containsKey(messageId)) {
      _messages[docId]![messageId] = {
        ..._messages[docId]![messageId]!,
        'delivery_status': updatedMessage['delivery_status']
      };
      notifyListeners();
    }
  }

  void receiveReadStatus(Map<String, dynamic> updatedMessage, int docId) {
    int messageId = updatedMessage['id'];

    if (_messages.containsKey(docId) &&
        _messages[docId]!.containsKey(messageId)) {
      _messages[docId]![messageId] = {
        ..._messages[docId]![messageId]!,
        'read_status': updatedMessage['read_status']
      };
      notifyListeners();
    }
  }

  void sendReadStatusAndOlderMessagesCall() {
    print('sendReadStatusAndOlderMessagesCall from within chatstore ');
    tempData['readStatusAndOlderMessagesCall'] = true;
    notifyListeners();
  }

  void resetReadId() {
    tempData['readStatusAndOlderMessagesCall'] = false;
    // print('resetting readStatusAndOlderMessagesCall from within chatstore');
    notifyListeners();
  }

  void removeFromUnreadList(int id) {
    tempData['idsWithUnreadMessages'].remove(id);
    print('removing id $id from unreadList ================');
    notifyListeners();
  }

  void notifyForIdsWithUnreadMessages() {
    print('received instruction to set green lights on cards');
    notifyListeners();
  }

  void removeMessage(int docId, int messageId) {
    if (_messages.containsKey(docId)) {
      _messages[docId]?.remove(messageId);
      notifyListeners();
    }
  }

  Future<void> initDB(int personId) async {
    String dbName = 'person$personId.db';

    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(documentsDirectory.path, dbName);
    bool dbExists = await File(dbPath).exists();

    Database db =
        await openDatabase(dbPath, version: 1, onCreate: (db, version) async {
      print('Database $dbName created.');
    });

    if (!dbExists) {
      print('Database $dbName did not exist and has been created.');
      return;
    }

    List<Map<String, dynamic>> tables =
        await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table';");

    for (var table in tables) {
      String tableName = table['name'];

      if (tableName.startsWith('user')) {
        int docId = int.parse(tableName.replaceFirst('user', ''));
        List<Map<String, dynamic>> rows = await db.query(tableName);

        _messages[docId] = {
          for (var row in rows)
            row['id']: {
              'text_body': row['text_body'],
              'sender': row['sender'],
              'delivery_status': row['delivery_status'],
              'read_status': row['read_status'],
              'id': row['id'],
              'document_url': row['document_url'],
            }
        };
      }
    }

    print('Database $dbName loaded with messages.');
    print('here are the messages: $_messages');
    // notifyListeners();
  }
}

class DataStore with ChangeNotifier {
  Map? userData;

  DataStore({this.userData});

  Map? get chewData => userData;
  Map? get patientData => userData;
  Map? get doctorData => userData;

  Map<String, dynamic> addCaseData = {
    'maleOrFemale': null,
    'stage1Tap': null,
    'headings': {
      'Neck': {
        'whiteButtons': ['Anterior Neck', 'Posterior Neck']
      },
      'Anterior Neck': {
        'greyList': [
          "Neck Pain",
          "Arthritis",
          "Swollen Neck",
          "Torticollis",
          "Thyroid Disorders",
          "Muscle Strain",
          "Meningitis",
          "Influenza",
          "Lung Infection"
        ],
      },
      'Posterior Neck': {
        'greyList': [
          "Neck Pain",
          "Arthritis",
          "Swollen Neck",
          "Torticollis",
          "Thyroid Disorders",
          "Muscle Strain",
          "Meningitis",
          "Influenza",
          "Lung Infection"
        ],
      },
      'Head': {
        'whiteButtons': ['Forehead', 'Eye', 'Mouth', 'Nose', 'Ear']
      },
      'Eye': {
        'greyList': [
          'Cataracts',
          'Colour blindness',
          'Dry Eye',
          'Glaucoma',
          'Eye Infection'
        ]
      },
      'Forehead': {
        'greyList': ['Headache', 'Tension Headache', 'Migraine Headache', 'Cluster Headache', 'Sinus Headache', 'Posttraumatic Headache' ]
      },
      'Mouth': {
        'greyList': ['Lip Crack', 'Ulcer', 'Toothache', 'Bad Breath'],
      },
      'Nose': {
        'greyList': ['Runny Nose', 'Nasal Congestion', 'Nosebleed', 'Sinus Pain']
      },
      'Ear': {
        'greyList': ['Earwax Build-up', 'Ear Infection', 'Hearing Loss', 'Tinnitus']
      },
      'Chest': {
        'greyList': ['Stomach Pain', 'Abdominal Pain', 'Stomach Ulcer', 'Gastroparesis', 'Diabetic']
      },
      'Leg': {
        'greyList': ['Numbness', 'Cramps', 'Sprains', 'Pain', 'Swelling', 'Joint Dislocation', 'Cracked skin', 'Callus', 'Foot Complications']
      },
      'Hand': {
        'greyList': ['Fracture', 'Muscle Strain', 'Sprains', 'Inflamed tendor', 'Swelling', 'Joint dislocation']
      },
      'Shoulder': {
        'greyList': ['Fracture', 'Dislocation', 'Sprains', 'Impengement', 'Separation']
      },
      'Dorsum': {
        'greyList': ['Back Pain', 'Acute Back Pain', 'Arthritis', 'Low Back Pain']
      },
    }
  };

  void updateChewData(Map? newValue) {
    userData = newValue;
    notifyListeners();
  }

  void removePayment(int index) {
    if (userData != null && userData?['payments'] != null) {
      userData?['payments'].removeAt(index);
      notifyListeners();
    }
  }

  void addPayment(Map payment) {
    if (userData != null) {
      if (userData!['payments'] == null) {
        userData!['payments'] = [];
      }
      userData!['payments'].add(payment);
      notifyListeners();
    }
  }

  void removeCase(int index) {
    if (userData != null && userData?['cases'] != null) {
      userData?['cases'].removeAt(index);
      notifyListeners();
    }
  }

  void updateCase(int index, Map updates) {
    if (userData != null && userData?['cases'] != null) {
      userData?['cases'][index] = {...userData?['cases'][index], ...updates};
    }
  }

  void addCase(Map newCase) {
    if (userData != null) {
      if (userData!['cases'] == null) {
        userData!['cases'] = [];
      }
      userData!['cases'].add(newCase);
      notifyListeners();
    }
  }

  void updatePatientData(Map? newValue) {
    userData = newValue;
    notifyListeners();
  }

  void updateDoctorData(Map? newValue) {
    userData = newValue;

    notifyListeners();
  }

  void setDoctorData(Map<String, dynamic> data) {
    userData = data;
    notifyListeners();
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<OnboardingPageData> _pages = const [
    OnboardingPageData(
      title: 'Quality Healthcare for All',
      description: 'Enjoy the benefits that come with having the best doctors.',
      imageUrl: 'assets/images/people-celebrating.png',
    ),
    OnboardingPageData(
      title: 'Healthcare Provision Just for You',
      description:
          'Explore opportunities you deserve. Discover care that safeguards you.',
      imageUrl: 'assets/images/medical-care.png',
    ),
    OnboardingPageData(
      title: 'Accessible from Anywhere',
      description: 'Contact doctors, ready to offer assistance.',
      imageUrl: 'assets/images/location-review.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return OnboardingPage(
                title: _pages[index].title,
                description: _pages[index].description,
                imageUrl: _pages[index].imageUrl,
              );
            },
          ),
          Positioned(
            bottom: 10,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentIndex > 0)
                  TextButton(
                    onPressed: () {
                      _controller.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: const Text('Back'),
                  ),
                Row(
                  children: List.generate(_pages.length, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex == index
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    if (_currentIndex < _pages.length - 1) {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      _completeOnboarding(context);
                    }
                  },
                  child: Text(_currentIndex < _pages.length - 1
                      ? 'Next'
                      : 'Get Started'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //this change made due to a sudden error. Functionality untested
  Future<void> _completeOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTimeUser', false);
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const ChooseActionPage()),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imageUrl, height: 300),
          const SizedBox(height: 20),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class OnboardingPageData {
  final String title;
  final String description;
  final String imageUrl;

  const OnboardingPageData({
    required this.title,
    required this.description,
    required this.imageUrl,
  });
}
