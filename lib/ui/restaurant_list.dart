import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restaurant_app/data/model/restaurant.dart';

class RestaurantListPage extends StatefulWidget {
  const RestaurantListPage({Key? key}) : super(key: key);

  @override
  RestaurantListPageState createState() => RestaurantListPageState();
}

class RestaurantListPageState extends State<RestaurantListPage> {
  List<RestaurantElement> _restaurants = [];

  @override
  void initState() {
    super.initState();
    _loadRestaurantData();
  }

  Future<void> _loadRestaurantData() async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/local_restaurant.json');
      Restaurant restaurants = restaurantFromJson(jsonString);
      setState(() {
        _restaurants = restaurants.restaurants;
      });
    } catch (e) {
      debugPrint('Failed to load restaurant data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double maxSizedBoxHeight = screenHeight - AppBar().preferredSize.height - MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant App'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                height: maxSizedBoxHeight,
                child: ListView.builder(
                  itemCount: _restaurants.length,
                  itemBuilder: (context, index) {
                    RestaurantElement restaurant = _restaurants[index];
                    return InkWell(
                      child: Card(
                        elevation: 2,
                        color: Colors.white,
                        child: Row(
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
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    restaurant.name,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(restaurant.city),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(restaurant.rating.toString()),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
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