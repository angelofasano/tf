import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tf/components/menuItem.dart';
import 'package:tf/redux/appState.dart';
import 'package:tf/repositories/menu_repository.dart';

class MenuScreen extends StatefulWidget {
  MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
        converter: (store) => store,
        builder: (_, store) {
          final List<MenuNode> filteredList = store.state.menu
              .where(
                  (node) => node.hasChildren() || node.isCatalogOrCollection())
              .toList();

          final List<MenuItem> menuItems = filteredList
              .asMap()
              .entries
              .map((e) => MenuItem(
                    context: context,
                    menuNode: e.value,
                    totalCount: filteredList.length,
                    index: e.key,
                  ))
              .toList();

          return Scaffold(
              body: SafeArea(
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: menuItems.length,
              itemBuilder: (BuildContext context, int index) {
                return menuItems[index];
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
          ));
        });
  }
}
