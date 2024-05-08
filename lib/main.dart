import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_gallery/app/constants/app_constants.dart';
import 'package:web_gallery/app/di/di.dart';
import 'package:web_gallery/screens/home/home_screen.dart';

import 'app/constants/app_strings.dart';

void main() {
  initAppModule();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
    return MaterialApp(
      title: AppString.title,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,

      ),
      home: const HomeScreen(),
    );
  }
}

