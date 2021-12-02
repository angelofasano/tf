import 'package:tf/utils/apiBaseHelper.dart';

class MenuTree {
  final List<MenuNode> menu;
  MenuTree({required this.menu});

  factory MenuTree.fromJson(json) {
    return MenuTree(
        menu: (json['menu'] as List<dynamic>)
            .map((node) => new MenuNode.fromJson(node))
            .toList());
  }
}

class MenuNode {
  final List<MenuNode> child;
  final String id;
  final String title;
  final String type;

  MenuNode(
      {required this.child,
      required this.id,
      required this.title,
      required this.type});

  factory MenuNode.fromJson(json) {
    return new MenuNode(
        child: (json['child'] as List<dynamic>)
            .map((node) => new MenuNode.fromJson(node))
            .toList(),
        id: json['id'],
        title: json['title'],
        type: json['type']);
  }

  bool hasID() {
    return this.id != '';
  }

  bool isCatalogOrCollection() {
    return this.type == 'collection_link' || this.type == 'catalog_link';
  }

  bool hasChildren() {
    return this.child.isNotEmpty;
  }
}

class MenuRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<List<MenuNode>> getMenu() async {
    final response = await _helper.get(
        'https://tfabbigliamento.it//products/tuta-dainetto-up-gent-comp?view=foobar.json');
    final menu = new MenuTree.fromJson(response);
    return menu.menu;
  }
}
