import 'package:flutter/material.dart';
import 'package:market_doctor/pages/choose_action.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: "assets/.env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removes the debug banner
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xFF617DEF),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            backgroundColor: Color(0xFF617DEF), // Background color
            foregroundColor: Colors.white, // Text color for light mode
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 40,
            ), // Padding inside the button
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Rounded corners
            ),
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor:
              Colors.blueGrey, // Ensure bottom bar has a background color
          selectedItemColor: Colors.white, // Color for selected item
          unselectedItemColor: Colors.black, // Color for unselected items
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark, // Dark mode theme
        primaryColor: Color(0xFF617DEF),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            backgroundColor: Color(0xFF617DEF), // Background color
            foregroundColor: Colors.white, // Text color for dark mode
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 40,
            ), // Padding inside the button
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Rounded corners
            ),
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.blueGrey,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey,
        ),
      ),
      themeMode: ThemeMode.system, // Uses the system theme mode
      home: const OnboardingScreen(),
    );
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
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRMSKIgZkMuobyFFeMEO5supYUCx2B8vbrCKQ_1NZfKCkNSRREAkHo2Q7Y2ExlErCxrEN4&usqp=CAU',
    ),
    OnboardingPageData(
      title: 'Healthcare Provision Just for You',
      description:
          'Explore opportunities you deserve. Discover care that safeguards you.',
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRDQ09N0Q99dRduX_sz8LWCoJl8_wVQgF8brQ&s',
    ),
    OnboardingPageData(
      title: 'Accessible from Anywhere',
      description: 'Contact doctors, ready to offer assistance.',
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRDQ09N0Q99dRduX_sz8LWCoJl8_wVQgF8brQ&s',
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChooseActionPage()),
                      );
                    }
                  },
                  child: Text(
                    _currentIndex == _pages.length - 1 ? 'Done' : 'Next',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;

  const OnboardingPage({
    required this.title,
    required this.description,
    required this.imageUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            imageUrl,
            height: 400, // Adjust the height to make the image larger
            fit: BoxFit
                .cover, // Ensures the image covers the space while maintaining its aspect ratio
          ),
          const SizedBox(height: 30),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ) ??
                const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 20),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 18,
                    ) ??
                const TextStyle(fontSize: 18),
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
