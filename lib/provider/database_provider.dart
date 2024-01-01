import 'package:flutter/foundation.dart';
import 'package:restaurant_app/data/db/database_helper.dart';
import 'package:restaurant_app/data/model/restaurant.dart' as rs;
import 'package:restaurant_app/data/model/detail_restaurant.dart' as rd;
import 'package:restaurant_app/utils/result_state.dart';

class DatabaseProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  DatabaseProvider({required this.databaseHelper}) {
    getFavorites();
  }

  late ResultState _state;
  ResultState get state => _state;

  String _message = '';
  String get message => _message;

  List<rs.Restaurant> _favorites = [];
  List<rs.Restaurant> get favorites => _favorites;

  void getFavorites() async {
    _state = ResultState.loading;
    notifyListeners();
    _favorites = await databaseHelper.getFavorites();
    if (_favorites.isNotEmpty) {
      _state = ResultState.hasData;
    } else {
      _state = ResultState.noData;
      _message = 'You don\'t have any favorite restaurant!';
    }
    notifyListeners();
  }

  void addFavorite(rd.Restaurant restaurant) async {
    try {
      await databaseHelper.insertFavorite(restaurant);
      getFavorites();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Failed to add favorite';
      notifyListeners();
    }
  }

  Future<bool> isFavorite(String id) async {
    final favoriteRestaurant = await databaseHelper.getFavoriteByID(id);
    return favoriteRestaurant.isNotEmpty;
  }

  void removeFavorite(String id) async {
    try {
      await databaseHelper.removeFavorite(id);
      getFavorites();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Failed to remove favorite';
      notifyListeners();
    }
  }
}
