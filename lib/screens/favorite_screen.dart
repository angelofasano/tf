import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tf/components/listProductCard.dart';
import 'package:tf/models/product_preview.dart';
import 'package:tf/redux/actions/deleteAllFavoritesAction.dart';
import 'package:tf/redux/actions/deleteFavoriteAction.dart';
import 'package:tf/redux/appState.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
        converter: (store) => store,
        builder: (_, store) => Scaffold(
              body: store.state.favorites.isEmpty
                  ? Stack(children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Image.asset('images/no_favorites.png'),
                      ),
                      Container(
                          margin: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.height / 15),
                          alignment: Alignment.bottomCenter,
                          decoration: BoxDecoration(color: Colors.transparent),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Padding(
                                  padding: EdgeInsets.all(30),
                                  child: Text(
                                    'Non hai aggiunto articoli preferiti',
                                    style: TextStyle(
                                        color:
                                            Theme.of(context).primaryColorDark,
                                        fontWeight: FontWeight.bold),
                                  ))))
                    ])
                  : ListView(
                      children: (store.state.favorites as List<ProductPreview>)
                          .map((p) => Dismissible(
                              confirmDismiss:
                                  (DismissDirection direction) async {
                                return await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Elimina'),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
                                            Text(
                                                'Sei sicuro di voler eliminare ${p.title}')
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('Annulla'),
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('Conferma'),
                                          onPressed: () {
                                            store.dispatch(DeleteFavoriteAction(
                                                productID: p.id));
                                            Navigator.of(context).pop(true);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              key: Key(p.id),
                              direction: DismissDirection.endToStart,
                              background: Card(
                                  margin: EdgeInsets.all(10),
                                  child: Center(
                                      child: Text('Elimina',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white))),
                                  color: Colors.red),
                              child: ListProductCard(product: p)))
                          .toList()),
              floatingActionButton: store.state.favorites.isEmpty
                  ? null
                  : FloatingActionButton(
                      onPressed: () {
                        _showConfirmDialog(store);
                      },
                      child: const Icon(Icons.delete_sweep_outlined),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
            ));
  }

  _showConfirmDialog(store) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Elimina'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Sei sicuro di voler cancellare tutti i preferiti?')
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annulla'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Conferma'),
              onPressed: () {
                store.dispatch(DeleteAllFavoritesAction());
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
