import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickfood/features/authentication/controller/auth_controller.dart';
import 'package:quickfood/features/authentication/screens/signin_screen.dart';
import 'package:quickfood/widgets/custom_button.dart';
import 'package:quickfood/widgets/custom_text_field.dart';

final loadingProvider = StateProvider<bool>((ref) => false);

class SignUpScreen extends ConsumerWidget {
  SignUpScreen({super.key});
  final TextEditingController fnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordContoller = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(loadingProvider);

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Center(
                  child: Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Center(
                  child: Text(
                    'Join our food management community',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'Full Name ',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                    hintText: 'Full Name',
                    controller: fnameController,
                    keyboardType: TextInputType.name),
                const SizedBox(height: 16),
                const Text(
                  'Email Address',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                    hintText: 'Email Address',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 16),
                const Text(
                  'Password',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                    hintText: 'Password',
                    controller: passwordContoller,
                    obscureText: true),
                const SizedBox(height: 16),
                const Text(
                  'Confirm Password',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                    hintText: 'Confirm Password',
                    controller: confirmPassword,
                    obscureText: true),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: 'Create Account',
                    onPressed: () async {
                      if (fnameController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Full Name is required!'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

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

                      if (passwordContoller.text.isEmpty ||
                          passwordContoller.text.length < 6) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Password must be at least 6 characters!'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      if (passwordContoller.text != confirmPassword.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Passwords do not match!'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      ref.read(loadingProvider.notifier).state = true;
                      try {
                        ref.read(authProvider.notifier).signUp(
                              email: emailController.text,
                              password: passwordContoller.text,
                              name: fnameController.text,
                            );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('SignUp Successfully!'),
                            backgroundColor: Colors.green,
                          ),
                        );

                        Future.delayed(const Duration(seconds: 1), () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => SignInScreen(),
                            ),
                          );
                        });
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Signup Failed: ${e.toString()}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } finally {
                        ref.read(loadingProvider.notifier).state = false;
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => SignInScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Already have an account? Sign In',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
