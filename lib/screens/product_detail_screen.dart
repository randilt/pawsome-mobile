import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/review.dart';
import '../services/cart_service.dart';
import '../services/review_service.dart';
import '../services/favorites_service.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/review/review_card.dart';
import '../widgets/review/rating_summary.dart';
import 'write_review_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product? product;

  const ProductDetailsScreen({
    super.key,
    this.product,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final CartService _cartService = CartService();
  final ReviewService _reviewService = ReviewService();
  final FavoritesService _favoritesService = FavoritesService();

  int quantity = 1;
  bool _isAddingToCart = false;
  bool _isFavorite = false;
  List<Review> _reviews = [];
  ReviewStats? _reviewStats;
  bool _loadingReviews = false;

  @override
  void initState() {
    super.initState();
    _loadReviews();
    _checkFavoriteStatus();
  }

  Future<void> _loadReviews() async {
    if (widget.product == null) return;

    setState(() => _loadingReviews = true);

    try {
      final reviews =
          await _reviewService.getProductReviews(widget.product!.id);
      final stats = await _reviewService.getReviewStats(widget.product!.id);

      setState(() {
        _reviews = reviews;
        _reviewStats = stats;
        _loadingReviews = false;
      });
    } catch (e) {
      setState(() => _loadingReviews = false);
      print('Error loading reviews: $e');
    }
  }

  Future<void> _checkFavoriteStatus() async {
    if (widget.product == null) return;
    final isFavorite = await _favoritesService.isFavorite(widget.product!.id);
    if (mounted) {
      setState(() {
        _isFavorite = isFavorite;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    if (widget.product == null) return;
    try {
      if (_isFavorite) {
        await _favoritesService.removeFromFavorites(widget.product!.id);
      } else {
        await _favoritesService.addToFavorites(widget.product!);
      }
      if (mounted) {
        setState(() {
          _isFavorite = !_isFavorite;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating favorite: $e')),
        );
      }
    }
  }

  void _incrementQuantity() {
    if (quantity < (widget.product?.stockQuantity ?? 0)) {
      setState(() {
        quantity++;
      });
    }
  }

  void _decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  Future<void> _addToCart() async {
    if (widget.product == null) return;

    setState(() => _isAddingToCart = true);

    try {
      await _cartService.addToCart(widget.product!, quantity: quantity);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.product!.name} added to cart!'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'View Cart',
              textColor: Colors.white,
              onPressed: () {
                Navigator.pushNamed(context, '/cart');
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding to cart: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isAddingToCart = false);
    }
  }

  Future<void> _navigateToWriteReview() async {
    if (widget.product == null) return;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WriteReviewScreen(product: widget.product!),
      ),
    );

    // Reload reviews if a new review was submitted
    if (result == true) {
      _loadReviews();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProductImage(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProductInfo(),
                    const SizedBox(height: 24),
                    _buildQuantityAndAddToCart(),
                    const SizedBox(height: 24),
                    _buildProductDescription(),
                    const SizedBox(height: 24),
                    _buildReviewsSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
    );
  }

  Widget _buildProductImage() {
    return Stack(
      children: [
        Image.network(
          widget.product?.imageUrl ?? '',
          width: double.infinity,
          height: 300,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: double.infinity,
              height: 300,
              color: Colors.grey[300],
              child: const Icon(
                Icons.image,
                size: 64,
                color: Colors.grey,
              ),
            );
          },
        ),
        Positioned(
          top: 16,
          left: 16,
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(12),
            ),
          ),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: IconButton(
            icon: const Icon(Icons.bookmark_outline),
            onPressed: () {},
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.product?.name ?? '',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                color: _isFavorite ? Colors.red : null,
              ),
              onPressed: _toggleFavorite,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '\$${widget.product?.price.toStringAsFixed(2) ?? '0.00'}',
          style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        if (widget.product?.stockQuantity != null)
          Text(
            'In Stock: ${widget.product!.stockQuantity}',
            style: TextStyle(
              fontSize: 14,
              color:
                  widget.product!.stockQuantity > 0 ? Colors.green : Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
        const SizedBox(height: 16),
        Text(
          widget.product?.description ?? '',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityAndAddToCart() {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: _decrementQuantity,
              ),
              Text(
                quantity.toString(),
                style: const TextStyle(fontSize: 18),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _incrementQuantity,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: widget.product?.stockQuantity == 0 || _isAddingToCart
                ? null
                : _addToCart,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _isAddingToCart
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text('Adding...'),
                    ],
                  )
                : Text(
                    widget.product?.stockQuantity == 0
                        ? 'Out of Stock'
                        : 'Add to Cart',
                    style: const TextStyle(fontSize: 16),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductDescription() {
    if (widget.product?.longDescription == null) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.product!.longDescription!,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Rating Summary
        if (_reviewStats != null) RatingSummary(stats: _reviewStats!),

        // Write Review Button
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _navigateToWriteReview,
            icon: const Icon(Icons.edit),
            label: const Text('Write a Review'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),

        // Reviews List Header
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reviews (${_reviews.length})',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_reviews.length > 3)
              TextButton(
                onPressed: () {
                  // TODO: Navigate to all reviews screen
                },
                child: const Text('See All'),
              ),
          ],
        ),

        // Reviews List
        const SizedBox(height: 8),
        if (_loadingReviews)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            ),
          )
        else if (_reviews.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Icon(
                  Icons.rate_review_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No reviews yet',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Be the first to review this product!',
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          )
        else
          Column(
            children: [
              // Show first 3 reviews
              ...(_reviews.take(3).map((review) => ReviewCard(review: review))),

              // Show "Load More" if there are more reviews
              if (_reviews.length > 3)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: OutlinedButton(
                    onPressed: () {
                      // TODO: Show all reviews or load more
                    },
                    child: Text('Show ${_reviews.length - 3} more reviews'),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
