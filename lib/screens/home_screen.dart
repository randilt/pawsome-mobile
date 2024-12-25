import 'package:flutter/material.dart';
import '../widgets/category_slider.dart';
import '../widgets/product_grid.dart';
import '../models/category.dart';
import '../models/product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

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
  ];

  final List<Product> products = [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person_outline, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Hi, Randil',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Browse Categories',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    CategorySlider(categories: categories),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Latest Arrivals',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    ProductGrid(products: products),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
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
      ),
    );
  }
}
