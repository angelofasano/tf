import 'package:tf/models/address.dart';

class AddressUpdateArguments {
  final String token;
  final Address address;
  final bool isDefault;
  final Function successCallback;
  AddressUpdateArguments(this.address, this.isDefault, this.token, this.successCallback);
}
