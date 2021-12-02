class OrderLineItem {
  final int quantity;
  final String title;
  final String price;

  OrderLineItem({
    required this.quantity, required this.title, required this.price});

  factory OrderLineItem.fromJson(dynamic json) {
    return OrderLineItem(
        quantity: json['quantity'],
        title: json['title'],
        price: json['originalTotalPrice']['amount']);
  }
}
