import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quickfood/features/cart/cart_notifier.dart';

class FoodDetailsPage extends StatefulWidget {
  final String foodId;
  final String name;
  final double price;
  final int quantity;
  final bool isVeg;
  final String imageUrl;
  final String barcodeUrl;

  const FoodDetailsPage({
    Key? key,
    required this.foodId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.isVeg,
    required this.imageUrl,
    required this.barcodeUrl,
  }) : super(key: key);

  @override
  _FoodDetailsPageState createState() => _FoodDetailsPageState();
}

class _FoodDetailsPageState extends State<FoodDetailsPage> {
  int quantity = 1;
  late Future<DocumentSnapshot> foodDetails;

  @override
  void initState() {
    super.initState();

    foodDetails =
        FirebaseFirestore.instance.collection('foods').doc(widget.foodId).get();
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: foodDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error fetching food details'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Food details not available'));
          }

          var foodData = snapshot.data!.data() as Map<String, dynamic>;
          String barcodeUrl = foodData['barcodeUrl'] ?? widget.barcodeUrl;

          return Column(
            children: [
              Expanded(
                flex: 1,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        widget.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.3),
                              Colors.black.withOpacity(0.7)
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 40,
                      left: 16,
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.currency_rupee,
                                color: Colors.green, size: 24),
                            Text(
                              widget.price.toStringAsFixed(2),
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              widget.isVeg
                                  ? Icons.eco
                                  : Icons.local_fire_department,
                              color: widget.isVeg ? Colors.green : Colors.red,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.isVeg ? 'Vegetarian' : 'Non-Vegetarian',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        if (barcodeUrl.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: SvgPicture.network(
                              barcodeUrl,
                              height: 100,
                              width: 100,
                              placeholderBuilder: (BuildContext context) =>
                                  const CircularProgressIndicator(),
                            ),
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (quantity > 1) quantity--;
                                    });
                                  },
                                  icon: const Icon(Icons.remove_circle_outline,
                                      size: 28, color: Colors.red),
                                ),
                                Text(
                                  quantity.toString(),
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      quantity++;
                                    });
                                  },
                                  icon: const Icon(Icons.add_circle_outline,
                                      size: 28, color: Colors.green),
                                ),
                              ],
                            ),
                            Text(
                              "Total: \₹${(widget.price * quantity).toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: Consumer(
                            builder: (context, ref, child) => ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isLoading = true;
                                });

                                final cartItem = CartItem(
                                  foodId: widget.foodId,
                                  name: widget.name,
                                  price: widget.price,
                                  quantity: quantity,
                                  isVeg: widget.isVeg,
                                  imageUrl: widget.imageUrl,
                                  barcodeUrl: widget.barcodeUrl,
                                );

                                ref
                                    .read(cartProvider.notifier)
                                    .addProductToCart(cartItem);
                                setState(() {
                                  isLoading = true;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Item added to cart!')),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                backgroundColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: isLoading
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : const Text(
                                      'Add to Cart',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
