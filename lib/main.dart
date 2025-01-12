import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/api_service.dart';
import 'features/main/viewmodels/app_viewmodel.dart';
import 'features/routes/viewmodels/route_viewmodel.dart';
import 'features/stops/viewmodels/stop_viemodel.dart';
import 'features/regions/viewmodels/region_viewmodel.dart';
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
        Provider<ApiService>(
          create: (_) => ApiService(
            baseUrl: "https://api.example.com",
            useMockData: true,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) {
            final appViewModel = AppViewModel(apiService: context.read<ApiService>());
            appViewModel.initialize();
            return appViewModel;
          },
        ),
        ChangeNotifierProvider(
          create: (context) => RouteViewModel(apiService: context.read<ApiService>()),
        ),
        ChangeNotifierProvider(
          create: (context) => StopViewModel(apiService: context.read<ApiService>()),
        ),
        ChangeNotifierProvider(
          create: (context) => RegionViewModel(apiService: context.read<ApiService>()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Routes App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const MainPage(),
      ),
    );
  }
}
