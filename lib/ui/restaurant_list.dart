import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/model/list_restaurant.dart';
import 'package:restaurant_app/widgets/card_restaurant.dart';
import 'package:restaurant_app/provider/restaurant_list_provider.dart';

class RestaurantListPage extends StatelessWidget {
  const RestaurantListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant App'),
        backgroundColor: const Color(0xFFF5F2ED),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<RestaurantListProvider>(
          builder: (context, state, _) {
            if (state.state == ResultState.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.state == ResultState.hasData) {
              return ListView.builder(
                itemCount: state.result.restaurants.length,
                itemBuilder: (context, index) {
                  Restaurant restaurant = state.result.restaurants[index];
                  return CardRestaurant(restaurant: restaurant);
                },
              );
            } else if (state.state == ResultState.noData) {
              return Center(
                child: Material(
                  child: Text(
                    state.message,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xFFFC726F),
                    ),
                  ),
                ),
              );
            } else if (state.state == ResultState.error) {
              return Center(
                child: Material(
                  child: Text(
                    state.message,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xFFFC726F),
                    ),
                  ),
                ),
              );
            } else {
              return const Center(
                child: Material(
                  child: Text(''),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
