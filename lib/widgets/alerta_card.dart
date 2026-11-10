import 'package:flutter/material.dart';

import '../models/alerta.dart';
import '../utils/app_theme.dart';
import '../utils/formatador.dart';

/// Card de alerta temporário. As ações são opcionais.
class AlertaCard extends StatelessWidget {
  final Alerta alerta;
  final VoidCallback? onAlternarResolvido;
  final VoidCallback? onRemover;

  /// Ação ao tocar no card (ex.: abrir o local do alerta).
  final VoidCallback? onTap;

  const AlertaCard({
    super.key,
    required this.alerta,
    this.onAlternarResolvido,
    this.onRemover,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cor = alerta.resolvido ? AppTheme.sucesso : AppTheme.perigo;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: cor.withValues(alpha: 0.15),
                child: Icon(
                  alerta.resolvido ? Icons.check : alerta.tipoAlerta.icone,
                  color: cor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alerta.tipoAlerta.nome,
                      style: tema.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        decoration: alerta.resolvido
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            alerta.localNome,
                            style: TextStyle(color: tema.colorScheme.primary),
                          ),
                        ),
                        if (onTap != null)
                          Icon(
                            Icons.chevron_right,
                            size: 18,
                            color: tema.colorScheme.primary,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(alerta.descricao),
                    const SizedBox(height: 6),
                    Text(
                      alerta.resolvido
                          ? 'Resolvido • ${Formatador.dataHora(alerta.data)}'
                          : 'Ativo • ${Formatador.tempoRelativo(alerta.data)}',
                      style: tema.textTheme.bodySmall?.copyWith(color: cor),
                    ),
                  ],
                ),
              ),
              if (onAlternarResolvido != null)
                IconButton(
                  tooltip: alerta.resolvido
                      ? 'Reabrir alerta'
                      : 'Marcar como resolvido',
                  icon: Icon(
                    alerta.resolvido ? Icons.undo : Icons.task_alt,
                    color: AppTheme.sucesso,
                  ),
                  onPressed: onAlternarResolvido,
                ),
              if (onRemover != null)
                IconButton(
                  tooltip: 'Excluir alerta',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: onRemover,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
