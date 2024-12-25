// widgets/common/custom_bottom_nav.dart
import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNav({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  void _handleNavigation(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        // navigate to home
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/',
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
      currentIndex: currentIndex,
      onTap: (index) => _handleNavigation(context, index),
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Badge(
            label: const Text('3'),
            child: const Icon(Icons.shopping_cart),
          ),
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
