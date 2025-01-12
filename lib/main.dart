import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/api_service.dart';
import 'features/main/viewmodels/app_viewmodel.dart';
import 'features/main/views/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppViewModel(
            apiService: ApiService(
              baseUrl: "https://api.example.com", // Реальный или мок-URL
              useMockData: true, // Используйте `false` для реальных данных
            ),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Рох балад',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MainPage(), // Главный экран
      ),
    );
  }
}
