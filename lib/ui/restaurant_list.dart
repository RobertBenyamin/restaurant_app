import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/ui/restaurant_detail.dart';

class RestaurantListPage extends StatefulWidget {
  const RestaurantListPage({Key? key}) : super(key: key);

  @override
  RestaurantListPageState createState() => RestaurantListPageState();
}

class RestaurantListPageState extends State<RestaurantListPage> {
  List<RestaurantElement> _restaurants = [];
  List<RestaurantElement> _filteredRestaurants = [];
  late TextEditingController _searchController;

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
      debugPrint('Failed to load restaurant data: $e');
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
                child: ListView.builder(
                  itemCount: _filteredRestaurants.length,
                  itemBuilder: (context, index) {
                    RestaurantElement restaurant = _filteredRestaurants[index];
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
                                    child: Image.network(
                                      restaurant.pictureId,
                                      fit: BoxFit.cover,
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
                                          color: Colors.yellow,
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
                            builder: (context) => RestaurantDetailPage(
                              restaurant: restaurant,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
