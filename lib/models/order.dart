import 'package:tf/models/lineItem.dart';
import 'package:tf/models/orderLineItem.dart';

import 'address.dart';

class Order {
  final String id;
  final String financialStatus;
  final String fulfillmentStatus;
  final String name;
  final String orderNumber;
  final String amount;
  final Address shippingAddress;
  final List<OrderLineItem> lineItems;

  Order(
      {required this.id,
      required this.financialStatus,
      required this.fulfillmentStatus,
      required this.name,
      required this.orderNumber,
      required this.amount,
      required this.shippingAddress,
      required this.lineItems});

  static List<Order> fromJsonList(List<dynamic> ordersList) {
    return ordersList.map((order) => Order.fromJson(order?['node'])).toList();
  }
  
  factory Order.fromJson(dynamic json) {
    return Order(
        id: json['id'],
        financialStatus: json['financialStatus'],
        fulfillmentStatus: json['fulfillmentStatus'],
        name: json['name'],
        orderNumber: json['orderNumber'].toString(),
        amount: json['totalPriceV2']['amount'],
        shippingAddress: new Address.fromJson(json['shippingAddress']),
        lineItems: (json['lineItems']['edges'] as List<dynamic>)
            .map((lineItem) => new OrderLineItem.fromJson(lineItem['node']))
            .toList());
  }
}
