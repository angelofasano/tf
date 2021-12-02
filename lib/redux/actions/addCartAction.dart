import 'package:tf/models/variant.dart';

class AddCartAction {
  final Variant productVariant;
  final int quantity;
  final String productTitle;
  final String productID;

  AddCartAction({
    required this.productVariant,
    required this.quantity,
    required this.productTitle,
    required this.productID
  });
}
