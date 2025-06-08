import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../services/order_service.dart';
import '../services/cart_service.dart';
import '../services/auth_service.dart';
import '../services/location_service.dart';
import 'order_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItem> cartItems;

  const CheckoutScreen({
    Key? key,
    required this.cartItems,
  }) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();

  final OrderService _orderService = OrderService();
  final CartService _cartService = CartService();
  final AuthService _authService = AuthService();
  final LocationService _locationService = LocationService();

  bool _isLoading = false;
  bool _isLoadingLocation = false;
  double _total = 0.0;

  @override
  void initState() {
    super.initState();
    _calculateTotal();
    _loadUserData();
  }

  void _calculateTotal() {
    _total = _orderService.calculateTotal(widget.cartItems);
  }

  Future<void> _loadUserData() async {
    try {
      final user = await _authService.getUser();
      if (user != null) {
        setState(() {
          _addressController.text = user.address ?? '';
          _phoneController.text = user.phone ?? '';
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);

    try {
      final addressData = await _locationService.getCurrentAddress();
      if (addressData != null) {
        setState(() {
          _addressController.text = addressData['street'] ?? '';
          _cityController.text = addressData['city'] ?? '';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location retrieved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.contains('Location services are disabled')) {
        _showLocationSettingsDialog();
      } else if (errorMessage.contains('permanently denied')) {
        _showAppSettingsDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Error getting location: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoadingLocation = false);
    }
  }

  void _showLocationSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Services Disabled'),
          content: const Text(
              'Please enable location services in your device settings to use this feature.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _locationService.openLocationSettings();
              },
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  void _showAppSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Permission Required'),
          content: const Text(
              'Location permission is permanently denied. Please enable it in app settings.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _locationService.openAppSettings();
              },
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final shippingAddress =
          '${_addressController.text}, ${_cityController.text}';

      final order = await _orderService.createOrder(
        widget.cartItems,
        shippingAddress,
      );

      if (order != null) {
        // clear cart after successful order
        await _cartService.clearCart();

        // navigate to success screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OrderSuccessScreen(order: order),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error placing order: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOrderSummary(),
                const SizedBox(height: 24),
                _buildShippingForm(),
                const SizedBox(height: 24),
                _buildPaymentInfo(),
                const SizedBox(height: 32),
                _buildPlaceOrderButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            ...widget.cartItems.map((item) => _buildOrderItem(item)),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  'Rs. ${_total.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(CartItem item) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.product.imageUrl ?? '',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 50,
                  height: 50,
                  color: colorScheme.surfaceVariant,
                  child: Icon(Icons.image,
                      size: 24, color: colorScheme.onSurfaceVariant),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Qty: ${item.quantity} × Rs. ${item.product.price}',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Rs. ${item.totalPrice.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingForm() {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Shipping Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: _isLoadingLocation ? null : _getCurrentLocation,
                    icon: _isLoadingLocation
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colorScheme.primary,
                            ),
                          )
                        : Icon(Icons.my_location, color: colorScheme.primary),
                    tooltip: 'Use current location',
                  ),
                ),
              ],
            ),
            if (_isLoadingLocation)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Getting your location...',
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontSize: 12,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Street Address',
                hintText: 'Enter your street address',
                prefixIcon: Icon(Icons.home, color: colorScheme.primary),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your address';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'City',
                hintText: 'Enter your city',
                prefixIcon:
                    Icon(Icons.location_city, color: colorScheme.primary),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your city';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                hintText: 'Enter your phone number',
                prefixIcon: Icon(Icons.phone, color: colorScheme.primary),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: 'Delivery Notes (Optional)',
                hintText: 'Any special instructions for delivery',
                prefixIcon: Icon(Icons.note, color: colorScheme.primary),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentInfo() {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Method',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colorScheme.primary.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  Icon(Icons.payment, color: colorScheme.primary),
                  const SizedBox(width: 12),
                  Text(
                    'Cash on Delivery (COD)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceOrderButton() {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _placeOrder,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: _isLoading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: colorScheme.onPrimary,
                      strokeWidth: 2,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('Placing Order...'),
                ],
              )
            : Text(
                'Place Order - Rs. ${_total.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimary,
                ),
              ),
      ),
    );
  }
}
