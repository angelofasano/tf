import 'dart:convert';

import 'package:tf/models/address.dart';
import 'package:tf/models/order.dart';
import 'package:tf/utils/apiBaseHelper.dart';
import 'package:tf/utils/request.dart';

class UserRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<UserResponse> getUser(String accessToken) async {
    String query = """
      {
        customer(customerAccessToken: "$accessToken") {
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

    final response = await _helper.post(
        headers: Request.headers, body: jsonEncode({'query': query}));

    final dynamic data = response['data'];
    final dynamic customer = data['customer'];
    final dynamic defAddress = customer['defaultAddress'];

    final Address defaultAddress = Address.fromJson(defAddress);

    final List<Address> addresses =
        Address.fromJsonList(customer['addresses']['edges']);

    final List<Order> orders = Order.fromJsonList(customer['orders']['edges']);

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
  }
}

class UserResponse {
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
