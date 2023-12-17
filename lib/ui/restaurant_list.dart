import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/widgets/card_restaurant.dart';

class RestaurantListPage extends StatefulWidget {
  const RestaurantListPage({Key? key}) : super(key: key);

  @override
  RestaurantListPageState createState() => RestaurantListPageState();
}

class RestaurantListPageState extends State<RestaurantListPage> {
  List<RestaurantElement> _restaurants = [];
  List<RestaurantElement> _filteredRestaurants = [];
  late TextEditingController _searchController;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _loadRestaurantData();
  }

  Future<void> _loadRestaurantData() async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/local_restaurant.json');
      Restaurant restaurants = restaurantFromJson(jsonString);
      setState(() {
        _restaurants = restaurants.restaurants;
        _filteredRestaurants = _restaurants;
      });
    } catch (e) {
      setState(() {
        isError = true;
      });
    }
  }

  void _searchRestaurants(String query) {
    List<RestaurantElement> filteredList = _restaurants
        .where((restaurant) =>
            restaurant.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      _filteredRestaurants = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double maxSizedBoxHeight = screenHeight -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top;

    if (isError) {
      return errorPage();
    }

    return restaurantList(maxSizedBoxHeight);
  }

  Scaffold restaurantList(double maxSizedBoxHeight) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant App'),
        backgroundColor: const Color(0xFFF5F2ED),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                height: 40.0,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search',
                    labelStyle: const TextStyle(
                      color: Color(0xFF37465D),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF000000).withOpacity(0.07),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    _searchRestaurants(value!);
                  },
                ),
              ),
              const SizedBox(height: 8.0),
              SizedBox(
                height: maxSizedBoxHeight,
                child: _filteredRestaurants.isEmpty
                    ? const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Restaurant Not Found!',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFFFC726F),
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredRestaurants.length,
                        itemBuilder: (context, index) {
                          RestaurantElement restaurant =
                              _filteredRestaurants[index];
                          return CardRestaurant(restaurant: restaurant);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Scaffold errorPage() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant App'),
        backgroundColor: const Color(0xFFF5F2ED),
      ),
      body: const Center(
        child: Text(
          'Failed to load restaurant data',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: Color(0xFFFC726F),
          ),
        ),
      ),
    );
  }
}
