import 'dart:convert';
import 'package:pet_store_mobile_app/models/product.dart';
import 'package:pet_store_mobile_app/services/base_service.dart';

class ProductService extends BaseService {
  Future<List<Product>> getProducts() async {
    try {
      final response = await get('products.php');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> productsJson = data['products'];
        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to load products: Status ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
}
