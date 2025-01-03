import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:market_doctor/chat_store.dart';
import 'package:market_doctor/pages/choose_action.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

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
        'greyList': [
          'Headache',
          'Tension Headache',
          'Migraine Headache',
          'Cluster Headache',
          'Sinus Headache',
          'Posttraumatic Headache'
        ]
      },
      'Mouth': {
        'greyList': ['Lip Crack', 'Ulcer', 'Toothache', 'Bad Breath'],
      },
      'Nose': {
        'greyList': [
          'Runny Nose',
          'Nasal Congestion',
          'Nosebleed',
          'Sinus Pain'
        ]
      },
      'Ear': {
        'greyList': [
          'Earwax Build-up',
          'Ear Infection',
          'Hearing Loss',
          'Tinnitus'
        ]
      },
      'Chest': {
        'greyList': [
          'Stomach Pain',
          'Abdominal Pain',
          'Stomach Ulcer',
          'Gastroparesis',
          'Diabetic',
          'Chest Pain'
        ]
      },
      'Leg': {
        'greyList': [
          'Numbness',
          'Cramps',
          'Sprains',
          'Pain',
          'Swelling',
          'Joint Dislocation',
          'Cracked skin',
          'Callus',
          'Foot Complications'
        ]
      },
      'Hand': {
        'greyList': [
          'Fracture',
          'Muscle Strain',
          'Sprains',
          'Inflamed tendor',
          'Swelling',
          'Joint dislocation'
        ]
      },
      'Shoulder': {
        'greyList': [
          'Fracture',
          'Dislocation',
          'Sprains',
          'Impengement',
          'Separation'
        ]
      },
      'Dorsum': {
        'greyList': [
          'Back Pain',
          'Acute Back Pain',
          'Arthritis',
          'Low Back Pain'
        ]
      },
    },
    'questionnaire': {
      'Chest Pain': {
        "Have you been told you have an abnormal ECG?": ["Yes", "No"],
        "Do you have chest pain with walking/normal activity or exercise?": [
          "Yes",
          "No"
        ],
        "Are you been treated for high blood pressure?": ["Yes", "No"],
        "Do you have a cardiologist?": ["Yes", "No"],
        "If yes, do they know about your current circumstance?": ["Yes", "No"],
        "Do you have pulmonary hypertension?": ["Yes", "No"],
        "Do you have a heart murmur, mitral valve prolapse?": ["Yes", "No"],
        "Have you had a heart attack before?": ["Yes", "No"],
        "Have you ever had a stress test before?": ["Yes", "No"]
      },
      'Eye Infection': {
        "Do you Wear Glasses?": ["Yes", "No"],
        "Do you Wear Contact lens?": ["Yes", "No"],
        "Do you have difficulty, even with Glasses with the following activities? Reading small prints?":
            ["Yes", "No"],
        "If yes, how much difficulty do you currently have?": [
          "A little",
          "A great deal",
          "Unable to do any activity",
          "A moderate amount"
        ],
        "Are you using any regular eye drops?": ["Yes", "No"],
        "For How long?": ["Over a Week", "Over a Month"],
        "Do you smoke": ["Yes", "No"],
        "Do you take alcohol": ["Yes", "No"]
      },
      'Migraine Headache': {
        "When did your Migraine begin?": [
          "Same days ago",
          "Few weeks ago",
          "Months",
          "Been Years"
        ],
        "Have you had a head injury before?": ["Yes", "No"],
        "How painful is your Migraine?": ["Mild", "Severe"],
        "How would you describe your Migraine headache?": [
          "Throbbing/Pounding",
          "Aching/Pounding"
        ],
        "Did the Botox treatment work?": ["Yes", "No"],
        "For How long?": ["Over a Week", "Over a Month"],
        "Are you taking any prescription drugs to treat your Migraine?": [
          "Yes",
          "No"
        ],
        "Are you taking any Over the counter drugs to treat your Migraine?": [
          "Yes",
          "No"
        ]
      },
      'Stomach Pain': {
        "Are you experiencing stomach pain?": ["Yes", "No"],
        "Do you have abdominal pain?": ["Yes", "No"],
        "Are you experiencing heart burn?": ["Yes", "No"],
        "Do you excrete black poop?": ["Yes", "No"],
        "Are you stooling?": ["Yes", "No"],
        "Does one of your family have history of Ulcer?": ["Yes", "No"],
        "How many meals can you cover a day?": ["Over a Week", "Over a Month"],
        "Are you taking any prescription drugs to treat your Ulcer?": [
          "Yes",
          "No"
        ],
        "Are you taking any Over the counter drugs to treat your Ulcer?": [
          "Yes",
          "No"
        ]
      }
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
