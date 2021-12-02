import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tf/components/empty.dart';
import 'package:tf/components/error.dart';
import 'package:tf/components/sortModal.dart';
import 'package:tf/models/cartItem.dart';
import 'package:tf/models/product_preview.dart';
import 'package:tf/redux/appState.dart';
import 'package:tf/repositories/product_repository.dart';
import 'package:tf/screens/product_detail_screen.dart';
import 'package:tf/services/bar_index_service.dart';
import 'package:tf/utils/collectionArguments.dart';
import 'package:flutter/cupertino.dart';
import 'package:tf/utils/productArguments.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  static const routeName = '/productList';

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as CollectionArguments;
    return Scaffold(
      body: ProductListView(collectionID: args.id, title: args.title),
    );
  }
}

class ProductListView extends StatefulWidget {
  ProductListView({Key? key, required this.collectionID, required this.title})
      : super(key: key);

  final String collectionID;
  final String title;

  @override
  State<ProductListView> createState() => _ProductListView();
}

class _ProductListView extends State<ProductListView> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  int _getCartItems(store) {
    List<CartItem> items = store.state.cart;
    return items.fold(
        0, (previousValue, element) => previousValue + element.quantity);
  }

  bool _hasMore = false;
  bool _error = false;
  bool _loading = false;
  int _pageCount = 10;
  String _sortType = 'CREATED';
  bool reverse = true;
  String _cursor = '';
  List<ProductPreview> _products = [];
  final int _nextPageThreshold = 5;

  String _getParams() {
    return 'first: $_pageCount, sortKey:$_sortType, reverse: $reverse';
  }

  String _nextPage() {
    return 'first: $_pageCount, after:"$_cursor", sortKey:$_sortType, reverse: $reverse';
  }

  @override
  void initState() {
    super.initState();
    _hasMore = true;
    _error = false;
    _loading = true;
    _products = [];
    fetchProducts(_getParams());
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
        converter: (store) => store,
        builder: (_, store) => Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (ctxt) => new SimpleDialog(
                          title: Text('Ordina'),
                          children: [
                            SortModal(
                              selectedSort: _sortType,
                              reverse: reverse,
                              setSort: (String sortType, bool reverse) {
                                Navigator.pop(ctxt);
                                setState(() {
                                  this._sortType = sortType;
                                  this._products = [];
                                  this.reverse = reverse;
                                  this._loading = true;
                                  fetchProducts(_getParams());
                                });
                              },
                            )
                          ],
                        ));
              },
              icon: Icon(Icons.sort)),
          Stack(children: [
            IconButton(onPressed: () {
            BarIndexService().update(4);
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/', (Route<dynamic> route) => false);
          }, icon: Icon(Icons.shopping_cart_outlined)),
          store.state.cart.length > 0 ? _badge(_getCartItems(store)) : Text('')
        ])
        ],
      ),
      body: getBody(),
    ));
  }

   Widget _badge(int items) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(1000)),
      height: 20,
      width: 20,
      child: Center(
          child: Text(
        items.toString(),
        style: TextStyle(color: Colors.white, fontSize: 11),
      )),
    );
  }

  Widget getBody() {
    if (_products.isEmpty) {
      if (_loading) {
        return Center(
            child: Padding(
          padding: const EdgeInsets.all(8),
          child: CircularProgressIndicator(),
        ));
      } else if (_error) {
        return Error(
            onPress: () => setState(
                  () {
                    _loading = true;
                    _error = false;
                    fetchProducts(_getParams());
                  },
                ));
      } else
        return Empty();
    } else {
      return ListView.builder(
        itemCount: _products.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _products.length - _nextPageThreshold) {
            fetchProducts(_nextPage());
          }
          if (index == _products.length) {
            if (_error) {
              return Error(
                  onPress: () => setState(
                        () {
                          _loading = true;
                          _error = false;
                          fetchProducts(_getParams());
                        },
                      ));
            } else {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }
          final ProductPreview product = _products[index];
          return productListCard(product);
        },
      );
    }
  }

  Widget productListCard(ProductPreview product) {
    return InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            ProductDetailScreen.routeName,
            arguments: ProductArguments(product.id),
          );
        },
        child: Card(
          margin: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.network(product.image,
                  fit: BoxFit.cover, width: double.infinity, height: 350,
                  loadingBuilder: (context, widget, loadingProgress) {
                return loadingProgress == null
                    ? widget
                    : Container(
                        color: Colors.grey.shade200,
                        height: 350,
                      );
              }, errorBuilder: (context, obj, stack) {
                return Container(
                  height: 350,
                  color: Colors.grey.shade200,
                  child: Icon(Icons.error, size: 30),
                );
              }),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(product.title,
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17, color: Theme.of(context).primaryColorDark)),
                      product.isOnSale()
                          ? Row(children: [
                              Text(product.fullPrice(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 17,
                                      decoration: TextDecoration.lineThrough, color: Theme.of(context).accentColor)),
                              Container(
                                  margin: EdgeInsets.only(left: 10),
                                  padding: EdgeInsets.all(5),
                                  child: Text(product.price(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 17,
                                          color: Colors.white)),
                                  decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).primaryColorDark))
                            ])
                          : Text(product.price(),
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17, color: Theme.of(context).accentColor)),
                    ]),
              ),
               Padding(
                 padding: EdgeInsets.only(top: 0, bottom: 16, left: 16, right: 16),
                 child: product.availableForSale ? SizedBox.shrink() : 
                 Container(
                   padding: EdgeInsets.all(5),
                   color: Theme.of(context).primaryColorLight,
                   child: Text('Esaurito'.toUpperCase(), style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17, color: Colors.white))))
            ],
          ),
        ));
  }

  Future<void> fetchProducts(String params) async {
    try {
      final productResponse = await ProductRepository()
          .getFromCollection(params: params, collectionID: widget.collectionID);
      List<ProductPreview> fetchedProducts = productResponse.products;
      setState(
        () {
          _hasMore = productResponse.hasNextPage;
          _loading = false;
          _products.addAll(fetchedProducts);
          _cursor = productResponse.lastCursor;
        },
      );
    } catch (e) {
      setState(
        () {
          _loading = false;
          _error = true;
        },
      );
    }
  }
}
