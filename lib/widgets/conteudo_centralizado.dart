import 'package:flutter/material.dart';

/// Limita a largura do conteúdo e o centraliza.
///
/// No celular não muda nada; em telas largas (web/tablet) evita que
/// textos e cards se estiquem pela tela inteira.
class ConteudoCentralizado extends StatelessWidget {
  final Widget child;
  final double larguraMaxima;
  final AlignmentGeometry alinhamento;

  const ConteudoCentralizado({
    super.key,
    required this.child,
    this.larguraMaxima = 720,
    this.alinhamento = Alignment.topCenter,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alinhamento,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: larguraMaxima),
        child: child,
      ),
    );
  }
}
