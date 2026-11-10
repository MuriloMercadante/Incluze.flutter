import 'package:flutter/material.dart';

/// Bolinhas que indicam a página atual de um PageView.
class IndicadorPaginas extends StatelessWidget {
  final int total;
  final int paginaAtual;

  const IndicadorPaginas({
    super.key,
    required this.total,
    required this.paginaAtual,
  });

  @override
  Widget build(BuildContext context) {
    final cor = Theme.of(context).colorScheme.primary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(total, (indice) {
        final ativa = indice == paginaAtual;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: ativa ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: ativa ? cor : cor.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
