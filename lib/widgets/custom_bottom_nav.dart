// lib/widgets/custom_bottom_nav.dart
import 'package:flutter/material.dart';
import '../services/cart_service.dart';

class CustomBottomNav extends StatefulWidget {
  final int currentIndex;

  const CustomBottomNav({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  final CartService _cartService = CartService();
  int _cartItemCount = 0;

  @override
  void initState() {
    super.initState();
    _loadCartCount();
  }

  Future<void> _loadCartCount() async {
    try {
      final count = await _cartService.getCartItemCount();
      if (mounted) {
        setState(() {
          _cartItemCount = count;
        });
      }
    } catch (e) {
      print('Error loading cart count: $e');
    }
  }

  void _handleNavigation(BuildContext context, int index) {
    if (index == widget.currentIndex) return;

    switch (index) {
      case 0:
        // navigate to home
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
          (route) => false, // clear all previous routes
        );
        break;
      case 1:
        // navigate to cart
        Navigator.pushNamed(context, '/cart');
        break;
      case 2:
        // navigate to profile
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: (index) => _handleNavigation(context, index),
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: _cartItemCount > 0
              ? Badge(
                  label: Text(_cartItemCount.toString()),
                  child: const Icon(Icons.shopping_cart),
                )
              : const Icon(Icons.shopping_cart),
          label: 'My Cart',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'My Profile',
        ),
      ],
    );
  }
}
