import 'package:flutter/material.dart';

class TabBarSwitcher extends StatelessWidget {
  final String activeTab;
  final void Function(String tab) onTabSelected;

  const TabBarSwitcher({
    super.key,
    required this.activeTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200], // Фон для всей панели вкладок
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _TabButton(
              title: "Маршруты",
              isActive: activeTab == "routes",
              onTap: () => onTabSelected("routes"),
            ),
            _TabButton(
              title: "Остановки",
              isActive: activeTab == "stops",
              onTap: () => onTabSelected("stops"),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 4.0,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Text(
            title,
            style: TextStyle(
              color: isActive ? Colors.black : Colors.grey[700],
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
            ),
          ),
        ),
      ),
    );
  }
}
