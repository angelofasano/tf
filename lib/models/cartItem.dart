import 'package:tf/models/variant.dart';

class CartItem {
  String variantID;
  String productTitle;
  String productID;
  String variantTitle;
  double price;
  String image;
  int quantity;

  CartItem(this.variantID, this.productTitle, this.productID, this.variantTitle, this.price,
      this.image, this.quantity);

  toJson() {
    return {
      'id': this.variantID,
      'productTitle': this.productTitle,
      'productID': this.productID,
      'variantTitle': this.variantTitle,
      'price': this.price,
      'image': this.image,
      'quantity': this.quantity,
    };
  }

  factory CartItem.fromJson(dynamic json) {
    return CartItem(
      json['id'],
      json['productTitle'],
      json['productID'],
      json['variantTitle'],
      json['price'],
      json['image'],
      json['quantity'],
    );
  }

  factory CartItem.fromVariant(
      Variant variant, String productTitle, String productID, int quantity) {
    return CartItem(variant.id, productTitle, productID, variant.title, variant.price,
        variant.image.originalSrc, quantity);
  }
}
