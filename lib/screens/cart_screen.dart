import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../services/cart_service.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/biometric_auth_button.dart';
import '../services/biometric_service.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService = CartService();
  List<CartItem> _cartItems = [];
  bool _isLoading = true;
  double _total = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    try {
      setState(() => _isLoading = true);

      final cartItems = await _cartService.getCartItems();
      final total = await _cartService.getCartTotal();

      setState(() {
        _cartItems = cartItems;
        _total = total;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading cart: $e')),
      );
    }
  }

  Future<void> _updateQuantity(int productId, int quantity) async {
    try {
      await _cartService.updateQuantity(productId, quantity);
      await _loadCartItems(); // Reload cart
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating quantity: $e')),
      );
    }
  }

  Future<void> _removeItem(int productId) async {
    try {
      await _cartService.removeFromCart(productId);
      await _loadCartItems(); // Reload cart
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item removed from cart')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error removing item: $e')),
      );
    }
  }

  Future<void> _proceedToCheckout() async {
    if (_cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your cart is empty')),
      );
      return;
    }

    final biometricService = BiometricService();

    // First check if the device supports biometrics
    final isDeviceSupported = await biometricService.isDeviceSupported();
    if (!isDeviceSupported) {
      _navigateToCheckout();
      return;
    }

    // Then check if biometrics are available and enrolled
    final isBiometricAvailable = await biometricService.isBiometricAvailable();
    if (!isBiometricAvailable) {
      // Show a dialog explaining why biometrics aren't available
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Biometric Authentication Not Available'),
              content: const Text(
                'No biometric authentication is set up on this device. Would you like to proceed without authentication?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _navigateToCheckout();
                  },
                  child: const Text('Proceed'),
                ),
              ],
            );
          },
        );
      }
      return;
    }

    // If biometrics are available, show the authentication dialog
    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Secure Checkout'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Please authenticate to proceed with checkout',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                BiometricAuthButton(
                  buttonText: 'Authenticate & Continue',
                  onSuccess: () {
                    Navigator.pop(context); // Close dialog
                    _navigateToCheckout();
                  },
                  onFailure: () {
                    Navigator.pop(context); // Close dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Authentication failed. Please try again.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }

  void _navigateToCheckout() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutScreen(cartItems: _cartItems),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          if (_cartItems.isNotEmpty)
            TextButton(
              onPressed: () async {
                await _cartService.clearCart();
                await _loadCartItems();
              },
              child: const Text('Clear All'),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _cartItems.isEmpty
              ? _buildEmptyCart()
              : _buildCartContent(),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 24,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add some items to your cart to get started',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
            child: const Text('Continue Shopping'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _cartItems.length,
            itemBuilder: (context, index) {
              final item = _cartItems[index];
              return _buildCartItem(item);
            },
          ),
        ),
        _buildCartSummary(),
      ],
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.product.imageUrl ?? '',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image, color: Colors.grey),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rs. ${item.product.price}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () => _updateQuantity(
                                item.product.id,
                                item.quantity - 1,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(8),
                                child: Icon(Icons.remove, size: 16),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                item.quantity.toString(),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            InkWell(
                              onTap: () => _updateQuantity(
                                item.product.id,
                                item.quantity + 1,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(8),
                                child: Icon(Icons.add, size: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Rs. ${item.totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => _removeItem(item.product.id),
              icon: const Icon(Icons.delete, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartSummary() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withAlpha(51),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              Text(
                'Rs. ${_total.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.blue[300] : Colors.blue[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _proceedToCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode ? Colors.blue[700] : Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Proceed to Checkout',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
