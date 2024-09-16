import 'package:flutter/material.dart';
import 'package:market_doctor/pages/patient/signup_page.dart';
import 'package:market_doctor/pages/chew/signup_page.dart';
import 'package:market_doctor/pages/doctor/signup_page.dart';

class ChooseUserTypePageTwo extends StatelessWidget {
  const ChooseUserTypePageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current theme's brightness (light or dark)
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Define a text color based on the theme
    final Color textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox (height:160),
            Text(
              'Choose User Type',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor, // Adapt to light/dark theme
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8), // Reduced top margin
            Text(
              'Just so we know you more and help you enjoy using the app',
              style: TextStyle(
                fontSize: 16,
                color: textColor, // Adapt to light/dark theme
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 65), // Reduced top margin
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0), // Added padding for side margins
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const DoctorSignUpPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        backgroundColor:
                            isDarkMode ? Colors.grey[800] :const Color.fromARGB(255, 226, 234, 238),
                        foregroundColor: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/doctor-image.png',
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Doctor',
                            style: TextStyle(
                              color: textColor, // Adapt text color
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16), // Adjusted spacing between cards
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0), // Added padding for side margins
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const PatientSignUpPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        backgroundColor:
                            isDarkMode ? Colors.grey[800] : const Color.fromARGB(255, 226, 234, 238),
                        foregroundColor: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/medical-folder.png',
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Patient',
                            style: TextStyle(
                              color: textColor, // Adapt text color
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ChewSignUpPage()
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 35),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                backgroundColor: isDarkMode
                    ? Colors.grey[800]
                    : const Color.fromARGB(255, 238, 244, 248),
                foregroundColor: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people,
                    size: 65,
                    color: textColor, // Icon color adapts to theme
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'CHEW',
                    style: TextStyle(
                      color: textColor, // Adapt text color
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
