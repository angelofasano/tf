import 'package:tf/models/variant.dart';
import 'package:tf/models/image.dart';

class Product {
  final String id;
  final String title;
  final List<Image> images;
  final double minVariantPrice;
  final double maxVariantPrice;
  final double minVariantFullPrice;
  final double maxVariantFullPrice;
  final bool isOnSale;
  final List<Variant> variants;
  final String description;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.images,
    required this.minVariantPrice,
    required this.maxVariantPrice,
    required this.minVariantFullPrice,
    required this.maxVariantFullPrice,
    required this.isOnSale,
    required this.variants,
  });

  String fullPrice() {
    return '${maxVariantFullPrice.toStringAsFixed(2)} €';
  }

  String price() {
    return '${minVariantPrice.toStringAsFixed(2)} €';
  }

  Set<String> getVariantType(String variantType) {
    final List<SelectedOption> options = this.variants.fold([],
        (previousValue, element) => previousValue + element.selectedOptions);
    return new Set.from(options
        .where((option) => option.name == variantType)
        .map((optionColor) => optionColor.value));
  }

  Set<String> getAllVariantNames() {
    return new Set.from(this.variants.fold(
        [],
        (previousValue, element) => [
              ...previousValue,
              ...element.selectedOptions.map((option) => option.name)
            ]));
  }

  Map<String, List<String>> getVariantsMap() {
    final Map<String, List<String>> variantsMap = new Map();

    this.getAllVariantNames().forEach((variantName) {
      variantsMap[variantName] = getVariantType(variantName).toList();
    });

    return variantsMap;
  }

  String getVariantId(String options) {
    final List<String> optionNames = options.split('-');
    final int selectedVariantIndex = this.variants.indexWhere((variant) =>
        variant.selectedOptions
            .every((option) => optionNames.contains(option.value)));

    return selectedVariantIndex == -1
        ? ''
        : this.variants[selectedVariantIndex].id;
  }

  String getVariantPrice(String variantID) {
    final int selectedVariantIndex =
        this.variants.indexWhere((variant) => variant.id == variantID);

    return selectedVariantIndex == -1 ? '' : '${this.variants[selectedVariantIndex].price.toStringAsFixed(2)} €';
  }

  bool isVariantAvailableForSale(String variantID) {
    final int foundedIndex =
        this.variants.indexWhere((variant) => variant.id == variantID);
    return foundedIndex == -1
        ? false
        : this.variants[foundedIndex].availableForSale;
  }

  int getColorsCount() {
    return this.getVariantType('Colore').length;
  }

  bool hasColors() {
    return this.getColorsCount() > 0;
  }

  factory Product.fromJson(dynamic data) {
    final List<Image> images = (data['images']['edges'] as List<dynamic>)
        .map((edge) => Image(
            edge['node']['originalSrc'],
            edge['node']['transformedSrc'],
            edge['node']['width'],
            edge['node']['height']))
        .toList();

    final List<Variant> variants = (data['variants']['edges'] as List<dynamic>)
        .map((edge) => Variant.fromJson(edge))
        .toList();

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

    return Product(
        id: data['id'],
        title: data['title'],
        description: data['description'],
        images: images,
        minVariantPrice: minVariantPrice,
        maxVariantPrice: maxVariantPrice,
        minVariantFullPrice: minVariantFullPrice,
        maxVariantFullPrice: maxVariantFullPrice,
        isOnSale: maxVariantFullPrice != 0,
        variants: variants);
  }
}
