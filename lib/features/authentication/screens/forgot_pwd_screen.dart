import 'package:flutter/material.dart';
import 'package:quickfood/widgets/custom_button.dart';
import 'package:quickfood/widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Back to Login'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: const Text(
                'Forgot Password?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: const Text(
                "Enter your email address and we'll send you instructions to reset your password.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Email Address',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const CustomTextField(hintText: 'your@email.com'),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: 'Send Reset Instructions',
                onPressed: () {
                  print('Reset instructions sent');
                },
              ),
            ),
            const SizedBox(height: 30),
            const Center(
              child: Text(
                "If you don't receive an email within a few minutes, please check your spam folder or try again with a different email address.",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () {
                  print('Contact Support');
                },
                child: const Text(
                  'Still having trouble? Contact Support',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
