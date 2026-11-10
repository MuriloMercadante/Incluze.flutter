import 'package:flutter/material.dart';

/// Linha com ícone + texto, usada para endereço, categoria etc.
class InfoLinha extends StatelessWidget {
  final IconData icone;
  final String texto;
  final Color? cor;

  const InfoLinha({
    super.key,
    required this.icone,
    required this.texto,
    this.cor,
  });

  @override
  Widget build(BuildContext context) {
    final corFinal = cor ?? Theme.of(context).colorScheme.onSurfaceVariant;

    return Row(
      children: [
        Icon(icone, size: 18, color: corFinal),
        const SizedBox(width: 6),
        Expanded(
          child: Text(texto, style: TextStyle(color: corFinal)),
        ),
      ],
    );
  }
}
