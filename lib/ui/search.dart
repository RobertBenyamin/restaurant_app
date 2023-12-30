import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/utils/result_state.dart';
import 'package:restaurant_app/widgets/error_page.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/widgets/card_restaurant.dart';
import 'package:restaurant_app/provider/search_provider.dart';

class RestaurantSearchPage extends StatelessWidget {
  const RestaurantSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant App'),
        backgroundColor: const Color(0xFFF5F2ED),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<RestaurantSearchProvider>(
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
              return ErrorPage(message: state.message);
            } else if (state.state == ResultState.error) {
              return ErrorPage(message: state.message);
            } else {
              return const ErrorPage(message: 'Unknown error');
            }
          },
        ),
      ),
    );
  }
}
