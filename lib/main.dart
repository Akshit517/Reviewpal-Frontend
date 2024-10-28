import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import './core/routes/routes.dart';
import './core/themes/themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: darkTheme,
      routerConfig: router,
    );
  }
}