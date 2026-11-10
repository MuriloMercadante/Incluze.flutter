import 'package:flutter/material.dart';

import '../routes/app_routes.dart';
import '../services/onboarding_service.dart';
import '../utils/app_constants.dart';
import '../utils/app_theme.dart';
import '../widgets/app_logo.dart';

/// Tela inicial: exibe o logo e decide entre Onboarding ou Home.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final OnboardingService _onboardingService = OnboardingService();

  @override
  void initState() {
    super.initState();
    _iniciar();
  }

  Future<void> _iniciar() async {
    await Future.delayed(AppConstants.duracaoSplash);
    final jaVisualizou = await _onboardingService.jaVisualizou();

    if (!mounted) return;
    Navigator.pushReplacementNamed(
      context,
      jaVisualizou ? AppRoutes.home : AppRoutes.onboarding,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: AppTheme.gradientePrincipal),
        child: Center(
          // Animação de entrada (fade + zoom) para o logo ser percebido.
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: AppConstants.duracaoAnimacaoSplash,
            curve: Curves.easeOutBack,
            builder: (context, valor, child) {
              return Opacity(
                opacity: valor.clamp(0.0, 1.0),
                child: Transform.scale(scale: 0.6 + 0.4 * valor, child: child),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 30,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: const AppLogo(tamanho: 130),
                ),
                const SizedBox(height: 28),
                Text(
                  AppConstants.nomeApp,
                  style: tema.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 4,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    AppConstants.slogan,
                    textAlign: TextAlign.center,
                    style: tema.textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const CircularProgressIndicator(color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
