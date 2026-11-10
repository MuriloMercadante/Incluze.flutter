import 'package:flutter/material.dart';

import '../utils/app_constants.dart';
import '../utils/app_theme.dart';
import 'app_logo.dart';

/// Banner de boas-vindas exibido no estado inicial da Home,
/// antes de os locais serem buscados na API.
class BoasVindasBanner extends StatelessWidget {
  final VoidCallback onBuscar;

  const BoasVindasBanner({super.key, required this.onBuscar});

  static const List<(IconData, String)> _destaques = [
    (Icons.groups_outlined, 'Avaliado pela comunidade'),
    (Icons.campaign_outlined, 'Alertas em tempo real'),
    (Icons.verified_outlined, 'Selos verificados'),
  ];

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
            decoration: BoxDecoration(
              gradient: AppTheme.gradientePrincipal,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaria.withValues(alpha: 0.25),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const AppLogo(tamanho: 72),
                ),
                const SizedBox(height: 20),
                Text(
                  'Encontre lugares acessíveis de verdade',
                  textAlign: TextAlign.center,
                  style: tema.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'No ${AppConstants.nomeApp}, quem vive as barreiras no dia a '
                  'dia avalia cada local. Sem selos de fachada.',
                  textAlign: TextAlign.center,
                  style: tema.textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onBuscar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.primaria,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    icon: const Icon(Icons.search),
                    label: const Text('Buscar locais'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: _destaques
                .map(
                  (destaque) => Chip(
                    avatar: Icon(
                      destaque.$1,
                      size: 18,
                      color: AppTheme.primaria,
                    ),
                    label: Text(destaque.$2),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
