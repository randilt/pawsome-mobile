class Review {
  final String id;
  final int productId;
  final int userId;
  final String userName;
  final int rating;
  final String title;
  final String comment;
  final bool verifiedPurchase;
  final int helpfulVotes;
  final String? imageUrl;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  Review({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.title,
    required this.comment,
    this.verifiedPurchase = false,
    this.helpfulVotes = 0,
    this.imageUrl,
    required this.createdAt,
    this.metadata,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['_id'] ?? json['id'].toString(),
      productId: json['product_id'],
      userId: json['user_id'],
      userName: json['user_name'] ?? 'Anonymous',
      rating: json['rating'],
      title: json['title'],
      comment: json['comment'],
      verifiedPurchase: json['verified_purchase'] ?? false,
      helpfulVotes: json['helpful_votes'] ?? 0,
      imageUrl: json['metadata']?['image_url'],
      createdAt: DateTime.parse(json['created_at']),
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'user_id': userId,
      'user_name': userName,
      'rating': rating,
      'title': title,
      'comment': comment,
      'verified_purchase': verifiedPurchase,
      'helpful_votes': helpfulVotes,
      'metadata': {
        if (imageUrl != null) 'image_url': imageUrl,
        ...?metadata,
      },
    };
  }
}

class ReviewStats {
  final double averageRating;
  final int totalReviews;
  final Map<int, int> ratingDistribution;

  ReviewStats({
    required this.averageRating,
    required this.totalReviews,
    required this.ratingDistribution,
  });

  factory ReviewStats.fromJson(Map<String, dynamic> json) {
    Map<int, int> distribution = {};
    if (json['rating_distribution'] is List) {
      for (var item in json['rating_distribution']) {
        distribution[item['_id']] = item['count'];
      }
    }

    return ReviewStats(
      averageRating: (json['average_rating'] ?? 0.0).toDouble(),
      totalReviews: json['total_reviews'] ?? 0,
      ratingDistribution: distribution,
    );
  }
}
