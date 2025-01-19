import 'package:flutter/material.dart';

/// Виджет `RegionDropdown` отображает текущий регион в виде текста.
class RegionDropdown extends StatelessWidget {
  /// Название текущего региона.
  final String regionName;

  /// Конструктор для создания виджета `RegionDropdown`.
  const RegionDropdown({super.key, required this.regionName});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        // Иконка местоположения.
        const Icon(
          Icons.location_on,
          color: Colors.white, // Мягкий голубой цвет.
          size: 27.0,
        ),
        const SizedBox(width: 8), // Отступ между иконкой и текстом.
        // Текст с названием региона.
        Text(
          regionName,
          style: TextStyle(
            fontSize: 20,
            color:  Colors.white, // Цвет текста в зависимости от темы.
            fontWeight: FontWeight.w500, // Полужирное начертание.
          ),
        ),
      ],
    );
  }
}
