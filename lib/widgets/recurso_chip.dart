import 'package:flutter/material.dart';

import '../models/recurso_acessibilidade.dart';

/// Chip de recurso de acessibilidade.
///
/// Sem [onSelecionado] é apenas informativo; com [onSelecionado] vira um
/// filtro selecionável.
class RecursoChip extends StatelessWidget {
  final RecursoAcessibilidade recurso;
  final bool selecionado;
  final ValueChanged<bool>? onSelecionado;

  const RecursoChip({
    super.key,
    required this.recurso,
    this.selecionado = false,
    this.onSelecionado,
  });

  @override
  Widget build(BuildContext context) {
    final icone = Icon(recurso.icone, size: 18);

    if (onSelecionado == null) {
      return Chip(avatar: icone, label: Text(recurso.nome));
    }

    return FilterChip(
      avatar: icone,
      label: Text(recurso.nome),
      selected: selecionado,
      onSelected: onSelecionado,
    );
  }
}
