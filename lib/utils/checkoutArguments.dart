import 'package:tf/repositories/user_repository.dart';

class CheckoutArguments {
  final UserResponse? user;
  final String checkoutID;
  CheckoutArguments(this.user, this.checkoutID);
}
