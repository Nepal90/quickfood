import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartItem {
  final String foodId;
  final String name;
  final double price;
  final int quantity;
  final bool isVeg;
  final String imageUrl;
  final String barcodeUrl;

  CartItem({
    required this.foodId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.isVeg,
    required this.imageUrl,
    required this.barcodeUrl,
  });
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addProductToCart(CartItem product) {
    state = [...state, product];
  }

  void removeProductFromCart(String foodId) {
    state = state.where((item) => item.foodId != foodId).toList();
  }

  List<CartItem> getCartDetails() {
    return state;
  }
}
