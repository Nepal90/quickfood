import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickfood/features/cart/cart_notifier.dart';

class CartPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Your Cart')),
      body: cartItems.isEmpty
          ? Center(child: Text('Your cart is empty.'))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  leading: Image.network(item.imageUrl, width: 50, height: 50),
                  title: Text(item.name),
                  subtitle: Text(
                      '₹${item.price.toStringAsFixed(2)} x ${item.quantity}'),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      ref
                          .read(cartProvider.notifier)
                          .removeProductFromCart(item.foodId);
                    },
                  ),
                );
              },
            ),
    );
  }
}
