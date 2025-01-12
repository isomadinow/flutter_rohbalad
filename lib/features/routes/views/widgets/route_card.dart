import 'package:flutter/material.dart';
import '../../models/transport_route.dart';

class RouteCard extends StatelessWidget {
  final TransportRoute route;

  const RouteCard({Key? key, required this.route}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('Маршрут: ${route.number}'),
        subtitle: Text('Первая остановка: ${route.stops.first}'),
        trailing: Icon(Icons.arrow_forward),
      ),
    );
  }
}
