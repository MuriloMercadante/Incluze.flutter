import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

/// Selo com a nota de acessibilidade, colorido conforme o valor.
class NotaBadge extends StatelessWidget {
  final double nota;

  const NotaBadge({super.key, required this.nota});

  Color get _cor {
    if (nota >= 4) return AppTheme.sucesso;
    if (nota >= 3) return AppTheme.atencao;
    return AppTheme.perigo;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _cor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, size: 16, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            nota.toStringAsFixed(1),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
