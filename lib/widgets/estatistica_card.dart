import 'package:flutter/material.dart';

/// Pequeno card com um número e um rótulo (usado no perfil).
class EstatisticaCard extends StatelessWidget {
  final IconData icone;
  final String valor;
  final String rotulo;

  const EstatisticaCard({
    super.key,
    required this.icone,
    required this.valor,
    required this.rotulo,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Expanded(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            children: [
              Icon(icone, color: tema.colorScheme.primary),
              const SizedBox(height: 8),
              Text(
                valor,
                style: tema.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                rotulo,
                textAlign: TextAlign.center,
                style: tema.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
