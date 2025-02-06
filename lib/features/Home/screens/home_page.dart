import 'package:flutter/material.dart';
import 'package:quickfood/features/authentication/screens/signup_screen.dart';
import 'package:quickfood/features/authentication/services/auth_service.dart';

class HomePage extends StatelessWidget {
  final AuthService _authService = AuthService();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      actions: [
        GestureDetector(
          onTap: () async {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: Icon(
            Icons.logout,
          ),
        )
      ],
    ));
  }
}
