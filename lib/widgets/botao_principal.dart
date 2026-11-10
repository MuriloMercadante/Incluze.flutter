import 'package:flutter/material.dart';

/// Botão de ação principal, ocupando toda a largura.
class BotaoPrincipal extends StatelessWidget {
  final String texto;
  final IconData icone;
  final VoidCallback? onPressed;
  final bool carregando;

  const BotaoPrincipal({
    super.key,
    required this.texto,
    required this.icone,
    required this.onPressed,
    this.carregando = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: carregando ? null : onPressed,
        icon: carregando
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(icone),
        label: Text(texto),
      ),
    );
  }
}
