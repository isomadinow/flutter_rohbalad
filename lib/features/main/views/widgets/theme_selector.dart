import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/app_viewmodel.dart';

/// Виджет `ThemeSelector` предоставляет переключатель для выбора темы.
/// 
/// - [onThemeSelected] — коллбэк, вызываемый при выборе темы.
class ThemeSelector extends StatelessWidget {
  /// Коллбэк для обработки выбора темы.
  final void Function(bool isDarkTheme) onThemeSelected;

  /// Конструктор для создания виджета `ThemeSelector`.
  const ThemeSelector({super.key, required this.onThemeSelected});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = context.watch<AppViewModel>().isDarkTheme;

    return IconButton(
      icon: Icon(
        isDarkTheme ? Icons.nights_stay : Icons.wb_sunny, // Иконка для переключения темы.
        color: isDarkTheme ? Colors.yellow : Colors.yellow, // Цвет иконки в зависимости от темы.
      ),
      onPressed: () {
        onThemeSelected(!isDarkTheme); // Переключаем тему.
      },
    );
  }
}
