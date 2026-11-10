import 'package:flutter/material.dart';

/// Mensagem centralizada com ícone, título, texto e botão opcional.
///
/// Reutilizada para os estados inicial, vazio e de erro das telas.
class EstadoMensagem extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String mensagem;
  final String? textoBotao;
  final IconData iconeBotao;
  final VoidCallback? onPressed;
  final bool erro;

  const EstadoMensagem({
    super.key,
    required this.icone,
    required this.titulo,
    required this.mensagem,
    this.textoBotao,
    this.iconeBotao = Icons.refresh,
    this.onPressed,
    this.erro = false,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cor = erro ? tema.colorScheme.error : tema.colorScheme.primary;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: cor.withValues(alpha: 0.12),
              child: Icon(icone, size: 48, color: cor),
            ),
            const SizedBox(height: 24),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: tema.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              mensagem,
              textAlign: TextAlign.center,
              style: tema.textTheme.bodyLarge?.copyWith(
                color: tema.colorScheme.onSurfaceVariant,
              ),
            ),
            if (textoBotao != null && onPressed != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onPressed,
                icon: Icon(iconeBotao),
                label: Text(textoBotao!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
