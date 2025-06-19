import 'package:flutter/material.dart';
import 'package:hamleys/models/cart_item.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  int get itemCount => _items.length;

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  // إضافة item مع description
  void addItem(String id, String title, double price, String imageUrl, String description) {
    if (_items.containsKey(id)) {
      _items.update(
        id,
            (existingItem) => CartItem(
          id: existingItem.id,
          title: existingItem.title,
          price: existingItem.price,
          imageUrl: existingItem.imageUrl,
          quantity: existingItem.quantity + 1,
          description: existingItem.description, // استخدام الـ description الموجود
        ),
      );
    } else {
      _items.putIfAbsent(
        id,
            () => CartItem(
          id: id,
          title: title,
          price: price,
          imageUrl: imageUrl,
          quantity: 1,
          description: description, // إضافة description هنا
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  void increaseQuantity(String id) {
    if (_items.containsKey(id)) {
      _items[id]!.quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity(String id) {
    if (_items.containsKey(id) && _items[id]!.quantity > 1) {
      _items[id]!.quantity--;
      notifyListeners();
    }
  }
}
