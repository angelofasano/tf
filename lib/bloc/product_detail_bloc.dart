import 'dart:async';
import 'package:tf/models/product.dart';
import 'package:tf/repositories/product_repository.dart';
import 'package:tf/utils/apiResponse.dart';

class ProductDetailBloc {
  late ProductRepository _productRepository;
  late StreamController<ApiResponse<Product>> _productDetailController;

  StreamSink<ApiResponse<Product>> get productSink =>
      _productDetailController.sink;

  Stream<ApiResponse<Product>> get productStream =>
      _productDetailController.stream;

  ProductDetailBloc(String id) {
    _productDetailController = StreamController<ApiResponse<Product>>();
    _productRepository = ProductRepository();
    fetchProductFromID(id);
  }

  fetchProductFromID(String id) async {
    productSink.add(ApiResponse.loading('Fetching product'));
    try {
      Product products = await _productRepository.getFromID(id);
      productSink.add(ApiResponse.completed(products));
    } catch (e) {
      productSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _productDetailController.close();
  }
}
