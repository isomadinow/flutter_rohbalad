import 'package:flutter/material.dart';

class RouteCard extends StatelessWidget {
  final String routeNumber;
  final String firstStop;
  final String lastStop;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  const RouteCard({
    super.key,
    required this.routeNumber,
    required this.firstStop,
    required this.lastStop,
    required this.isFavorite,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Text(
            routeNumber,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          firstStop,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
        subtitle: Text(
          "Последняя остановка: $lastStop",
          style: const TextStyle(color: Colors.grey, fontSize: 14.0),
        ),
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.star : Icons.star_border,
            color: isFavorite ? Colors.yellow : Colors.grey,
          ),
          onPressed: onFavoriteTap,
        ),
      ),
    );
  }
}
