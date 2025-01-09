import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/route.dart';

class ApiService {
  final String baseUrl;

  ApiService({this.baseUrl = "https://api.example.com"});

  Future<List<TransportRoute>> fetchRoutes() async {
    final response = await http.get(Uri.parse('$baseUrl/routes'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => TransportRoute.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load routes');
    }
  }
}
