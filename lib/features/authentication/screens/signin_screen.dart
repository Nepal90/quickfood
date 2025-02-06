import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickfood/features/admin/screens/admin_dashboard.dart';
import 'package:quickfood/features/authentication/controller/auth_controller.dart';
import 'package:quickfood/features/authentication/screens/forgot_pwd_screen.dart';
import 'package:quickfood/features/authentication/screens/signup_screen.dart';
import 'package:quickfood/features/user/screens/user_home_page.dart';
import 'package:quickfood/widgets/custom_button.dart';
import 'package:quickfood/widgets/custom_text_field.dart';

class SignInScreen extends ConsumerWidget {
  SignInScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(loadingProvider);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            Center(
              child: const Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: const Text(
                'Sign in to continue',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Text('Email Address',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            CustomTextField(
                hintText: 'your@email.com', controller: emailController),
            const SizedBox(height: 20),
            const Text('Password',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            CustomTextField(
                hintText: 'Enter your password',
                controller: passwordController,
                obscureText: true),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPasswordScreen()),
                    );
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Consumer(builder: (context, ref, child) {
              return CustomButton(
                text: 'Sign In',
                onPressed: () async {
                  if (emailController.text.isEmpty ||
                      !RegExp(r'^[^@]+@[^@]+\.[^@]+')
                          .hasMatch(emailController.text)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Enter a valid email address!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  if (passwordController.text.isEmpty ||
                      passwordController.text.length < 6) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Password must be at least 6 characters!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  ref.read(loadingProvider.notifier).state = true;

                  try {
                    UserCredential? userCredential =
                        await ref.read(authProvider.notifier).signIn(
                              emailController.text.trim(),
                              passwordController.text.trim(),
                            );

                    if (userCredential != null) {
                      User? user = userCredential.user;
                      if (user == null) {
                        throw Exception("User not found.");
                      }

                      DocumentSnapshot userDoc = await FirebaseFirestore
                          .instance
                          .collection('users')
                          .doc(user.uid)
                          .get()
                          .timeout(const Duration(seconds: 10), onTimeout: () {
                        throw Exception("Request timed out. Please try again.");
                      });

                      if (!userDoc.exists) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text("User not found in database.")),
                        );
                        return;
                      }

                      String role = userDoc['role'];
                      if (role == 'admin') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminDashboard()),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserHomePage()),
                        );
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Successfully Logged In!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error: ${e.toString()}")),
                    );
                  } finally {
                    ref.read(loadingProvider.notifier).state = false;
                  }
                },
              );
            }),
            const SizedBox(height: 30),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                  );
                },
                child: const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextSpan(
                        text: 'Sign up',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: isLoading
          ? const Center(child: CircularProgressIndicator())
          : const SizedBox.shrink(),
    );
  }
}
