import 'package:tf/models/cartItem.dart';
import 'package:tf/models/product_preview.dart';
import 'package:tf/repositories/menu_repository.dart';

class AppState {
  final List<ProductPreview> favorites;
  final List<CartItem> cart;
  final String userAccessToken;
  final List<MenuNode> menu;
  final List<ProductPreview> lastProducts;

  AppState(
      {this.favorites = const [],
      this.userAccessToken = '',
      this.menu = const [],
      this.lastProducts = const [],
      this.cart = const []});

  AppState copyWith(
          {List<ProductPreview>? favorites,
          String? userAccessToken,
          List<MenuNode>? menu,
          List<ProductPreview>? lastProducts,
          List<CartItem>? cart}) =>
      AppState(
          favorites: favorites ?? this.favorites,
          menu: menu ?? this.menu,
          lastProducts: lastProducts ?? this.lastProducts,
          userAccessToken: userAccessToken ?? this.userAccessToken,
          cart: cart ?? this.cart);

  static AppState? fromJson(dynamic json) {
    if (json == null) {
      return null;
    }

    final List<ProductPreview> favoriteElements = [];
    if (json.containsKey('favorites') && json['favorites'] != null)
      (json['favorites'] as List<dynamic>).forEach((productPreview) {
        favoriteElements.add(ProductPreview(
            productPreview['id'],
            productPreview['title'],
            productPreview['image'],
            productPreview['minVariantPrice'],
            productPreview['maxVariantPrice'],
            productPreview['minVariantFullPrice'],
            productPreview['maxVariantFullPrice'],
            productPreview['description'],
            productPreview['availableForSale']
            ));
      });

    final List<ProductPreview> lastProductsElements = [];
    if (json.containsKey('lastProducts') && json['lastProducts'] != null)
      (json['lastProducts'] as List<dynamic>).forEach((lastProduct) {
        favoriteElements.add(ProductPreview(
            lastProduct['id'],
            lastProduct['title'],
            lastProduct['image'],
            lastProduct['minVariantPrice'],
            lastProduct['maxVariantPrice'],
            lastProduct['minVariantFullPrice'],
            lastProduct['maxVariantFullPrice'],
            lastProduct['description'],
            lastProduct['availableForSale']
            ));
      });

    final List<CartItem> cartElements = [];
    if (json.containsKey('cart') && json['cart'] != null)
      (json['cart'] as List<dynamic>).forEach((element) {
        cartElements
            .add(new CartItem.fromJson(element));
      });

    final String userAccessToken =
        json.containsKey('userAccessToken') ? json['userAccessToken'] : '';

    return AppState(
        favorites: favoriteElements,
        userAccessToken: userAccessToken,
        menu: [],
        lastProducts: lastProductsElements,
        cart: cartElements);
  }

  dynamic toJson() => {
        'favorites': favorites.map((e) => e.toJson()).toList(),
        'userAccessToken': userAccessToken,
        'cart': cart
            .map((item) => item.toJson())
            .toList()
      };
}
