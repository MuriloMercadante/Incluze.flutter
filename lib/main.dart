import 'package:flutter/material.dart';

import 'routes/app_routes.dart';
import 'utils/app_constants.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const IncluzeApp());
}

class IncluzeApp extends StatelessWidget {
  const IncluzeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.nomeApp,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.tema,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.rotas,
    );
  }
}
