import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../product_grid.dart';

class LatestArrivalsSection extends StatelessWidget {
  final List<Product> products;

  const LatestArrivalsSection({
    Key? key,
    required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
    );
  }
}
