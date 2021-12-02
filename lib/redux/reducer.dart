import 'package:tf/models/cartItem.dart';
import 'package:tf/redux/actions/addFavoriteAction.dart';
import 'package:tf/redux/actions/deleteAllFavoritesAction.dart';
import 'package:tf/redux/actions/deleteFavoriteAction.dart';
import 'package:tf/redux/actions/deleteUserAccessTokenAction.dart';
import 'package:tf/redux/actions/setUserAccessToken.dart';
import 'package:tf/redux/actions/updateLastProductsAction.dart';
import 'package:tf/redux/appState.dart';

import 'actions/addCartAction.dart';
import 'actions/deleteAllCartAction.dart';
import 'actions/deleteCartAction.dart';
import 'actions/updateCartAction.dart';

AppState reducer(AppState state, Object? action) {
  // FAVORITES
  if (action is AddFavoriteAction) {
    return state
        .copyWith(favorites: [...state.favorites, action.productPreview]);
  }

  if (action is DeleteAllFavoritesAction) {
    return state.copyWith(favorites: []);
  }

  if (action is DeleteFavoriteAction) {
    return state.copyWith(
        favorites: new List.from(state.favorites
            .where((element) => element.id != action.productID)));
  }

  // CART
  if (action is AddCartAction) {
    return state.copyWith(cart: [
      ...state.cart.where((item) => item.variantID != action.productVariant.id),
      new CartItem.fromVariant(action.productVariant, action.productTitle, action.productID, action.quantity)
    ]);
  }

   if (action is UpdateCartAction) {
    return state.copyWith(cart: [
      ...state.cart.where((item) => item.variantID != action.item.variantID),
      action.item
    ]);
  }

  if (action is DeleteAllCartAction) {
    return state.copyWith(cart: []);
  }

  if (action is DeleteCartAction) {
    return state.copyWith(
        cart: new List.from(state.cart
            .where((element) => element.variantID != action.productVariantID)));
  }

  // LOGIN
  if (action is SetUserAccessTokenAction) {
    return state.copyWith(userAccessToken: action.token);
  }

  if (action is DeleteUserAccessTokenAction) {
    return state.copyWith(userAccessToken: '');
  }

  // UPDATE LAST PRODUCTS
  if(action is UpdateLastProductAction) {
    return state.copyWith(lastProducts: action.lastProducts);
  }

  return state;
}
