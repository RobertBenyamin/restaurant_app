// ignore_for_file: unused_field

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant_app/data/model/detail_restaurant.dart';
import 'package:restaurant_app/data/model/list_restaurant.dart';
import 'package:restaurant_app/data/model/search_restaurant.dart';

class ApiServices {
  static const String baseUrl = 'https://restaurant-api.dicoding.dev/';
  static const String imageUrl = 'https://restaurant-api.dicoding.dev/images/large/';

  Future<RestaurantList> getRestaurantList() async {
    final response = await http.get(Uri.parse('${baseUrl}list'));
    if (response.statusCode == 200) {
      return RestaurantList.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant list');
    }
  }

  Future<RestaurantDetail> getRestaurantDetail(id) async {
    final response = await http.get(Uri.parse('${baseUrl}detail/$id'));
    if (response.statusCode == 200) {
      return RestaurantDetail.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant detail');
    }
  }

  Future<RestaurantSearch> getRestaurantSearch(query) async {
    final response = await http.get(Uri.parse('${baseUrl}search?q=$query'));
    if (response.statusCode == 200) {
      return RestaurantSearch.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant list');
    }
  }
}