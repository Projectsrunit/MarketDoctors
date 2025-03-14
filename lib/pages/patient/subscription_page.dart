import 'package:flutter/material.dart';
import 'package:flutter_paystack_plus/flutter_paystack_plus.dart';
import 'package:market_doctor/services/subscription_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SubscriptionPage extends StatefulWidget {
  final String userId;
  const SubscriptionPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  bool _isLoading = false;

  void _showMessage(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> _startPayment(String plan, int amount) async {
    setState(() => _isLoading = true);

    try {
      String publicKey = dotenv.env['PAYSTACK_PUBLIC_KEY'] ?? '';
      String transactionRef = 'ref_${DateTime.now().millisecondsSinceEpoch}';

      final transaction = await FlutterPaystackPlus.createTransaction(
        context: context,
        publicKey: publicKey,
        email: 'customer@email.com', // Get from user profile
        amount: amount * 100, // Amount in kobo
        reference: transactionRef,
      );

      if (transaction != null) {
        // Verify payment on backend
        var result = await SubscriptionService.verifyPayment(transactionRef);
        if (result['success']) {
          _showMessage('Subscription successful!', isError: false);
          Navigator.pop(context, true);
        }
      } else {
        _showMessage('Payment failed or was cancelled');
      }
    } catch (e) {
      _showMessage('Payment failed: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose Subscription')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildSubscriptionCard(
                    'Annual Plan',
                    '5000',
                    'Access to all features for 12 months',
                    () => _startPayment('annual', 5000),
                  ),
                  const SizedBox(height: 16),
                  _buildSubscriptionCard(
                    'Bi-Annual Plan',
                    '3000',
                    'Access to all features for 6 months',
                    () => _startPayment('biannual', 3000),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSubscriptionCard(
      String title, String price, String description, VoidCallback onTap) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge, // Updated from headline6
              ),
              const SizedBox(height: 8),
              Text(
                '₦$price',
                style: Theme.of(context).textTheme.titleLarge?.copyWith( // Updated from headline5
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(description),
            ],
          ),
        ),
      ),
    );
  }
}
