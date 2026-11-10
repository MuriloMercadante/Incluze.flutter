import 'package:flutter/material.dart';

import '../screens/alertas_screen.dart';
import '../screens/avaliacao_screen.dart';
import '../screens/favoritos_screen.dart';
import '../screens/home_screen.dart';
import '../screens/local_detalhe_screen.dart';
import '../screens/novo_alerta_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/perfil_screen.dart';
import '../screens/splash_screen.dart';

/// Rotas nomeadas do aplicativo.
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String detalhe = '/detalhe';
  static const String avaliacao = '/avaliacao';
  static const String alertas = '/alertas';
  static const String novoAlerta = '/novo-alerta';
  static const String favoritos = '/favoritos';
  static const String perfil = '/perfil';

  static Map<String, WidgetBuilder> get rotas => {
    splash: (context) => const SplashScreen(),
    onboarding: (context) => const OnboardingScreen(),
    home: (context) => const HomeScreen(),
    detalhe: (context) => const LocalDetalheScreen(),
    avaliacao: (context) => const AvaliacaoScreen(),
    alertas: (context) => const AlertasScreen(),
    novoAlerta: (context) => const NovoAlertaScreen(),
    favoritos: (context) => const FavoritosScreen(),
    perfil: (context) => const PerfilScreen(),
  };
}
