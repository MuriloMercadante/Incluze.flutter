import 'package:flutter/material.dart';

/// Indicador de carregamento com mensagem.
class CarregandoWidget extends StatelessWidget {
  final String mensagem;

  const CarregandoWidget({super.key, this.mensagem = 'Carregando...'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(mensagem),
        ],
      ),
    );
  }
}
