import 'package:tf/models/image.dart';

class SelectedOption {
  String name;
  String value;

  SelectedOption(this.name, this.value) {
    this.name = name;
    this.value = value;
  }
}

class Variant {
  String id;
  List<SelectedOption> selectedOptions;
  bool availableForSale;
  double price;
  int quantityAvailable;
  String title;
  Image image;

  Variant(this.id, this.availableForSale, this.selectedOptions, this.price,
      this.image, this.quantityAvailable, this.title);

  factory Variant.fromJson(dynamic json) {
    bool isNode = json.containsKey('node');
    dynamic node = isNode ? json['node'] : json;
    return Variant(
        node['id'],
        node['availableForSale'],
        (node['selectedOptions'] as List<dynamic>)
            .map((option) => SelectedOption(option['name'], option['value']))
            .toList(),
        double.parse(node['priceV2']['amount']),
        new Image(node['image']['originalSrc'], node['image']['transformedSrc'],
            node['image']['width'], node['image']['height']),
        node['quantityAvailable'],
        node['title']);
  }
}
