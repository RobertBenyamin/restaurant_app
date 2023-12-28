import 'dart:math';
import 'dart:convert';
import 'package:rxdart/subjects.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant_app/common/navigation.dart';
import 'package:restaurant_app/data/api/api_services.dart';
import 'package:restaurant_app/data/model/detail_restaurant.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  static NotificationHelper? _instance;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');

    var initializationSettingsIOS = const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        final payload = details.payload;
        if (payload != null) {
          // ignore: avoid_print
          print('notification payload: $payload');
        }
        selectNotificationSubject.add(payload ?? 'empty payload');
      },
    );
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var channelId = "1";
    var channelName = "channel_01";
    var channelDescription = "dicoding restaurant app";

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        channelId, channelName,
        channelDescription: channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        styleInformation: const DefaultStyleInformation(true, true));

    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    var restaurantList = await ApiServices().getRestaurantList(http.Client());
    var randomIndex = Random().nextInt(restaurantList.count);
    var restaurantDetail = await ApiServices()
        .getRestaurantDetail(http.Client(), restaurantList.restaurants[randomIndex].id);
    var restaurant = restaurantDetail.restaurant;

    var titleNotification = "<b>Restaurant For You!</b>";
    var titleNews = restaurant.name;

    await flutterLocalNotificationsPlugin.show(
        0, titleNotification, titleNews, platformChannelSpecifics,
        payload: json.encode(restaurantDetail.toJson()));
  }

  void configureSelectNotificationSubject(String route) {
    selectNotificationSubject.stream.listen(
      (String payload) async {
        var restaurant = RestaurantDetail.fromJson(json.decode(payload));
        Navigation.intentWithData(route, restaurant);
      },
    );
  }
}
