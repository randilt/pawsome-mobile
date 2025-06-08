import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/favorites_service.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/product_grid.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoritesService _favoritesService = FavoritesService();
  List<Product> _favorites = [];
  bool _isLoading = true;
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isOnline = connectivityResult != ConnectivityResult.none;
    });

    // Listen for connectivity changes
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _isOnline = result != ConnectivityResult.none;
      });
    });
  }

  Future<void> _loadFavorites() async {
    try {
      setState(() => _isLoading = true);
      final favorites = await _favoritesService.getFavorites();
      setState(() {
        _favorites = favorites;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading favorites: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
      ),
      body: !_isOnline
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.wifi_off,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'You are offline',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your favorites are still available offline',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _favorites.isEmpty
                  ? _buildEmptyFavorites()
                  : ProductGrid(products: _favorites),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 3),
    );
  }

  Widget _buildEmptyFavorites() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No favorites yet',
            style: TextStyle(
              fontSize: 24,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add products to your favorites to see them here',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
            child: const Text('Browse Products'),
          ),
        ],
      ),
    );
  }
}
