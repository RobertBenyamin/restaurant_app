import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:restaurant_app/widgets/error_page.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restaurant_app/provider/list_provider.dart';
import 'package:restaurant_app/widgets/card_restaurant.dart';

class RestaurantFavoritePage extends StatefulWidget {
  const RestaurantFavoritePage({Key? key}) : super(key: key);

  @override
  State<RestaurantFavoritePage> createState() => _RestaurantFavoritePageState();
}

class _RestaurantFavoritePageState extends State<RestaurantFavoritePage> {
  late List<Restaurant> _restaurants;
  final user = FirebaseAuth.instance.currentUser;

  Future<List<Restaurant>> _filterFavoriteRestaurant(
      List<Restaurant> restaurants) async {
    List<Restaurant> filteredRestaurant = [];
    final prefs = await SharedPreferences.getInstance();
    for (var restaurant in restaurants) {
      String prefsKey = '${user?.email}_${restaurant.id}';
      if (prefs.getBool(prefsKey) != null &&
          prefs.getBool(prefsKey) == true) {
        filteredRestaurant.add(restaurant);
      }
    }
    setState(() {
      _restaurants = filteredRestaurant;
    });
    return _restaurants;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant App'),
        backgroundColor: const Color(0xFFF5F2ED),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height -
                20.0 -
                kToolbarHeight -
                MediaQuery.of(context).padding.top,
            child: Consumer<RestaurantListProvider>(
              builder: (context, state, _) {
                if (state.state == ResultState.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.state == ResultState.hasData) {
                  return favoriteList(state);
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
        ),
      ),
    );
  }

  FutureBuilder<List<Restaurant>> favoriteList(RestaurantListProvider state) {
    return FutureBuilder<List<Restaurant>>(
      future: _filterFavoriteRestaurant(state.result.restaurants),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Material(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFFFC726F),
                ),
              ),
            ),
          );
        } else if (snapshot.hasData) {
          final restaurants = snapshot.data!;
          if (restaurants.isEmpty) {
            return const Text(
              'You don\'t have any favorite restaurant!',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFFFC726F),
              ),
            );
          } else {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                Restaurant restaurant = restaurants[index];
                return CardRestaurant(restaurant: restaurant);
              },
            );
          }
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
