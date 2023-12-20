import 'dart:io';
import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/api_services.dart';
import 'package:restaurant_app/data/model/search_restaurant.dart';

enum ResultState { loading, noData, hasData, error }

class RestaurantSearchProvider extends ChangeNotifier {
  final ApiServices apiService;
  String query;

  RestaurantSearchProvider({required this.apiService, required this.query}) {
    _fetchSearchRestaurant();
  }

  late RestaurantSearch _restaurantSearch;
  late ResultState _state;
  String _message = '';

  String get message => _message;

  RestaurantSearch get result => _restaurantSearch;

  ResultState get state => _state;

  Future<dynamic> _fetchSearchRestaurant() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurantSearch = await apiService.searchRestaurant(query);
      if (restaurantSearch.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Restaurant not found';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _restaurantSearch = restaurantSearch;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      if (e is SocketException) {
        return _message = 'No Internet Connection';
      } else {
        return _message = 'Failed to load restaurant list';
      }
    }
  }
}
