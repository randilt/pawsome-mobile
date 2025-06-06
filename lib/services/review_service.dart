import 'dart:convert';
import '../models/review.dart';
import 'base_service.dart';

class ReviewService extends BaseService {
  // Get reviews for a product
  Future<List<Review>> getProductReviews(int productId) async {
    try {
      final response = await get('products/$productId/reviews');

      print('Reviews response status: ${response.statusCode}');
      print('Reviews response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Handle different response structures
        List<dynamic> reviewsJson;
        if (data.containsKey('reviews')) {
          reviewsJson = data['reviews'];
        } else if (data.containsKey('data')) {
          reviewsJson = data['data'];
        } else {
          reviewsJson = [];
        }

        return reviewsJson.map((json) => Review.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to load reviews: Status ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching reviews: $e');
      return [];
    }
  }

  // Get review statistics for a product
  Future<ReviewStats> getReviewStats(int productId) async {
    try {
      final response = await get('products/$productId/review-stats');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return ReviewStats.fromJson(data);
      } else {
        // Return default stats if API fails
        return ReviewStats(
          averageRating: 0.0,
          totalReviews: 0,
          ratingDistribution: {},
        );
      }
    } catch (e) {
      print('Error fetching review stats: $e');
      return ReviewStats(
        averageRating: 0.0,
        totalReviews: 0,
        ratingDistribution: {},
      );
    }
  }

  // Submit a new review
  Future<bool> submitReview({
    required int productId,
    required int rating,
    required String title,
    required String comment,
    String? imageUrl,
  }) async {
    try {
      final reviewData = {
        'rating': rating,
        'title': title,
        'comment': comment,
        'image_url': imageUrl,
      };

      print('Submitting review: ${jsonEncode(reviewData)}');

      final response =
          await post('products/$productId/reviews', body: reviewData);

      print('Submit review response status: ${response.statusCode}');
      print('Submit review response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['success'] == true;
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to submit review');
      }
    } catch (e) {
      print('Error submitting review: $e');
      throw Exception('Error submitting review: $e');
    }
  }
}
