import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/routes/viewmodels/routes_viewmodel.dart';
import 'core/api_service.dart';
import 'features/routes/views/routes_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RoutesViewModel(apiService: ApiService()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Transport App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: RoutesPage(),
      ),
    );
  }
}
