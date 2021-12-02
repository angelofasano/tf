class ShippingRate {
  String handle;
  double price;
  String title;

  ShippingRate(this.handle, this.price, this.title);

  static List<ShippingRate> fromList(List<dynamic> list) {
    return list.map((element) => ShippingRate.fromJson(element)).toList();
  }

  factory ShippingRate.fromJson(dynamic json) {
    return new ShippingRate(
        json['handle'], double.parse(json['priceV2']['amount']), json['title']);
  }
}
