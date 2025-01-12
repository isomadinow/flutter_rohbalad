import 'package:flutter/material.dart';

/// Абстрактный класс `BaseViewModel`, обеспечивающий базовую функциональность для моделей представления.
abstract class BaseViewModel extends ChangeNotifier {
  /// Приватное поле для хранения состояния загрузки.
  bool _isLoading = false;

  /// Геттер для получения текущего состояния загрузки.
  bool get isLoading => _isLoading;

  /// Метод для установки состояния загрузки.
  /// 
  /// - [value] — `true`, если данные загружаются; `false`, если загрузка завершена.
  /// При изменении состояния уведомляет слушателей через `notifyListeners`.
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners(); // Уведомляем подписчиков об изменении состояния.
  }
}
