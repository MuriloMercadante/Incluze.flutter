import 'package:flutter/material.dart';

/// Imagem de um local carregada da internet, com estados de
/// carregamento e erro.
class LocalImagem extends StatelessWidget {
  final String url;
  final double altura;
  final BorderRadius borderRadius;

  const LocalImagem({
    super.key,
    required this.url,
    this.altura = 160,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  Widget build(BuildContext context) {
    final corFundo = Theme.of(context).colorScheme.surfaceContainerHighest;

    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.network(
        url,
        height: altura,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progresso) {
          if (progresso == null) return child;
          return Container(
            height: altura,
            color: corFundo,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        },
        errorBuilder: (context, erro, stackTrace) {
          return Container(
            height: altura,
            color: corFundo,
            alignment: Alignment.center,
            child: const Icon(Icons.image_not_supported_outlined, size: 48),
          );
        },
      ),
    );
  }
}
