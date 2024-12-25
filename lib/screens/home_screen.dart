import 'package:flutter/material.dart';
import 'package:pet_store_mobile_app/widgets/custom_bottom_nav.dart';
import 'package:pet_store_mobile_app/widgets/home/latest_arrival_section.dart';
import 'package:pet_store_mobile_app/widgets/home/category_section.dart';
import 'package:pet_store_mobile_app/widgets/home/app_bar_section.dart';
import 'package:pet_store_mobile_app/models/category.dart';
import 'package:pet_store_mobile_app/models/product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // int _selectedIndex = 0;

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

  final List<Product> products = [
    Product(
      id: '1',
      name: 'Deluxe Dog Treats for cats',
      price: 1325,
      imageUrl:
          'https://images.unsplash.com/photo-1582798358481-d199fb7347bb?w=500',
    ),
    Product(
      id: '2',
      name: 'Premium Cat Food for dogs',
      price: 635,
      imageUrl:
          'https://images.unsplash.com/photo-1589924691995-400dc9ecc119?w=500',
    ),
    Product(
      id: '3',
      name: 'Tshirt for your cat',
      price: 1325,
      imageUrl:
          'https://lollimeowpet.com/cdn/shop/products/O1CN01idyJsn1SZ7cDnEYzy__1080692260.jpg_400x400_85ec0b9b-072e-41af-abab-dba7d5c1d3ea_400x.jpg?v=1571718188',
    ),
    Product(
      id: '2',
      name: 'Premium Cat Food',
      price: 635,
      imageUrl:
          'https://images.unsplash.com/photo-1589924691995-400dc9ecc119?w=500',
    ),
    Product(
      id: '1',
      name: 'Deluxe Dog Treats',
      price: 1325,
      imageUrl:
          'https://images.unsplash.com/photo-1582798358481-d199fb7347bb?w=500',
    ),
    Product(
      id: '2',
      name: 'Premium Cat Food',
      price: 635,
      imageUrl:
          'https://images.unsplash.com/photo-1589924691995-400dc9ecc119?w=500',
    ),
    Product(
      id: '1',
      name: 'Deluxe Dog Treats',
      price: 1325,
      imageUrl:
          'https://images.unsplash.com/photo-1582798358481-d199fb7347bb?w=500',
    ),
    Product(
      id: '2',
      name: 'Premium Cat Food',
      price: 635,
      imageUrl:
          'https://images.unsplash.com/photo-1589924691995-400dc9ecc119?w=500',
    ),
    Product(
      id: '1',
      name: 'Deluxe Dog Treats',
      price: 1325,
      imageUrl:
          'https://images.unsplash.com/photo-1582798358481-d199fb7347bb?w=500',
    ),
    Product(
      id: '2',
      name: 'Premium Cat Food',
      price: 635,
      imageUrl:
          'https://images.unsplash.com/photo-1589924691995-400dc9ecc119?w=500',
    ),
    Product(
      id: '1',
      name: 'Deluxe Dog Treats',
      price: 1325,
      imageUrl:
          'https://images.unsplash.com/photo-1582798358481-d199fb7347bb?w=500',
    ),
    Product(
      id: '2',
      name: 'Premium Cat Food',
      price: 635,
      imageUrl:
          'https://images.unsplash.com/photo-1589924691995-400dc9ecc119?w=500',
    ),
    Product(
      id: '1',
      name: 'Deluxe Dog Treats',
      price: 1325,
      imageUrl:
          'https://images.unsplash.com/photo-1582798358481-d199fb7347bb?w=500',
    ),
    Product(
      id: '2',
      name: 'Premium Cat Food',
      price: 635,
      imageUrl:
          'https://images.unsplash.com/photo-1589924691995-400dc9ecc119?w=500',
    ),
  ];

  // void _onNavigationIndexChanged(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppBarSection(username: 'Randil'),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CategorySection(categories: categories),
                    const SizedBox(height: 16),
                    LatestArrivalsSection(products: products),
                  ],
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
