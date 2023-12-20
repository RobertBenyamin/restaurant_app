import 'dart:io';
import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/api_services.dart';
import 'package:restaurant_app/data/model/detail_restaurant.dart';

enum ResultState { loading, noData, hasData, error }

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiServices apiService;
  String id;

  RestaurantDetailProvider({required this.apiService, required this.id}) {
    _fetchDetailRestaurant();
  }

  late RestaurantDetail _restaurantDetail;
  late ResultState _state;
  String _message = '';

  String get message => _message;

  RestaurantDetail get result => _restaurantDetail;

  ResultState get state => _state;

  Future<dynamic> _fetchDetailRestaurant() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurantDetail = await apiService.getRestaurantDetail(id);
      if (restaurantDetail.restaurant.name.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Restaurant detail not found';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _restaurantDetail = restaurantDetail;
      }
    } catch (e) {
      if (e is SocketException) {
        _state = ResultState.error;
        notifyListeners();
        return _message = 'No Internet Connection';
      } else {
        _state = ResultState.error;
        notifyListeners();
        return _message = 'Failed to load restaurant detail';
      }
    }
  }
}
