import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:market_doctor/chat_store.dart';
import 'package:market_doctor/data_store.dart';
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
      themeMode: themeNotifier.themeMode,
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
