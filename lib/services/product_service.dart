import 'dart:convert';
import '../models/product.dart';
import 'base_service.dart';

class ProductService extends BaseService {
  // Get all products
  Future<List<Product>> getProducts({
    int? categoryId,
    String? search,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    String? sortOrder,
    int? limit,
  }) async {
    try {
      // Build query parameters
      Map<String, String> queryParams = {};

      if (categoryId != null)
        queryParams['category_id'] = categoryId.toString();
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (minPrice != null) queryParams['min_price'] = minPrice.toString();
      if (maxPrice != null) queryParams['max_price'] = maxPrice.toString();
      if (sortBy != null) queryParams['sort_by'] = sortBy;
      if (sortOrder != null) queryParams['sort_order'] = sortOrder;
      if (limit != null) queryParams['limit'] = limit.toString();

      String queryString = '';
      if (queryParams.isNotEmpty) {
        queryString = '?' +
            queryParams.entries
                .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
                .join('&');
      }

      final response = await get('products$queryString');

      print('Products response status: ${response.statusCode}');
      print('Products response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Handle both paginated and direct array responses
        List<dynamic> productsJson;
        if (data.containsKey('data')) {
          productsJson = data['data'];
        } else if (data.containsKey('products')) {
          productsJson = data['products'];
        } else {
          productsJson = data is List ? data as List<dynamic> : [];
        }

        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to load products: Status ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching products: $e');
      throw Exception('Error fetching products: $e');
    }
  }

  // Get product by ID
  Future<Product?> getProduct(int id) async {
    try {
      final response = await get('products/$id');

      print('Product detail response status: ${response.statusCode}');
      print('Product detail response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        Map<String, dynamic> productJson;
        if (data.containsKey('data')) {
          productJson = data['data'];
        } else if (data.containsKey('product')) {
          productJson = data['product'];
        } else {
          productJson = data;
        }

        return Product.fromJson(productJson);
      } else {
        throw Exception(
            'Failed to load product: Status ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching product: $e');
      throw Exception('Error fetching product: $e');
    }
  }

  // Get featured products
  Future<List<Product>> getFeaturedProducts() async {
    try {
      final products = await getProducts(limit: 10);
      return products.where((product) => product.isFeatured).toList();
    } catch (e) {
      print('Error fetching featured products: $e');
      throw Exception('Error fetching featured products: $e');
    }
  }

  // Search products
  Future<List<Product>> searchProducts(String query) async {
    return getProducts(search: query);
  }

  // Get products by category
  Future<List<Product>> getProductsByCategory(int categoryId) async {
    return getProducts(categoryId: categoryId);
  }
}
