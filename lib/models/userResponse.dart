import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tf/models/address.dart';
import 'package:tf/utils/request.dart';

import 'order.dart';

class UserResponse {
  static queryBuilder(String token) {
    return """
      {
        customer(customerAccessToken: "$token") {
          id,
          acceptsMarketing,
          displayName,
          email,
          firstName,
          lastName,
          phone,
          defaultAddress {
            id,
            address1,
            address2,
            city,
            company,
            country,
            firstName,
            lastName,
            phone,
            province,
            zip
          },
          addresses(first: 3) {
            edges {
              node {
                id,
                address1,
                address2,
                city,
                company,
                country,
                firstName,
                lastName,
                phone,
                province,
                zip
              }
            }
          },
          orders(first: 5, reverse: true) {
            edges {
              node {
                id,
                lineItems(first: 50){
                  edges{
                    node{
                      originalTotalPrice{amount},
                      quantity
                      title,
                    }
                  }
                },
                financialStatus,
                fulfillmentStatus,
                name,
                orderNumber,
                totalPriceV2{amount},
                shippingAddress{
                  id,
                  address1,
                  address2,
                  city,
                  company,
                  country,
                  firstName,
                  lastName,
                  phone,
                  province,
                  zip
                }
              }
            }
          }
        }
      }
    """;
  }

  final String id;
  final bool acceptsMarketing;
  final String displayName;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final Address defaultAddress;
  final List<Address> addresses;
  final List<Order> orders;

  UserResponse({
    required this.id,
    required this.acceptsMarketing,
    required this.displayName,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.defaultAddress,
    required this.addresses,
    required this.orders,
  });
}

Future<UserResponse> fetchUser({required String userAccessToken}) async {
  final response = await http.post(Request.url,
      headers: Request.headers,
      body: json.encode({'query': UserResponse.queryBuilder(userAccessToken)}));

  if (response.statusCode == 200) {
    final dynamic data = jsonDecode(response.body)['data'];
    final dynamic customer = data['customer'];
    final dynamic defAddress = customer['defaultAddress'];

    final Address defaultAddress = Address.fromJson(defAddress);

    final dynamic addressesObject = customer['addresses'];
    final List<dynamic> addressesEdges = addressesObject['edges'];
    final List<Address> addresses = addressesEdges
        .map((address) => Address.fromJson(address['node']))
        .toList();

    final dynamic ordersObject = customer['orders'];
    final List<dynamic> ordersEdges = ordersObject['edges'];
    final List<Order> orders =
        ordersEdges.map((order) => Order.fromJson(order?['node'])).toList();

    return UserResponse(
        id: customer['id'],
        acceptsMarketing: customer['acceptsMarketing'],
        displayName: customer['displayName'],
        email: customer['email'],
        firstName: customer['firstName'],
        lastName: customer['lastName'],
        phone: customer['phone'] != null ? customer['phone'] : '',
        defaultAddress: defaultAddress,
        addresses: addresses,
        orders: orders);
  } else {
    throw Exception('Failed to load user');
  }
}
