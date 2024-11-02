import 'package:flutter/material.dart';

import 'core/resources/routes/routes.dart';
import 'core/resources/app_themes/themes.dart';

class AsgRevApp extends StatelessWidget {
  const AsgRevApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: appThemeData.values.toList()[1],
      routerConfig: CustomNavigationHelper.router,
    );
  }
}