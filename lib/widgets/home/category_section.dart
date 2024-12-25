import 'package:flutter/material.dart';
import '../../models/category.dart';
import '../category_slider.dart';

class CategorySection extends StatelessWidget {
  final List<Category> categories;

  const CategorySection({
    Key? key,
    required this.categories,
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
        const SizedBox(
          height: 8,
        ),
        CategorySlider(categories: categories),
      ],
    );
  }
}
