import 'dart:async';
import 'package:tf/repositories/product_repository.dart';
import 'package:tf/utils/apiResponse.dart';

class ProductListBloc {
  late ProductRepository _productRepository;
  late StreamController<ApiResponse<ProductResponse>> _productListController;

  StreamSink<ApiResponse<ProductResponse>> get productsListSink =>
      _productListController.sink;

  Stream<ApiResponse<ProductResponse>> get productsListStream =>
      _productListController.stream;

  ProductListBloc(String params, String collectionID) {
    _productListController = StreamController<ApiResponse<ProductResponse>>();
    _productRepository = ProductRepository();
    fetchProductsList(params, collectionID);
  }

  fetchProductsList(String params, String collectionID) async {
    productsListSink.add(ApiResponse.loading('Fetching products'));
    try {
      ProductResponse productResponse = await _productRepository.getFromCollection(params: params, collectionID: collectionID);
      productsListSink.add(ApiResponse.completed(productResponse));
    } catch (e) {
      productsListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _productListController.close();
  }
}
