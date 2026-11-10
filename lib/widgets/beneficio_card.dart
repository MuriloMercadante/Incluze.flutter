import 'package:flutter/material.dart';

import '../models/gamificacao.dart';

/// Card de benefício do comércio parceiro com botão de resgate.
class BeneficioCard extends StatelessWidget {
  final Beneficio beneficio;
  final bool disponivel;
  final VoidCallback onResgatar;

  const BeneficioCard({
    super.key,
    required this.beneficio,
    required this.disponivel,
    required this.onResgatar,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: tema.colorScheme.secondaryContainer,
              child: Icon(beneficio.icone, color: tema.colorScheme.secondary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    beneficio.titulo,
                    style: tema.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(beneficio.parceiro, style: tema.textTheme.bodySmall),
                  Text(
                    '${beneficio.custo} pontos',
                    style: TextStyle(color: tema.colorScheme.primary),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: disponivel ? onResgatar : null,
              child: const Text('Resgatar'),
            ),
          ],
        ),
      ),
    );
  }
}
