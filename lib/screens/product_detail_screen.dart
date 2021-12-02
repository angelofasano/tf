import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tf/bloc/product_detail_bloc.dart';
import 'package:tf/components/header.dart';
import 'package:tf/components/purchaseModal.dart';
import 'package:tf/components/recommendationsList.dart';
import 'package:tf/models/cartItem.dart';
import 'package:tf/models/product.dart';
import 'package:tf/models/product_preview.dart';
import 'package:tf/redux/actions/addFavoriteAction.dart';
import 'package:tf/redux/actions/deleteFavoriteAction.dart';
import 'package:tf/redux/appState.dart';
import 'package:tf/services/bar_index_service.dart';
import 'package:tf/utils/apiResponse.dart';
import 'package:tf/utils/productArguments.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  static const routeName = '/productDetail';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ProductArguments;
    return Scaffold(
      body: ProductDetailView(productID: args.productID),
    );
  }
}

class ProductDetailView extends StatefulWidget {
  ProductDetailView({Key? key, required this.productID}) : super(key: key);

  final String productID;

  @override
  State<ProductDetailView> createState() => _ProductDetailView();
}

class _ProductDetailView extends State<ProductDetailView>
    with SingleTickerProviderStateMixin {
  late ProductDetailBloc _bloc;
  AnimationController? _controller;
  double? _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
      ),
      lowerBound: 0.0,
      upperBound: 0.7,
    )..addListener(() {
        setState(() {});
      });
    _bloc = ProductDetailBloc(widget.productID);
  }

  int _getCartItems(store) {
    List<CartItem> items = store.state.cart;
    return items.fold(
        0, (previousValue, element) => previousValue + element.quantity);
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 + _controller!.value;

    return StoreConnector<AppState, dynamic>(
        converter: (store) => store,
        builder: (_, store) => Scaffold(
            floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
            floatingActionButton: _topButtons(_getCartItems(store)),
            body: StreamBuilder<ApiResponse<Product>>(
              stream: _bloc.productStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  switch (snapshot.data!.status) {
                    case Status.LOADING:
                      return const Center(child: CircularProgressIndicator());
                    case Status.COMPLETED:
                      return _onComplete(snapshot.data!.data!, store);
                    case Status.ERROR:
                      return Center(child: Text(snapshot.data!.message!));
                    default:
                      return Center(child: Text(''));
                  }
                }
                return Container();
              },
            )));
  }

  Widget _onComplete(Product product, store) {
    return Column(children: [
      Expanded(
          child: SingleChildScrollView(
        child: Column(children: [
          Stack(
            // mainAxisSize: MainAxisSize.max,
            children: [
              CarouselSlider(
                options: CarouselOptions(
                    height: MediaQuery.of(context).size.height / 1.8,
                    aspectRatio: 1,
                    viewportFraction: 1),
                items: product.images.map((image) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Image.network(image.originalSrc,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Card(
              margin: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    minVerticalPadding: 20,
                    leading: Icon(Icons.article_outlined, size: 40),
                    title: Header(label: 'Descrizione'),
                    subtitle: Text(product.description),
                  ),
                ],
              ),
            ),
            product.hasColors()
                ? Card(
                    margin: EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          minVerticalPadding: 20,
                          leading: Icon(Icons.palette_outlined, size: 40),
                          title: Header(label: 'Colori disponibili'),
                          subtitle: Text(product
                              .getVariantType('Colore')
                              .toString()
                              .replaceAll('}', '')
                              .replaceAll('{', '')),
                        ),
                      ],
                    ),
                  )
                : Text(''),
            Container(
                margin: EdgeInsets.only(left: 20, bottom: 10, top: 10),
                child: Header(label: 'Potrebbero interessarti anche')),
            RecommendationsList(productID: product.id)
          ]),
        ]),
      )),
      Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: ListTile(
                  trailing: Wrap(
                    spacing: 12,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(
                              (store.state.favorites as List<ProductPreview>)
                                      .map((favorite) => favorite.id)
                                      .contains(product.id)
                                  ? Icons.favorite
                                  : Icons.favorite_outline,
                              size: 30),
                          onPressed: () => {
                                (store.state.favorites as List<ProductPreview>)
                                        .map((favorite) => favorite.id)
                                        .contains(product.id)
                                    ? store.dispatch(DeleteFavoriteAction(
                                        productID: product.id))
                                    : store.dispatch(AddFavoriteAction(
                                        productPreview:
                                            ProductPreview.fromProduct(
                                                product)))
                              }),
                      IconButton(
                          icon:
                              Icon(Icons.add_shopping_cart_outlined, size: 30),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (ctxt) => new SimpleDialog(
                                      title: Text('Aggiungi al carrello'),
                                      children: [
                                        PurchaseModal(
                                          variantOptions:
                                              product.getVariantsMap(),
                                          product: product,
                                          onComplete: () => {
                                            _controller!.forward().then(
                                                (r) => _controller!.reverse())
                                          },
                                        )
                                      ],
                                    ));
                          }),
                    ],
                  ),
                  leading: _getPrice(product),
                  title: Header(label: product.title),
                )),
          ],
        ),
      )
    ]);
  }

  Widget _getPrice(Product product) {
    return product.isOnSale
        ? Container(
            padding: EdgeInsets.all(5),
            color: Theme.of(context).accentColor,
            child: Text(product.price(),
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.white)))
        : Container(
            padding: EdgeInsets.all(5),
            color: Theme.of(context).accentColor,
            child: Text(product.price(),
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.white)));
  }

  Widget _topButtons(int cartItems) {
    return Padding(
        padding: EdgeInsets.only(left: 35),
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                  height: 40,
                  width: 40,
                  child: FloatingActionButton(
                    heroTag: "btn1",
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.arrow_back),
                    backgroundColor: Theme.of(context).primaryColorDark,
                  )),
              Transform.scale(
                  scale: _scale!,
                  child: Stack(overflow: Overflow.visible, children: [
                    SizedBox(
                        height: 40,
                        width: 40,
                        child: FloatingActionButton(
                          heroTag: "btn2",
                          onPressed: () {
                            BarIndexService().update(4);
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/', (Route<dynamic> route) => false);
                          },
                          child: Icon(Icons.shopping_cart_outlined),
                          backgroundColor: Theme.of(context).primaryColorDark,
                        )),
                    Positioned(
                        left: -10,
                        top: -10,
                        child: cartItems > 0 ? _badge(cartItems) : Text('')),
                  ]))
            ]));
  }

  Widget _badge(int items) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(1000)),
      height: 25,
      width: 25,
      child: Center(
          child: Text(
        items.toString(),
        style: TextStyle(color: Colors.white),
      )),
    );
  }

  @override
  void dispose() {
    print('PRODUCT DETAIL DISPOSE');
    _bloc.dispose();
    super.dispose();
  }
}
