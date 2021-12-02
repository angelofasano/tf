class CustomerUserError {
  final String code;
  final String field;
  final String message;

  CustomerUserError(
      {required this.code, required this.field, required this.message});

  static List<CustomerUserError> listFromJson(List<dynamic> errorList) {
    return errorList
        .map((error) => new CustomerUserError(
            code: error['code'] ?? [''],
            field: error['field'].toString(),
            message: error['message'] ?? ['']))
        .toList();
  }

  @override
  String toString() {
    return message;
  }
}
