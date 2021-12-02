import 'package:tf/models/cartItem.dart';

class LineItem {
  final String id;
  final int quantity;
  final String title;

  LineItem({required this.id, required this.quantity, required this.title});

  factory LineItem.fromJson(dynamic json) {
    return LineItem(
        id: json['id'], quantity: json['quantity'], title: json['title']);
  }

  static List<LineItem> fromCartItems(List<CartItem> cartItems) {
    return cartItems
        .map((item) => LineItem(
            id: item.variantID,
            quantity: item.quantity,
            title: item.variantTitle))
        .toList();
  }

  toJson() {
    return {
      'variantId': id,
      'quantity': quantity,
    };
  }
}
