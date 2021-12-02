class UserUpdateArguments {
  final String token;
  final Function successCallback;
  final bool acceptsMarketing;
  final String email;
  final String phone;
  UserUpdateArguments(this.token, this.successCallback, this.acceptsMarketing,
      this.email, this.phone);
}
