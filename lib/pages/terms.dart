import 'package:flutter/material.dart';

class TermsAndConditions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Use'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('TERMS OF USE'),
            const SizedBox(height: 16),
            _buildParagraph(
              'Please read these Terms of Use (“Terms”), which set forth the legally binding terms and conditions between you and MarketDoctors (“MarketDoctor”). It governs your access to and the use of its website (the “Site”), Mobile Application (the “App”) and all or any related services (collectively referred to as the “Service”) offered by MarketDoctors.',
            ),
            const SizedBox(height: 16),
            _buildParagraph(
              'Our collection and use of personal information in connection with your access to and use of the Service is described in our Privacy Policy.',
            ),
            const SizedBox(height: 16),
            _buildParagraph(
              'Your access to use of the Service is conditioned on your acceptance of and compliance with these Terms. These Terms apply to all visitors, users and others who access or use our Service.',
            ),
            const SizedBox(height: 16),
            _buildParagraph(
              'In these Terms, “we”, “us” and “our” refer to MarketDoctor.',
            ),
            const SizedBox(height: 16),
            _buildParagraph(
              'By accessing or using the Service you agree to be bound by these Terms. If you disagree with any part of the terms, then you may not access the Service.',
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Definitions'),
            const SizedBox(height: 8),
            _buildDefinition(
              'Account',
              'means a unique personified account registered in the name of the User and which contains details of the User’s requests and subscriptions.',
            ),
            _buildDefinition(
              'Emergency',
              'means any serious, sudden medical incident that requires immediate care and action.',
            ),
            _buildDefinition(
              'Cases',
              'means electronic records of individuals as collected by community health workers.',
            ),
            _buildDefinition(
              'CHEW',
              'means professionals skilled in providing basic health diagnosis.',
            ),
            _buildDefinition(
              'Service',
              'refers to all products and services provided to you by MarketDoctors as provided on our Site.',
            ),
            _buildDefinition(
              'Site',
              'refers to the website for the services rendered by MarketDoctors.',
            ),
            _buildDefinition(
              'Subscription',
              'means a periodic payment made by Users to access our Service.',
            ),
            _buildDefinition(
              'Users',
              'refers to account holders and visitors to the MarketDoctor Site or App.',
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Acceptance of Terms'),
            const SizedBox(height: 8),
            _buildParagraph(
              'The Service is offered subject to acceptance of all the terms and conditions contained in these Terms and all other operating rules, policies, and procedures of third-party service providers to the site that are referenced herein. These Terms apply to every user of the Service. In addition, some Services offered through the Site may be subject to additional terms and conditions adopted by MarketDoctor. Your use of those Services is subject to those additional terms and conditions, which are incorporated into these Terms by this reference.',
            ),
            const SizedBox(height: 16),
            _buildParagraph(
              'MarketDoctor reserves the right, at its sole discretion, to modify or replace these Terms from time to time by posting the updated Terms on the Site. It is your responsibility to check the Terms periodically for changes. If you object to any such changes, your sole recourse will be to cease using the Site and the App. Your continued use of the Site following the posting of any changes to the Terms will indicate your acknowledgement of such changes and agreement to be bound by the terms and conditions of such changes.'
               ),
               const SizedBox(height: 16),
                _buildParagraph(
              'MarketDoctor reserves the right to change, suspend, or discontinue the Service (including, but not limited to, the unavailability of any feature, database, or content) at any time for any reason.'
               ),
               const SizedBox(height: 16),
                 _buildParagraph(
              ''
               ),
            // Add more sections as required.
            const SizedBox(height: 16),
            _buildSectionTitle('Scope of MarketDoctor Services'),
             const SizedBox(height: 16),
                 _buildParagraph(
              'MarketDoctor is a healthcare technology company that uses technology to connect community health workers across the globe with individuals and organizations in need of medical care and support. MarketDoctors network is filled with trained medical professionals who can provide first-aid care to Users.'
               ),
                const SizedBox(height: 16),
                 _buildParagraph(
              'Access to MarketDoctor Service may be subject to certain conditions or requirements, such as signing up for an account and subscribing to a specific service package.You must be at least 18 years old and able to enter into legally binding contracts to access our Site and use our Service. By accessing our Site and using our Service, you represent and warrant that you are 18 or older and have the legal capacity and authority to enter into a contract.'
               ),
      
                const SizedBox(height: 16),
            _buildSectionTitle('Termination'),
            const SizedBox(height: 8),
            _buildParagraph(
              'We may terminate or suspend your account immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach these Terms.Upon termination, your right to use the Site and/or App and any of our Services will immediately cease. If you wish to terminate your account, you may simply discontinue using the App.'
            ),
                const SizedBox(height: 16),
            _buildSectionTitle('Disclaimer'),
            const SizedBox(height: 8),
            _buildParagraph(
              'Your use of the Service is at your sole risk. The Service is provided on an “AS IS” and “AS AVAILABLE” basis. The Content is provided without warranties of any kind, whether express or implied, including, but not limited to, implied warranties of merchantability, fitness for a particular purpose, non-infringement or course of performance.MarketDoctor, its subsidiaries, affiliates, and its licensors do not warrant that a) the App and the Site will function uninterrupted, secure or available at any particular time or location; b) any errors or defects will be corrected; c) the App and the Site are free of viruses or other harmful components, or d) the results of using the App and the Site will meet your requirements.'
            ),
              const SizedBox(height: 16),
            _buildSectionTitle('Governing Law'),
            const SizedBox(height: 8),
            _buildParagraph(
              'These Terms shall be governed and construed in accordance with the laws of The Federal Republic of Nigeria, without regard to its conflict of law provisions.Our failure to enforce any right or provision of these Terms will not be considered a waiver of those rights. If any provision of these Terms is held to be invalid or unenforceable by a court, the remaining provisions of these Terms will remain in effect. These Terms constitute the entire agreement between us regarding our Service and supersede and replace any prior agreements we might have between us regarding the Service'
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Color(0xFF4672ff), // Blue color for section titles
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, height: 1.5),
    );
  }

  Widget _buildDefinition(String term, String definition) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey, // Light grey shadow
            blurRadius: 4,
            offset: Offset(0, 2), // Slight shadow below
          ),
        ],
      ),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 16, color: Colors.black),
          children: [
            TextSpan(
              text: '$term: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: definition),
          ],
        ),
      ),
    );
  }
}
