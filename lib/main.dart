import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/routes_viewmodel.dart';
import 'services/api_service.dart';
import 'views/routes_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Подключаем ViewModel для управления состоянием
        ChangeNotifierProvider(
          create: (_) => RoutesViewModel(apiService: ApiService()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Routes App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Roboto', // Если хочешь кастомный шрифт
        ),
        home: RoutesPage(), // Запуск главного экрана
      ),
    );
  }
}
