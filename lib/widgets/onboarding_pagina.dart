import 'package:flutter/material.dart';

import '../models/onboarding_item.dart';
import '../utils/app_theme.dart';

/// Conteúdo visual de uma página da introdução.
class OnboardingPagina extends StatelessWidget {
  final OnboardingItem item;

  const OnboardingPagina({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return LayoutBuilder(
      builder: (context, restricoes) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: ConstrainedBox(
            // Centraliza verticalmente quando há espaço sobrando.
            constraints: BoxConstraints(minHeight: restricoes.maxHeight - 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: tema.colorScheme.primaryContainer.withValues(
                      alpha: 0.6,
                    ),
                  ),
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppTheme.gradientePrincipal,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaria.withValues(alpha: 0.3),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(item.icone, size: 76, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  item.titulo,
                  textAlign: TextAlign.center,
                  style: tema.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  item.descricao,
                  textAlign: TextAlign.center,
                  style: tema.textTheme.bodyLarge?.copyWith(
                    color: tema.colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
