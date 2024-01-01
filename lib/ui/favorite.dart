import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:restaurant_app/utils/result_state.dart';
import 'package:restaurant_app/widgets/error_page.dart';
import 'package:restaurant_app/widgets/card_restaurant.dart';
import 'package:restaurant_app/provider/database_provider.dart';

class RestaurantFavoritePage extends StatefulWidget {
  const RestaurantFavoritePage({Key? key}) : super(key: key);

  @override
  State<RestaurantFavoritePage> createState() => _RestaurantFavoritePageState();
}

class _RestaurantFavoritePageState extends State<RestaurantFavoritePage> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant App'),
        backgroundColor: const Color(0xFFF5F2ED),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height -
                20.0 -
                kToolbarHeight -
                MediaQuery.of(context).padding.top,
            child: _buildList(),
          ),
        ),
      ),
    );
  }

  Widget _buildList() {
    return Consumer<DatabaseProvider>(builder: (context, provider, child) {
      if (provider.state == ResultState.hasData) {
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: provider.favorites.length,
          itemBuilder: (context, index) {
            return CardRestaurant(restaurant: provider.favorites[index]);
          },
        );
      } else if (provider.state == ResultState.loading) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return ErrorPage(message: provider.message);
      }
    });
  }
}
