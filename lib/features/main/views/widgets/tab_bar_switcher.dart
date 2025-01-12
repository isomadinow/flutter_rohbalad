import 'package:flutter/material.dart';

/// Виджет `TabBarSwitcher` представляет переключатель вкладок для управления активной вкладкой.
///
/// - [activeTab] — текущая активная вкладка.
/// - [onTabSelected] — коллбэк, вызываемый при выборе вкладки.
class TabBarSwitcher extends StatelessWidget {
  /// Текущая активная вкладка.
  final String activeTab;

  /// Коллбэк, вызываемый при выборе вкладки.
  final void Function(String tab) onTabSelected;

  /// Конструктор для создания виджета `TabBarSwitcher`.
  const TabBarSwitcher({
    super.key,
    required this.activeTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Внешние отступы переключателя.
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200], // Светло-серый фон панели вкладок.
          borderRadius: BorderRadius.circular(20.0), // Скругленные углы панели.
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Равномерное размещение кнопок вкладок.
          children: [
            // Кнопка для вкладки "Маршруты".
            _TabButton(
              title: "Маршруты",
              isActive: activeTab == "routes", // Определяем, активна ли эта вкладка.
              onTap: () => onTabSelected("routes"), // Вызываем коллбэк при выборе.
            ),
            // Кнопка для вкладки "Остановки".
            _TabButton(
              title: "Остановки",
              isActive: activeTab == "stops", // Определяем, активна ли эта вкладка.
              onTap: () => onTabSelected("stops"), // Вызываем коллбэк при выборе.
            ),
          ],
        ),
      ),
    );
  }
}

/// Приватный виджет `_TabButton` представляет отдельную кнопку вкладки.
///
/// - [title] — текст кнопки.
/// - [isActive] — флаг, указывающий, активна ли эта кнопка.
/// - [onTap] — коллбэк, вызываемый при нажатии на кнопку.
class _TabButton extends StatelessWidget {
  /// Текст кнопки.
  final String title;

  /// Флаг, указывающий, активна ли эта кнопка.
  final bool isActive;

  /// Коллбэк, вызываемый при нажатии на кнопку.
  final VoidCallback onTap;

  /// Конструктор для создания кнопки вкладки `_TabButton`.
  const _TabButton({
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      // Растягиваем кнопку на равную ширину с остальными.
      child: GestureDetector(
        onTap: onTap, // Обрабатываем нажатие.
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200), // Анимация при переключении.
          alignment: Alignment.center, // Центрируем текст.
          padding: const EdgeInsets.symmetric(vertical: 10.0), // Внутренние отступы.
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent, // Белый фон для активной вкладки.
            borderRadius: BorderRadius.circular(15.0), // Скругленные углы кнопки.
            boxShadow: isActive
                ? [
                    // Тень для активной вкладки.
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 4.0,
                      offset: const Offset(0, 2), // Смещение тени вниз.
                    ),
                  ]
                : [],
          ),
          child: Text(
            title, // Отображаем текст кнопки.
            style: TextStyle(
              color: isActive ? Colors.black : Colors.grey[700], // Цвет текста в зависимости от состояния.
              fontWeight: FontWeight.w500, // Полужирный текст.
              fontSize: 14.0, // Размер текста.
            ),
          ),
        ),
      ),
    );
  }
}
