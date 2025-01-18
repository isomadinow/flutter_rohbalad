import 'package:flutter/material.dart';

/// Виджет `StopCard` представляет карточку остановки с названием, маршрутами и функцией добавления в избранное.
class StopCard extends StatelessWidget {
  /// Название остановки.
  final String stopName;

  /// Список номеров маршрутов, проходящих через остановку.
  final List<String> routeNumbers;

  /// Флаг, указывающий, находится ли остановка в избранном.
  final bool isFavorite;

  /// Коллбэк, вызываемый при нажатии на иконку избранного.
  final VoidCallback onFavoriteTap;

  /// Конструктор для создания виджета `StopCard`.
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
      elevation: 2, // Уровень теней для карточки.
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), // Скругление углов карточки.
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Внешние отступы карточки.
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0), // Внутренние отступы.
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center, // Выравнивание содержимого по вертикали.
          children: [
            // Круглый контейнер с иконкой остановки.
            Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                color: Colors.blue, // Фон контейнера.
                shape: BoxShape.circle, // Форма контейнера — круг.
              ),
              child: const Icon(
                Icons.directions_bus, // Иконка автобуса.
                color: Colors.white,
                size: 28.0,
              ),
            ),
            const SizedBox(width: 12.0), // Отступ между иконкой и текстовой частью.
            // Основной контент карточки.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Выравнивание текста по левому краю.
                children: [
                  // Название остановки.
                  Text(
                    stopName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                    overflow: TextOverflow.ellipsis, // Текст обрезается с многоточием, если не помещается.
                  ),
                  const SizedBox(height: 6.0), // Отступ между названием и списком маршрутов.
                  // Горизонтальный список маршрутов.
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal, // Прокрутка по горизонтали.
                    child: Row(
                      children: routeNumbers
                          .map(
                            (route) => Container(
                              margin: const EdgeInsets.only(right: 6.0), // Отступ между маршрутами.
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, // Горизонтальные отступы внутри контейнера.
                                vertical: 4.0, // Вертикальные отступы внутри контейнера.
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[200], // Фон контейнера маршрута.
                                borderRadius: BorderRadius.circular(8.0), // Скругление углов контейнера.
                                border: Border.all(
                                  color: Colors.grey[400]!, // Цвет границы.
                                ),
                              ),
                              child: Text(
                                route,
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black, // Изменение цвета текста на черный.
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
            const SizedBox(width: 12.0), // Отступ между текстом и иконкой избранного.
            // Иконка избранного с обработкой нажатий.
            IconButton(
              icon: Icon(
                isFavorite ? Icons.star : Icons.star_border, // Иконка избранного.
                color: isFavorite ? Colors.yellow : Colors.grey, // Цвет иконки в зависимости от состояния.
              ),
              onPressed: onFavoriteTap, // Обработка нажатия.
            ),
          ],
        ),
      ),
    );
  }
}
