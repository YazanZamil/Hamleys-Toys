class CartItem {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
  });

  // الدالة الخاصة بتحويل البيانات من Firestore إلى CartItem
  factory CartItem.fromFirestore(Map<String, dynamic> data, String documentId) {
    return CartItem(
      id: documentId,
      title: data['title'] ?? 'No title', // تأكد من وجود قيمة
      description: data['description'] ?? 'No description', // تأكد من وجود قيمة
      imageUrl: data['imageUrl'] ?? '', // تأكد من وجود قيمة
      price: data['price']?.toDouble() ?? 0.0, // التأكد من أن السعر هو نوع double
      quantity: data['quantity'] ?? 1, // تعيين quantity إلى 1 إذا لم تكن موجودة
    );
  }

  // دالة لتحويل CartItem إلى Map لكتابته في Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
    };
  }
}
