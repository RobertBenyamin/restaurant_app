import 'package:mockito/mockito.dart';
import 'api_services_test.mocks.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/data/api/api_services.dart';
import 'package:restaurant_app/data/model/list_restaurant.dart';
import 'package:restaurant_app/data/model/detail_restaurant.dart';
import 'package:restaurant_app/data/model/search_restaurant.dart';

@GenerateMocks([http.Client])
void main() {
  group('ApiServices', () {
    late ApiServices apiServices;
    late MockClient client;

    setUp(() {
      apiServices = ApiServices();
      client = MockClient();
    });

    group('getRestaurantList', () {
      test('should return a list of restaurants', () async {
        // Arrange
        const expectedResponse =
            '{"error": false, "message": "success", "count": 20, "restaurants": []}';

        when(client.get(Uri.parse('${ApiServices.baseUrl}list')))
            .thenAnswer((_) async => http.Response(expectedResponse, 200));

        // Act
        final result = await apiServices.getRestaurantList(client);

        // Assert
        expect(result, isA<RestaurantList>());
      });

      test('should throw an exception if the request fails', () async {
        // Arrange
        when(client.get(Uri.parse('${ApiServices.baseUrl}list')))
            .thenAnswer((_) async => http.Response('Not Found', 404));

        // Act
        final call = apiServices.getRestaurantList(client);

        // Assert
        expect(call, throwsException);
      });
    });

    group('getRestaurantDetail', () {
      test('should return the restaurant detail', () async {
        // Arrange
        const expectedResponse =
            '{"error": false, "message": "success", "restaurant": {"id": "123", "name": "mock", "description": "mock", "city": "mock", "address": "mock", "pictureId": "1", "categories": [], "menus": {"foods": [], "drinks": []}, "rating": 5.0, "customerReviews": []}}';
        const id = '123';
        when(client.get(Uri.parse('${ApiServices.baseUrl}detail/$id')))
            .thenAnswer((_) async => http.Response(expectedResponse, 200));

        // Act
        final result = await apiServices.getRestaurantDetail(client, id);

        // Assert
        expect(result, isA<RestaurantDetail>());
      });

      test('should throw an exception if the request fails', () async {
        // Arrange
        const id = '123';
        when(client.get(Uri.parse('${ApiServices.baseUrl}detail/$id')))
            .thenAnswer((_) async => http.Response('Not Found', 404));

        // Act
        final call = apiServices.getRestaurantDetail(client, id);

        // Assert
        expect(call, throwsException);
      });
    });

    group('getRestaurantSearch', () {
      test('should return the search results', () async {
        // Arrange
        const expectedResponse =
            '{"error": false, "founded": 1, "restaurants": []}';
        const query = 'melting';
        when(client.get(Uri.parse('${ApiServices.baseUrl}search?q=$query')))
            .thenAnswer((_) async => http.Response(expectedResponse, 200));

        // Act
        final result = await apiServices.getRestaurantSearch(client, query);

        // Assert
        expect(result, isA<RestaurantSearch>());
      });

      test('should throw an exception if the request fails', () async {
        // Arrange
        const query = 'pizza';
        when(client.get(Uri.parse('${ApiServices.baseUrl}search?q=$query')))
            .thenAnswer((_) async => http.Response('Not Found', 404));

        // Act
        final call = apiServices.getRestaurantSearch(client, query);

        // Assert
        expect(call, throwsException);
      });
    });
  });
}
