import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;
  final bool useMockData;

  ApiService({required this.baseUrl, this.useMockData = false});

  Future<List<T>> fetchData<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      if (useMockData) {
        return _fetchMockData<T>(endpoint, fromJson); // Заглушки
      }
      return _fetchApiData<T>(endpoint, fromJson); // API
    } catch (e) {
      log('Ошибка загрузки данных ($endpoint): $e');
      // Если API недоступно, fallback на заглушки
      return _fetchMockData<T>(endpoint, fromJson);
    }
  }

  Future<List<T>> _fetchApiData<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => fromJson(item)).toList();
    } else {
      throw Exception('Ошибка API: ${response.statusCode}');
    }
  }

 Future<List<T>> _fetchMockData<T>(
  String endpoint,
  T Function(Map<String, dynamic>) fromJson,
) async {
  final mockPaths = {
    'routes': 'assets/static_routes.json',
    'stops': 'assets/static_stops.json',
    'regions': 'assets/static_regions.json',
  };

  final path = mockPaths[endpoint];
  if (path == null) {
    throw Exception('Неизвестный endpoint для заглушек: $endpoint');
  }

  final response = await rootBundle.loadString(path);
  final List<dynamic> data = json.decode(response);
  return data.map((item) => fromJson(item)).toList();
}

}
