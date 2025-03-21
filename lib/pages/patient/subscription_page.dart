import 'package:flutter/material.dart';
import 'package:pay_with_paystack/pay_with_paystack.dart';
import 'package:market_doctor/services/subscription_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:market_doctor/pages/patient/patient_home.dart';
import 'package:provider/provider.dart';
import 'package:market_doctor/data_store.dart';

class SubscriptionPage extends StatefulWidget {
  final String userId;
  const SubscriptionPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  bool _isLoading = false;
  bool _hasActiveSubscription = false;
  bool _hasExpiredTrial = false;

  @override
  void initState() {
    super.initState();
    _checkSubscriptionStatus();
  }

  Future<void> _checkSubscriptionStatus() async {
    setState(() => _isLoading = true);
    try {
      print('Checking subscription for user: ${widget.userId}');
      var result = await SubscriptionService.checkSubscription(widget.userId);
      print('Subscription check result: $result');

      if (result['status'] == 'active') {
        // If user has active subscription, go directly to home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PatientHome()),
        );
      } else if (result['status'] == 'expired' && 
                 result['subscription']?['plan'] == 'trial') {
        setState(() => _hasExpiredTrial = true);
        _showMessage('Your trial has expired. Please select a subscription plan.', isError: true);
      } else if (result['status'] == 'none') {
        setState(() => _hasExpiredTrial = false);
      }
    } catch (e) {
      print('Error checking subscription: $e');
      _showMessage('Error checking subscription status');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showMessage(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> _startTrial() async {
    setState(() => _isLoading = true);
    try {
      print('Creating trial subscription for user: ${widget.userId}');
      var result = await SubscriptionService.createTrialSubscription(widget.userId);
      print('Trial creation result: $result');

      if (result['success']) {
        _showMessage('Trial activated successfully!', isError: false);
        // Only navigate to home after successful trial creation
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PatientHome()),
        );
      } else {
        _showMessage(result['message'] ?? 'Could not activate trial');
      }
    } catch (e) {
      print('Trial activation error: $e');
      _showMessage('Error activating trial: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _startPayment(String plan, int amount) async {
    setState(() => _isLoading = true);

    try {
      String publicKey = dotenv.env['PAYSTACK_PUBLIC_KEY'] ?? '';
      String transactionRef = 'ref_${DateTime.now().millisecondsSinceEpoch}';
      
      final userEmail = context.read<DataStore>().patientData?['email'] ?? '';
      print('Starting payment - Email: $userEmail, Amount: $amount, Plan: $plan');

      if (userEmail.isEmpty) {
        _showMessage('User email not found');
        setState(() => _isLoading = false);
        return;
      }

      // Handle payment response before setting loading to false
      bool paymentCompleted = false;

      final response = await PayWithPayStack().now(
        context: context,
        secretKey: publicKey,
        customerEmail: userEmail,
        reference: transactionRef,
        amount: amount.toDouble(),
        currency: "NGN",
        callbackUrl: "${dotenv.env['API_URL']}/api/subscriptions/verify-payment",
        transactionCompleted: (response) async {
          print('Payment completed with response: $response');
          paymentCompleted = true;
          var result = await SubscriptionService.verifyPayment(
            reference: transactionRef,
            userId: widget.userId,
            plan: plan,
          );
          
          if (result['success']) {
            _showMessage('Subscription activated!', isError: false);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PatientHome()),
            );
          } else {
            print('Verification failed: ${result['details']}');
            _showMessage(result['message'] ?? 'Payment verification failed');
          }
        },
        transactionNotCompleted: (String message) {
          print('Transaction not completed: $message');
          paymentCompleted = true;
          _showMessage('Payment not completed: $message');
        },
        metaData: {
          'plan': plan,
          'userId': widget.userId,
        },
      );

      // Only show payment cancelled if no other payment status was shown
      if (response == null && !paymentCompleted) {
        _showMessage('Payment cancelled');
      }
    } catch (e) {
      print('Payment error: $e');
      _showMessage('Payment error: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.grey.shade900 : Colors.grey.shade100;
    final cardColor = isDarkMode ? Colors.grey.shade800 : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(_hasExpiredTrial ? 'Choose a Plan' : 'Choose Your Plan'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      _hasExpiredTrial 
                          ? 'Your trial has expired.\nPlease select a subscription plan.'
                          : 'Select a Subscription Plan',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    if (!_hasExpiredTrial) _buildTrialCard(cardColor, textColor),
                    if (!_hasExpiredTrial) const SizedBox(height: 16),
                    _buildSubscriptionCard(
                      'Annual Plan',
                      '₦5,000',
                      'Access to all features for 12 months',
                      () => _startPayment('annual', 5000),
                      cardColor,
                      textColor,
                      Icons.star,
                    ),
                    const SizedBox(height: 16),
                    _buildSubscriptionCard(
                      'Bi-Annual Plan',
                      '₦3,000',
                      'Access to all features for 6 months',
                      () => _startPayment('biannual', 3000),
                      cardColor,
                      textColor,
                      Icons.star_half,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTrialCard(Color cardColor, Color textColor) {
    return Card(
      elevation: 8,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: _startTrial,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(
                Icons.card_giftcard,
                size: 50,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                '7-Day Free Trial',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Try all features free for 7 days',
                style: TextStyle(
                  color: textColor.withOpacity(0.8),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _startTrial,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text('Start Free Trial'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubscriptionCard(String title, String price, String description,
      VoidCallback onTap, Color cardColor, Color textColor, IconData icon) {
    return Card(
      elevation: 8,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(icon, size: 40, color: Theme.of(context).primaryColor),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                price,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  color: textColor.withOpacity(0.8),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
