import 'dart:convert';
import 'package:tf/models/product.dart';
import 'package:tf/models/product_preview.dart';
import 'package:tf/utils/apiBaseHelper.dart';
import 'package:tf/utils/request.dart';

class ProductRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<Product> getFromID(String id) async {
    String query = '''
    query node(\$id: ID!) {
        node(id: \$id) {
            ... on Product {
            id,
            title,
            description,
            images(first: 5) {
                edges {
                    node {
                        originalSrc,
                        transformedSrc(crop:CENTER, maxHeight:50, maxWidth: 50),
                        width,
                        height
                    }
                }
            },
            variants(first: 50) {
              edges {
                node {
                  id,
                  selectedOptions{name, value},
                  quantityAvailable,
                  availableForSale,
                  title,
                  priceV2{amount},
                  image{
                    originalSrc, 
                    transformedSrc(crop:CENTER, maxHeight:50, maxWidth: 50),
                    width,
                    height
                  }
                }
              }
            },
            compareAtPriceRange{
              minVariantPrice{amount},
              maxVariantPrice{amount}
            }
            priceRange{
              minVariantPrice{amount},
              maxVariantPrice{amount}
            }
        }
      }
    }
    ''';

    final response = await _helper.post(
        headers: Request.headers,
        body: jsonEncode({
          'query': query,
          'variables': {'id': id}
        }));

    return Product.fromJson(response['data']['node']);
  }

  Future<List<ProductPreview>> getLastProducts() async {
    final String query = '''
    {
      products(first: 5, sortKey:CREATED_AT, reverse: true) {
        edges {
            node {
                id,
                title,
                description,
                availableForSale,
                images(first: 1) {
                    edges {
                        node {
                            originalSrc
                        }
                    }
                },
                compareAtPriceRange{
                minVariantPrice{amount},
                maxVariantPrice{amount}
                }
                priceRange{
                  minVariantPrice{amount},
                  maxVariantPrice{amount}
                }
              }
            }
          }
        }
    ''';
    final response = await _helper.post(
        headers: Request.headers, body: jsonEncode({'query': query}));

    final List<dynamic> productEdges = response['data']['products']['edges'];

    return productEdges
        .map((edge) => ProductPreview.fromJson(edge['node']))
        .toList();
  }

  Future<ProductResponse> getFromCollection(
      {required String params, required String collectionID}) async {
    final String query = '''
    query nodes(\$ids: [ID!]!) {
      nodes(ids: \$ids) {
          ... on Collection {
          id,
          products($params) {
          pageInfo
          {
              hasNextPage,
              hasPreviousPage
          }
          edges {
              cursor
              node {
                  id,
                  title,
                  availableForSale,
                  description,
                  images(first: 1) {
                      edges {
                          node {
                              originalSrc,
                          }
                      }
                  },
                  compareAtPriceRange{
                    minVariantPrice{amount},
                    maxVariantPrice{amount}
                  }
                  priceRange{
                      minVariantPrice{amount},
                      maxVariantPrice{amount}
                    }
                  }
              }
          }
        }
      }
    }
    ''';

    final response = await _helper.post(
        headers: Request.headers,
        body: jsonEncode({
          'query': query,
          'variables': {
            'ids': ['gid://shopify/Collection/$collectionID']
          }
        }));

    return ProductResponse(
        products: _getProducts(response),
        hasNextPage: response['data']?['nodes']?[0]?['products']?['pageInfo']
                ?['hasNextPage'] ??
            [''],
        hasPreviousPage: response['data']?['nodes']?[0]?['products']
                ?['pageInfo']?['hasNextPage'] ??
            [''],
        firstCursor: _getFirstCursor(response),
        lastCursor: _getLastCursor(response));
  }

  List<ProductPreview> _getProducts(response) {
    List<dynamic> edges = response['data']?['nodes']?[0]?['products']?['edges'];
    return edges.isNotEmpty
        ? edges.map((edge) => ProductPreview.fromJson(edge['node'])).toList()
        : [];
  }

  String _getFirstCursor(dynamic response) {
    List<dynamic> edges = response['data']?['nodes']?[0]?['products']?['edges'];
    return edges.isEmpty ? '' : edges.first['cursor'];
  }

  String _getLastCursor(dynamic response) {
    List<dynamic> edges = response['data']?['nodes']?[0]?['products']?['edges'];
    return edges.isEmpty ? '' : edges[edges.length - 1]['cursor'];
  }
}

class ProductResponse {
  final List<ProductPreview> products;

  final bool hasNextPage;
  final bool hasPreviousPage;

  final String firstCursor;
  final String lastCursor;

  ProductResponse({
    required this.products,
    required this.hasNextPage,
    required this.hasPreviousPage,
    required this.firstCursor,
    required this.lastCursor,
  });
}
