import '../../routes/models/transport_route.dart';

class Stop {
  final String id;
  final String name;
  final List<TransportRoute> routes;

  Stop({required this.id, required this.name, required this.routes});

  factory Stop.fromJson(Map<String, dynamic> json) {
    return Stop(
      id: json['id'],
      name: json['name'],
      routes: List<TransportRoute>.from(
        json['routes'].map((route) => TransportRoute.fromJson(route)),
      ),
    );
  }
}
