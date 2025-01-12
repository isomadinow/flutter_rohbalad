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
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    routeNumber,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  const Icon(
                    Icons.directions_bus,
                    color: Colors.white,
                    size: 16.0,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.radio_button_checked,
                        color: Colors.green,
                        size: 16.0,
                      ),
                      const SizedBox(width: 4.0),
                      Expanded(
                        child: Text(
                          firstStop,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6.0),
                  Row(
                    children: [
                      const Icon(
                        Icons.radio_button_checked,
                        color: Colors.blue,
                        size: 16.0,
                      ),
                      const SizedBox(width: 4.0),
                      Expanded(
                        child: Text(
                          lastStop,
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12.0),
            IconButton(
              icon: Icon(
                isFavorite ? Icons.star : Icons.star_border,
                color: isFavorite ? Colors.yellow : Colors.grey,
              ),
              onPressed: onFavoriteTap,
            ),
          ],
        ),
      ),
    );
  }
}
