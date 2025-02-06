import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickfood/features/admin/screens/add_food.dart';
import 'food_manage_screen.dart';
import 'package:quickfood/widgets/AppWidgets.dart';
import 'package:quickfood/features/authentication/screens/signin_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  void _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error logging out: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard" ,style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 25),),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 50.0, left: 15.0, right: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddFood()),
                );
              },
              child: Material(
                elevation: 10.0,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          height: 80,
                          "assets/images/food.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      const Expanded(
                        child: Text(
                          "Add Food Items",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text("Food Management", style: AppWidgets.HeadlineField()),
            const SizedBox(height: 10),
            Expanded(
              child: FoodManagePage(),
            ),
          ],
        ),
      ),
    );
  }
}
