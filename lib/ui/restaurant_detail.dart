import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/restaurant.dart';

class RestaurantDetailPage extends StatelessWidget {
  final RestaurantElement restaurant;

  const RestaurantDetailPage({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16.0),
                  bottomRight: Radius.circular(16.0),
                ),
                child: Image.network(
                  restaurant.pictureId,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name,
                      style: const TextStyle(
                        fontSize: 32, // Adjust the font size as desired
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
                          restaurant.city,
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
                          restaurant.rating.toString(),
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
                      restaurant.description,
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
                        itemCount: restaurant.menus.foods.length, 
                        itemBuilder: (context, index) {
                          Drink food = restaurant.menus.foods[index];
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(food.name),
                            ),
                          );
                        }
                      ),
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
                        itemCount: restaurant.menus.drinks.length, 
                        itemBuilder: (context, index) {
                          Drink food = restaurant.menus.drinks[index];
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(food.name),
                            ),
                          );
                        }
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
