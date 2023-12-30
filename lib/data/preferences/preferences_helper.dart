import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  final Future<SharedPreferences> sharedPreferences;
  final String id;

  PreferencesHelper({required this.sharedPreferences, required this.id}) {
    _setPrefsKey();
  }

  static late String dailyRestaurant;

  void _setPrefsKey() {
    dailyRestaurant = 'DAILY_RESTAURANT_$id';
  }

  Future<bool> get isDailyRestaurantActive async {
    final prefs = await sharedPreferences;
    return prefs.getBool(dailyRestaurant) ?? false;
  }

  void setDailyRestaurant(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(dailyRestaurant, value);
  }
}
