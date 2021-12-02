import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tf/components/header.dart';
import 'package:tf/models/cartItem.dart';
import 'package:tf/models/product.dart';
import 'package:tf/models/variant.dart';
import 'package:tf/redux/actions/addCartAction.dart';
import 'package:tf/redux/appState.dart';

class PurchaseModal extends StatefulWidget {
  PurchaseModal(
      {Key? key,
      required this.variantOptions,
      required this.product,
      required this.onComplete})
      : super(key: key);

  final Map<String, List<String>> variantOptions;
  final Function onComplete;
  final Product product;

  @override
  State<PurchaseModal> createState() => _PurchaseModal();
}

class _PurchaseModal extends State<PurchaseModal> {
  @override
  void initState() {
    widget.variantOptions.keys.forEach((variantName) {
      this.selectedOptions[variantName] =
          widget.variantOptions[variantName]!.first;
    });
    super.initState();
  }

  Map<String, String> selectedOptions = new Map();
  List<DropdownButton<String>> dropdowns = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(25),
        child: Container(
            height: 250,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ...widget.variantOptions.keys
                      .map((variantName) => Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Header(label: variantName),
                                DropdownButton<String>(
                                  value: this.selectedOptions[variantName],
                                  items: widget.variantOptions[variantName]!
                                      .map((option) => DropdownMenuItem(
                                          value: option, child: Text(option)))
                                      .toList(),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                  underline: Container(
                                    height: 2,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      final Map<String, String> newOptions = {};
                                      newOptions.addAll(this.selectedOptions);
                                      newOptions[variantName] = newValue!;
                                      this.selectedOptions = newOptions;
                                    });
                                  },
                                )
                              ]))
                      .toList(),
                  Text(
                    '${widget.product.getVariantPrice(widget.product.getVariantId(this.selectedOptions.values.join('-')))} ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).accentColor),
                  ),
                  StoreConnector<AppState, dynamic>(
                    converter: (store) => store,
                    builder: (_, store) => ElevatedButton(
                      onPressed: canPurchase(widget.product,
                              this.selectedOptions.values.join('-'))
                          ? () {
                              final String options =
                                  this.selectedOptions.values.join('-');
                              final String variantID =
                                  widget.product.getVariantId(options);
                              final Variant selectedVariant =
                                  widget.product.variants.firstWhere(
                                      (element) => element.id == variantID);

                              bool isAlreadyInCart =
                                  (store.state.cart as List<CartItem>).any(
                                      (element) =>
                                          element.variantID == variantID);

                              if (isAlreadyInCart) {
                                CartItem cartVariant =
                                    (store.state.cart as List<CartItem>)
                                        .firstWhere((element) =>
                                            element.variantID == variantID);

                                // bool allInCart = cartVariant.quantity >=
                                //     selectedVariant.quantityAvailable;

                                // if (allInCart) {
                                //   Navigator.pop(context);
                                //   ScaffoldMessenger.of(context).showSnackBar(
                                //     SnackBar(
                                //         content: Text(
                                //             'Tutti i ${widget.product.title} - ${selectedVariant.title} sono nel tuo carrello')),
                                //   );
                                // } else {
                                  Navigator.pop(context);
                                  store.dispatch(AddCartAction(
                                      productVariant: selectedVariant,
                                      quantity: cartVariant.quantity + 1,
                                      productTitle: widget.product.title,
                                      productID: widget.product.id));
                                  widget.onComplete();
                                // }
                              } else {
                                Navigator.pop(context);
                                store.dispatch(AddCartAction(
                                    productVariant: selectedVariant,
                                    quantity: 1,
                                    productTitle: widget.product.title,
                                    productID: widget.product.id));
                                widget.onComplete();
                              }
                            }
                          : null,
                      child: Text(canPurchase(widget.product,
                              this.selectedOptions.values.join('-'))
                          ? 'Acquista'
                          : 'Esaurito'),
                    ),
                  ),
                ])));
  }

  bool canPurchase(Product product, String options) {
    final variantID = product.getVariantId(options);
    return product.isVariantAvailableForSale(variantID);
  }
}
