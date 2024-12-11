import 'package:ReviewPal/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/resources/routes/routes.dart';
import 'core/resources/app_themes/themes.dart';
import 'features/injection.dart';

class AsgRevApp extends StatefulWidget {
  const AsgRevApp({super.key});

  @override
  State<AsgRevApp> createState() => _AsgRevAppState();
}

class _AsgRevAppState extends State<AsgRevApp> {
  @override
  void initState() {
    super.initState();
        
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider<AuthBloc>(create: (context) => sl<AuthBloc>())],
      child: MaterialApp.router(
        theme: appThemeData.values.toList()[1],
        routerConfig: CustomNavigationHelper.router,
      ),
    );
  }
}