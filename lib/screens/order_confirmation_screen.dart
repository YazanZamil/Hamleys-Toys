import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hamleys/providers/cart_provider.dart';
import 'package:hamleys/models/cart_item.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final List<CartItem> cartItems; // ارسلها من الشاشة التي تضيف المنتجات
  final String userId; // userId من Firebase

  OrderConfirmationScreen({super.key, required this.cartItems, required this.userId});

  Future<void> addToCartAfterPayment(String userId, List<CartItem> cartItems) async {
    try {
      CollectionReference userCartCollection = FirebaseFirestore.instance
          .collection('carts')
          .doc(userId) // باستخدام الـ userId من Firebase Auth
          .collection('items');

      // إضافة كل عنصر إلى الـ Firestore
      for (var item in cartItems) {
        await userCartCollection.doc(item.id).set({
          'title': item.title,
          'price': item.price,
          'quantity': item.quantity,
          'imageUrl': item.imageUrl,
          'description': item.description,
          'productId': item.id,
        });
      }

      print("Cart items added successfully.");
    } catch (e) {
      print("Error adding cart items: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Order Confirmed'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 100),
            const SizedBox(height: 20),
            const Text(
              'Thank you for your purchase!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('Your toys are on their way.'),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                addToCartAfterPayment(userId, cartItems); // إضافة العناصر بعد الدفع
                Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false); // العودة إلى الصفحة الرئيسية
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
