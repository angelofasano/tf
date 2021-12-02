import 'package:tf/models/product.dart';

class ProductPreview {
  final String id;
  final String title;
  final String image;
  final double minVariantPrice;
  final double maxVariantPrice;
  final double minVariantFullPrice;
  final double maxVariantFullPrice;
  final String description;
  final bool availableForSale;

  String fullPrice() {
    return '${maxVariantFullPrice.toStringAsFixed(2)} €';
  }

  String price() {
    return '${minVariantPrice.toStringAsFixed(2)} €';
  }

  bool isOnSale() {
    return maxVariantFullPrice != 0;
  }

  toJson() {
    return {
      'id': this.id,
      'title': this.title,
      'image': this.image,
      'minVariantPrice': this.minVariantPrice,
      'maxVariantPrice': this.maxVariantPrice,
      'minVariantFullPrice': this.minVariantFullPrice,
      'maxVariantFullPrice': this.maxVariantFullPrice,
      'availableForSale': this.availableForSale,
      'description': this.description,
    };
  }

  factory ProductPreview.fromProduct(Product product) {
    return ProductPreview(product.id, product.title,
        product.images.first.originalSrc, 1, 2, 3, 4, product.description, true);
  }

  ProductPreview(
      this.id,
      this.title,
      this.image,
      this.minVariantPrice,
      this.maxVariantPrice,
      this.minVariantFullPrice,
      this.maxVariantFullPrice,
      this.description,
      this.availableForSale,
      );

  factory ProductPreview.fromJson(dynamic data) {
    final String image =
        (data['images']['edges'] as List<dynamic>).first['node']['originalSrc'];

    final dynamic price = data['priceRange'];
    final double minVariantPrice =
        double.parse(price['minVariantPrice']['amount']);
    final double maxVariantPrice =
        double.parse(price['maxVariantPrice']['amount']);

    final dynamic fullPrice = data['compareAtPriceRange'];
    final double minVariantFullPrice =
        double.parse(fullPrice['minVariantPrice']['amount']);
    final double maxVariantFullPrice =
        double.parse(fullPrice['maxVariantPrice']['amount']);

    return ProductPreview(
        data['id'],
        data['title'],
        image,
        minVariantPrice,
        maxVariantPrice,
        minVariantFullPrice,
        maxVariantFullPrice,
        data['description'],
        data['availableForSale']
        );
  }
}
