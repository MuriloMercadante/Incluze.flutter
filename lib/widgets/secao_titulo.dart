import 'package:flutter/material.dart';

/// Título de seção com ícone opcional.
class SecaoTitulo extends StatelessWidget {
  final String titulo;
  final IconData? icone;

  const SecaoTitulo({super.key, required this.titulo, this.icone});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Row(
        children: [
          if (icone != null) ...[
            Icon(icone, color: tema.colorScheme.primary),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              titulo,
              style: tema.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
