import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickfood/features/cart/cart_screen.dart';
import 'package:quickfood/features/user/screens/food_details_page.dart';
import 'package:quickfood/widgets/AppWidgets.dart';
import 'package:quickfood/widgets/food_item.dart';
import 'package:quickfood/widgets/offer_slider.dart';
import 'package:quickfood/widgets/shoping_cart_icon.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> categories = [
    {"name": "Soup", "image": "assets/images/soup.jpg"},
    {"name": "Burger", "image": "assets/images/burger1.jpg"},
    {"name": "Starter", "image": "assets/images/starter.jpg"},
    {"name": "Pizza", "image": "assets/images/pizza.jpeg"},
    {"name": "Rice", "image": "assets/images/rice.jpg"},
    {"name": "Biryani", "image": "assets/images/food.png"},
  ];

  get foodId => foodId;

  Stream<List<Map<String, dynamic>>> fetchFoodItems() {
    return FirebaseFirestore.instance
        .collection('foods')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Hello Nexus,", style: AppWidgets.boldTextFieldStyle()),
                  Container(
                    padding: const EdgeInsets.all(0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CartPage()),
                          );
                        },
                        child: ShoppingCartIcon()),
                  
                  )
                ],
              ),
              const SizedBox(height: 20),
              Text("Delicious Food,", style: AppWidgets.HeadlineField()),
              Text("Discover and Get Great Food,",
                  style: AppWidgets.LightTextFeildStyle()),
              const SizedBox(height: 20),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search food...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const OfferSlider(),
              const SizedBox(height: 20),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade300,
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                )
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.asset(
                                categories[index]["image"]!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            categories[index]["name"]!,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              StreamBuilder<List<Map<String, dynamic>>>(
                stream: fetchFoodItems(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No food items available"));
                  }

                  final foodItems = snapshot.data!;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: foodItems.length,
                    itemBuilder: (context, index) {
                      final food = foodItems[index];

                      return FoodItemCard(
                        name: food['name'] ?? 'No Name',
                        price: food['price']?.toDouble() ?? 0.0,
                        imageUrl: food['imageUrl'] ?? '',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FoodDetailsPage(
                                foodId: food['id'],
                                name: food['name'] ?? 'No Name',
                                price: food['price']?.toDouble() ?? 0.0,
                                quantity: 1,
                                isVeg: food['isVeg'] ?? false,
                                imageUrl: food['imageUrl'] ?? '',
                                barcodeUrl: food['barcodeUrl'] ?? '',
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
