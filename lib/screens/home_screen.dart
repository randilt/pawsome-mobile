// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:pet_store_mobile_app/widgets/custom_bottom_nav.dart';
import 'package:pet_store_mobile_app/widgets/home/latest_arrival_section.dart';
import 'package:pet_store_mobile_app/widgets/home/category_section.dart';
import 'package:pet_store_mobile_app/widgets/home/app_bar_section.dart';
import 'package:pet_store_mobile_app/models/category.dart';
import 'package:pet_store_mobile_app/models/product.dart';
import 'package:pet_store_mobile_app/services/product_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService _productService = ProductService();
  List<Product> _products = [];
  bool _isLoading = true;
  String? _error;

  final List<Category> categories = [
    Category(
      id: '1',
      name: 'For Dogs',
      imageUrl:
          'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?w=500',
    ),
    Category(
      id: '2',
      name: 'For Cats',
      imageUrl:
          'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=500',
    ),
    Category(
      id: '3',
      name: 'For Birds',
      imageUrl:
          'https://images.unsplash.com/photo-1552728089-57bdde30beb3?w=500',
    ),
    Category(
      id: '4',
      name: 'For Fish',
      imageUrl:
          'https://images.unsplash.com/photo-1524704654690-b56c05c78a00?w=500',
    ),
    Category(
      id: '1',
      name: 'For Dogs',
      imageUrl:
          'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?w=500',
    ),
    Category(
      id: '2',
      name: 'For Cats',
      imageUrl:
          'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=500',
    ),
    Category(
      id: '3',
      name: 'For Birds',
      imageUrl:
          'https://images.unsplash.com/photo-1552728089-57bdde30beb3?w=500',
    ),
    Category(
      id: '4',
      name: 'For Fish',
      imageUrl:
          'https://images.unsplash.com/photo-1524704654690-b56c05c78a00?w=500',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final products = await _productService.getProducts();

      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load products: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppBarSection(username: 'Randil'),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadProducts,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CategorySection(categories: categories),
                      const SizedBox(height: 16),
                      if (_isLoading)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else if (_error != null)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(_error!,
                                    style: TextStyle(color: Colors.red)),
                                ElevatedButton(
                                  onPressed: _loadProducts,
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        LatestArrivalsSection(products: _products),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
    );
  }
}
