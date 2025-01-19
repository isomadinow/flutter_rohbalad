import 'package:flutter/material.dart';

/// Виджет `StopCard` представляет карточку остановки.
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
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    const Color primaryColor = Colors.green; // Унифицированный основной цвет.
    const Color circleColor = Colors.green; // Цвет для кругов.

    return Card(
      elevation: 5,
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
              decoration: const BoxDecoration(
                color: circleColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.directions_bus,
                color: Colors.white,
                size: 28.0,
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stopName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: isDarkTheme ? Colors.white : Colors.black, // Изменение цвета текста.
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6.0),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: routeNumbers
                          .map(
                            (route) => Container(
                              margin: const EdgeInsets.only(right: 6.0),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 4.0,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                  color: Colors.grey[400]!,
                                ),
                              ),
                              child: Text(
                                route,
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
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
              onPressed: () {
                onFavoriteTap(); // Сохранение состояния избранного.
              },
            ),
          ],
        ),
      ),
    );
  }
}
