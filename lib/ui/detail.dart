import 'review.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:restaurant_app/widgets/error_page.dart';
import 'package:restaurant_app/utils/result_state.dart';
import 'package:restaurant_app/widgets/card_review.dart';
import 'package:restaurant_app/data/api/api_services.dart';
import 'package:restaurant_app/provider/database_provider.dart';
import 'package:restaurant_app/data/model/detail_restaurant.dart';
import 'package:restaurant_app/provider/detail_provider.dart' as rdp;

class RestaurantDetailPage extends StatelessWidget {
  const RestaurantDetailPage({super.key, this.restaurantDetail});

  static const routeName = '/restaurant_detail';

  final RestaurantDetail? restaurantDetail;

  @override
  Widget build(BuildContext context) {
    if (restaurantDetail == null) {
      return Consumer<rdp.RestaurantDetailProvider>(
          builder: (context, state, _) {
        if (state.state == ResultState.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state.state == ResultState.hasData) {
          Restaurant restaurant = state.result.restaurant;
          return DetailPage(restaurant: restaurant);
        } else if (state.state == ResultState.noData) {
          return ErrorPage(message: state.message);
        } else if (state.state == ResultState.error) {
          return ErrorPage(message: state.message);
        } else {
          return const ErrorPage(message: 'Unknown error');
        }
      });
    } else {
      return DetailPage(restaurant: restaurantDetail!.restaurant);
    }
  }
}

class DetailPage extends StatefulWidget {
  const DetailPage({
    super.key,
    required this.restaurant,
  });

  final Restaurant restaurant;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool showAllReviews = false;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(builder: (context, provider, child) {
      return FutureBuilder<bool>(
        future: provider.isFavorite(widget.restaurant.id),
        builder: (context, snapshot) {
          var isFavorite = snapshot.data ?? false;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Restaurant App'),
              backgroundColor: const Color(0xFFF5F2ED),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: isFavorite
                      ? IconButton(
                          icon: const Icon(Icons.favorite),
                          color: Colors.red,
                          onPressed: () =>
                              provider.removeFavorite(widget.restaurant.id),
                        )
                      : IconButton(
                          icon: const Icon(Icons.favorite_border),
                          color: Colors.red,
                          onPressed: () =>
                              provider.addFavorite(widget.restaurant),
                        ),
                ),
              ],
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16.0),
                        bottomRight: Radius.circular(16.0),
                      ),
                      child: Hero(
                        tag: widget.restaurant.id,
                        child: Image.network(
                          ApiServices.imageUrl + widget.restaurant.pictureId,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.restaurant.name,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.red,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                widget.restaurant.city,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.orange,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                widget.restaurant.rating.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Description",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.restaurant.description,
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Foods",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 45,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: widget.restaurant.menus.foods.length,
                                itemBuilder: (context, index) {
                                  Category food =
                                      widget.restaurant.menus.foods[index];
                                  return Card(
                                    color: const Color(0xFF4DC7BF),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        food.name,
                                        style: const TextStyle(
                                          color: Color(0xFF37465D),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Drinks",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 45,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    widget.restaurant.menus.drinks.length,
                                itemBuilder: (context, index) {
                                  Category food =
                                      widget.restaurant.menus.drinks[index];
                                  return Card(
                                    color: const Color(0xFF4CB9E7),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        food.name,
                                        style: const TextStyle(
                                          color: Color(0xFF3B375D),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Reviews",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (widget.restaurant.customerReviews.length > 1)
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      showAllReviews = !showAllReviews;
                                    });
                                  },
                                  child: const Text(
                                    'Show All',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF37465D),
                                    ),
                                  ),
                                )
                            ],
                          ),
                          const SizedBox(height: 8),
                          widget.restaurant.customerReviews.isEmpty
                              ? const Text(
                                  "No reviews available",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: showAllReviews
                                      ? widget.restaurant.customerReviews.length
                                      : 1,
                                  itemBuilder: (context, index) {
                                    CustomerReview review = widget
                                        .restaurant.customerReviews[index];
                                    return CardReview(review: review);
                                  },
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: const Color(0xFF37465D),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReviewPage(id: widget.restaurant.id),
                  ),
                ).then((_) {
                  Provider.of<rdp.RestaurantDetailProvider>(context, listen: false)
                      .fetchDetailRestaurant();
                });
              },
              child: const Icon(
                Icons.rate_review,
                color: Colors.white,
              ),
            ),
          );
        },
      );
    });
  }
}
