import 'dart:async';
import 'package:tf/models/product_preview.dart';
import 'package:tf/repositories/product_search_repository.dart';
import 'package:tf/utils/apiResponse.dart';

class SearchBloc {
  late ProductSearchRepository _productSearchRepository;
  late StreamController<ApiResponse<List<ProductPreview>>> _productSearchController;

  StreamSink<ApiResponse<List<ProductPreview>>> get searchedProductsListSink =>
      _productSearchController.sink;

  Stream<ApiResponse<List<ProductPreview>>> get searchedProductsListStream =>
      _productSearchController.stream;

  SearchBloc(String title) {
    _productSearchController = StreamController<ApiResponse<List<ProductPreview>>>();
    _productSearchRepository = ProductSearchRepository();
    searchProducts(title);
  }

  searchProducts(String title) async {
    searchedProductsListSink.add(ApiResponse.loading('Searching products'));
    try {
      List<ProductPreview> products = await _productSearchRepository.searchProducts(title);
      searchedProductsListSink.add(ApiResponse.completed(products));
    } catch (e) {
      searchedProductsListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _productSearchController.close();
  }
}
