import 'package:flutter/material.dart';

class StopCard extends StatelessWidget {
  final String stopName;
  final List<String> routeNumbers;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  const StopCard({
    super.key,
    required this.stopName,
    required this.routeNumbers,
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
        leading: const Icon(Icons.directions_bus, color: Colors.blue),
        title: Text(
          stopName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
        subtitle: Wrap(
          spacing: 6.0,
          children: routeNumbers
              .map((route) => Chip(
                    label: Text(route),
                    backgroundColor: Colors.grey[200],
                  ))
              .toList(),
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
