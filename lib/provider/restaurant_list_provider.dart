import 'dart:io';
import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/api_services.dart';
import 'package:restaurant_app/data/model/list_restaurant.dart';

enum ResultState { loading, noData, hasData, error }

class RestaurantListProvider extends ChangeNotifier {
  final ApiServices apiService;

  RestaurantListProvider({required this.apiService}) {
    _fetchAllRestaurant();
  }

  late RestaurantList _restaurantList;
  late ResultState _state;
  String _message = '';

  String get message => _message;

  RestaurantList get result => _restaurantList;

  ResultState get state => _state;

  Future<dynamic> _fetchAllRestaurant() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurantList = await apiService.getRestaurantList();
      if (restaurantList.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'No Restaurant Found';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _restaurantList = restaurantList;
      }
    } catch (e) {
      if (e is SocketException) {
        _state = ResultState.error;
        notifyListeners();
        return _message = 'No Internet Connection';
      } else {
        _state = ResultState.error;
        notifyListeners();
        return _message = 'Failed to load restaurant list';
      }
    }
  }
}
