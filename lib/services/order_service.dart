import 'dart:convert';
import '../models/order.dart';
import '../models/cart_item.dart';
import 'base_service.dart';

class OrderService extends BaseService {
  // Get user's orders
  Future<List<Order>> getUserOrders() async {
    try {
      final response = await get('orders');

      print('Orders response status: ${response.statusCode}');
      print('Orders response body: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);

        // Handle different response structures
        List<dynamic> ordersJson;
        if (data is Map && data.containsKey('data')) {
          ordersJson = data['data'];
        } else if (data is List) {
          ordersJson = data;
        } else {
          ordersJson = [];
        }

        return ordersJson.map((json) => Order.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load orders: Status ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching orders: $e');
      throw Exception('Error fetching orders: $e');
    }
  }

  // Get specific order
  Future<Order?> getOrder(int orderId) async {
    try {
      final response = await get('orders/$orderId');

      print('Order detail response status: ${response.statusCode}');
      print('Order detail response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Handle different response structures
        Map<String, dynamic> orderJson;
        if (data.containsKey('data')) {
          orderJson = data['data'];
        } else if (data.containsKey('order')) {
          orderJson = data['order'];
        } else {
          orderJson = data;
        }

        return Order.fromJson(orderJson);
      } else {
        throw Exception('Failed to load order: Status ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching order: $e');
      throw Exception('Error fetching order: $e');
    }
  }

  // Create new order
  Future<Order?> createOrder(
      List<CartItem> cartItems, String shippingAddress) async {
    try {
      // Prepare order items
      List<Map<String, dynamic>> items = cartItems
          .map((item) => {
                'product_id': item.product.id,
                'quantity': item.quantity,
              })
          .toList();

      final orderData = {
        'shipping_address': shippingAddress,
        'items': items,
      };

      print('Creating order with data: ${jsonEncode(orderData)}');

      final response = await post('orders', body: orderData);

      print('Create order response status: ${response.statusCode}');
      print('Create order response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] == true && data['order'] != null) {
          return Order.fromJson(data['order']);
        } else {
          throw Exception(data['error'] ?? 'Failed to create order');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['error'] ?? 'Failed to create order');
      }
    } catch (e) {
      print('Error creating order: $e');
      throw Exception('Error creating order: $e');
    }
  }

  // Calculate order total
  double calculateTotal(List<CartItem> cartItems) {
    return cartItems.fold(0.0, (total, item) => total + item.totalPrice);
  }
}
