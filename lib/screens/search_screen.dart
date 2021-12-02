import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tf/bloc/search_bloc.dart';
import 'package:tf/components/listProductCard.dart';
import 'package:tf/models/product_preview.dart';
import 'package:tf/utils/apiResponse.dart';

class SearchScreen extends StatefulWidget {
  static String routeName = '/search';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late SearchBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = SearchBloc('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Ricerca')),
        body: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.max,
      children: [
        _textField(),
        StreamBuilder<ApiResponse<List<ProductPreview>>>(
          stream: _bloc.searchedProductsListStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data!.status) {
                case Status.LOADING:
                  return const Padding(padding: EdgeInsets.only(top: 50), child: CircularProgressIndicator());
                case Status.COMPLETED:
                  return _onComplete(snapshot.data!.data!);
                case Status.ERROR:
                  return Center(child: Text(snapshot.data!.message!));
                default:
                  return Center(child: Text(''));
              }
            }
            return Container();
          },
        ),
      ],
    )));
  }

  Widget _onComplete(List<ProductPreview> products) {
    return Expanded(
        child: ListView(
            shrinkWrap: true,
            children:
                products.map((p) => ListProductCard(product: p)).toList()));
  }

  Widget _textField() {
    return Padding(
        padding: EdgeInsets.all(10),
        child: TextField(
          obscureText: false,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Nome prodotto',
            
            suffixIcon: Icon(Icons.search)
          ),
          onChanged: (value) {
            _bloc.searchProducts(value);
          },
        ));
  }

  @override
  void dispose() {
    print('SEARCH DISPOSE');
    _bloc.dispose();
    super.dispose();
  }
}
