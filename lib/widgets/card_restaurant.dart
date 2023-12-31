import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/db/database_helper.dart';
import 'package:restaurant_app/provider/database_provider.dart';
import 'package:restaurant_app/ui/detail.dart';
import 'package:restaurant_app/data/api/api_services.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/provider/detail_provider.dart';

class CardRestaurant extends StatelessWidget {
  const CardRestaurant({
    super.key,
    required this.restaurant,
  });

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        elevation: 2,
        color: const Color(0xFFF5F2ED),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                  height: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Hero(
                      tag: restaurant.id,
                      child: Image.network(
                        ApiServices.imageUrl + restaurant.pictureId,
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
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 12.0,
                  bottom: 12.0,
                  right: 12.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(restaurant.city),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_border_outlined,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 8),
                        Text(restaurant.rating.toString()),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (_) => RestaurantDetailProvider(
                      apiService: ApiServices(), id: restaurant.id),
                ),
                ChangeNotifierProvider(
                  create: (_) =>
                      DatabaseProvider(databaseHelper: DatabaseHelper()),
                ),
              ],
              child: const RestaurantDetailPage(),
            ),
          ),
        ).then((_) {
          Provider.of<DatabaseProvider>(context, listen: false).getFavorites();
        });
      },
    );
  }
}
