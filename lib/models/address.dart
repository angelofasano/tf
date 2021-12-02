class Address {
  final String id;
  final String address1;
  final String address2;
  final String city;
  final String company;
  final String country;
  final String firstName;
  final String lastName;
  final String phone;
  final String province;
  final String zip;

  Address({
    this.id = '',
    this.address1 = '',
    this.address2 = '',
    this.city = '',
    this.company = '',
    this.country = '',
    this.firstName = '',
    this.lastName = '',
    this.phone = '',
    this.province = '',
    this.zip = '',
  });

  static List<Address> fromJsonList(List<dynamic> addressesList) {
    return addressesList
        .map((address) => Address.fromJson(address?['node']))
        .toList();
  }

  toJson() {
    return {
      'address1': this.address1,
      'address2': this.address2,
      'city': this.city,
      'company': this.company,
      'country': this.country,
      'firstName': this.firstName,
      'lastName': this.lastName,
      'phone': this.phone,
      'province': this.province,
      'zip': this.zip,
    };
  }

  factory Address.fromJson(dynamic json) {
    return json != null
        ? Address(
            id: json['id'],
            address1: json['address1'],
            address2: json['address2'],
            city: json['city'],
            company: json['company'],
            country: json['country'],
            firstName: json['firstName'],
            lastName: json['lastName'],
            phone: json['phone'],
            province: json['province'],
            zip: json['zip'])
        : Address();
  }
}
