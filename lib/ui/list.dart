import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/ui/search.dart';
import 'package:restaurant_app/widgets/search_field.dart';
import 'package:restaurant_app/data/api/api_services.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/widgets/card_restaurant.dart';
import 'package:restaurant_app/provider/list_provider.dart'
    as restaurant_list_provider;
import 'package:restaurant_app/provider/search_provider.dart'
    as restaurant_search_provider;

class RestaurantListPage extends StatefulWidget {
  const RestaurantListPage({Key? key}) : super(key: key);

  @override
  State<RestaurantListPage> createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  late TextEditingController _searchController;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
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
          child: Column(
            children: [
              Row(
                children: [
                  SearchField(
                    searchController: _searchController,
                    searchQuery: (value) {
                      _searchText = value;
                    },
                  ),
                  const SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_searchText.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider(
                              create: (_) => restaurant_search_provider
                                  .RestaurantSearchProvider(
                                      apiService: ApiServices(),
                                      query: _searchText),
                              child: const RestaurantSearchPage(),
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF37465D),
                    ),
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              SizedBox(
                height: MediaQuery.of(context).size.height -
                    78.0 -
                    kToolbarHeight -
                    MediaQuery.of(context).padding.top,
                child:
                    Consumer<restaurant_list_provider.RestaurantListProvider>(
                  builder: (context, state, _) {
                    if (state.state ==
                        restaurant_list_provider.ResultState.loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state.state ==
                        restaurant_list_provider.ResultState.hasData) {
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: state.result.restaurants.length,
                        itemBuilder: (context, index) {
                          Restaurant restaurant =
                              state.result.restaurants[index];
                          return CardRestaurant(restaurant: restaurant);
                        },
                      );
                    } else if (state.state ==
                        restaurant_list_provider.ResultState.noData) {
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
                    } else if (state.state ==
                        restaurant_list_provider.ResultState.error) {
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
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
