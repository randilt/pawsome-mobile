import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import 'product_service.dart';

class CartService {
  static const String _cartKey = 'cart_items';
  final ProductService _productService = ProductService();

  // Get cart items
  Future<List<CartItem>> getCartItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartData = prefs.getString(_cartKey);

      if (cartData == null) return [];

      final List<dynamic> cartJson = jsonDecode(cartData);
      List<CartItem> cartItems = [];

      for (var item in cartJson) {
        try {
          // Get product details from API
          final product = await _productService.getProduct(item['product_id']);
          if (product != null) {
            cartItems.add(CartItem(
              product: product,
              quantity: item['quantity'],
            ));
          }
        } catch (e) {
          print('Error loading cart item product: $e');
        }
      }

      return cartItems;
    } catch (e) {
      print('Error getting cart items: $e');
      return [];
    }
  }

  // Add item to cart
  Future<void> addToCart(Product product, {int quantity = 1}) async {
    try {
      final cartItems = await getCartItems();

      // Check if item already exists
      final existingIndex = cartItems.indexWhere(
        (item) => item.product.id == product.id,
      );

      if (existingIndex >= 0) {
        // Update quantity
        cartItems[existingIndex].quantity += quantity;
      } else {
        // Add new item
        cartItems.add(CartItem(product: product, quantity: quantity));
      }

      await _saveCart(cartItems);
    } catch (e) {
      print('Error adding to cart: $e');
      throw Exception('Failed to add item to cart');
    }
  }

  // Update cart item quantity
  Future<void> updateQuantity(int productId, int quantity) async {
    try {
      final cartItems = await getCartItems();

      final itemIndex = cartItems.indexWhere(
        (item) => item.product.id == productId,
      );

      if (itemIndex >= 0) {
        if (quantity <= 0) {
          cartItems.removeAt(itemIndex);
        } else {
          cartItems[itemIndex].quantity = quantity;
        }
        await _saveCart(cartItems);
      }
    } catch (e) {
      print('Error updating cart quantity: $e');
      throw Exception('Failed to update cart item');
    }
  }

  // Remove item from cart
  Future<void> removeFromCart(int productId) async {
    try {
      final cartItems = await getCartItems();
      cartItems.removeWhere((item) => item.product.id == productId);
      await _saveCart(cartItems);
    } catch (e) {
      print('Error removing from cart: $e');
      throw Exception('Failed to remove item from cart');
    }
  }

  // Clear cart
  Future<void> clearCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cartKey);
    } catch (e) {
      print('Error clearing cart: $e');
      throw Exception('Failed to clear cart');
    }
  }

  // Get cart total
  Future<double> getCartTotal() async {
    final cartItems = await getCartItems();
    double total = 0.0;
    for (var item in cartItems) {
      total += item.totalPrice;
    }
    return total;
  }

  // Get cart item count
  Future<int> getCartItemCount() async {
    final cartItems = await getCartItems();
    return cartItems.fold<int>(0, (count, item) => count + item.quantity);
  }

  // Private method to save cart
  Future<void> _saveCart(List<CartItem> cartItems) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartData = jsonEncode(
        cartItems.map((item) => item.toJson()).toList(),
      );
      await prefs.setString(_cartKey, cartData);
    } catch (e) {
      print('Error saving cart: $e');
      throw Exception('Failed to save cart');
    }
  }
}
