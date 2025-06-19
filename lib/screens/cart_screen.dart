import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'order_confirmation_screen.dart'; // تأكد من استيراد الصفحة
import 'package:hamleys/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          "Your Cart",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: cartItems.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey),
            const SizedBox(height: 20),
            const Text('No items in cart', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Continue Shopping', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (ctx, i) {
                final item = cartItems[i];
                return ListTile(
                  leading: Image.network(item.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                  title: Text(item.title),
                  subtitle: Text('\$${item.price.toStringAsFixed(2)} x ${item.quantity}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => cartProvider.decreaseQuantity(item.id),
                      ),
                      Text('${item.quantity}'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => cartProvider.increaseQuantity(item.id),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => cartProvider.removeItem(item.id),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Subtotal: \$${cartProvider.totalAmount.toStringAsFixed(2)}'),
                const Text('Tax: \$5.00'),
                Text(
                  'Total: \$${(cartProvider.totalAmount + 5).toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // عندما تضغط على زر الـ Checkout، سيتم الانتقال إلى شاشة التأكيد
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderConfirmationScreen(
                          cartItems: cartItems,  // تأكد من أن cartItems تم تمريره
                          userId: FirebaseAuth.instance.currentUser!.uid,  // تأكد من تمكين userId من FirebaseAuth
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('CHECKOUT'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
