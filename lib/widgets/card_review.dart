import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/detail_restaurant.dart';

class CardReview extends StatelessWidget {
  const CardReview({
    super.key,
    required this.review,
  });

  final CustomerReview review;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(
            vertical: 8, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                review.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(),
              Text(
                review.review,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                review.date,
                style: const TextStyle(
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
