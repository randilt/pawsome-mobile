import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pet_store_mobile_app/models/product.dart';

class ProductService {
  static const String baseUrl = 'http://localhost/pawsome/api';

  Future<List<Product>> getProducts() async {
    try {
      final url = Uri.parse('$baseUrl/products/get_products.php');
      // print('Fetching products from: $url'); // Debug print

      final response = await http.get(url);
      // print('Response status code: ${response.statusCode}'); // Debug print
      // print('Response body: ${response.body}'); // Debug print

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> productsJson = data['products'];
        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to load products: Status ${response.statusCode}');
      }
    } catch (e) {
      // print('Error details: $e'); // Debug print
      throw Exception('Error fetching products: $e');
    }
  }
}
