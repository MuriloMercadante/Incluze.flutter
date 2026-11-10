import 'package:flutter/material.dart';

/// Recurso de acessibilidade que um local pode oferecer.
///
/// Inclui recursos de "inclusão invisível" (Libras, Braille, cão-guia e
/// ambientes de baixo estímulo), além dos recursos físicos tradicionais.
class RecursoAcessibilidade {
  final String codigo;
  final String nome;
  final String descricao;
  final IconData icone;

  const RecursoAcessibilidade({
    required this.codigo,
    required this.nome,
    required this.descricao,
    required this.icone,
  });

  static const List<RecursoAcessibilidade> todos = [
    RecursoAcessibilidade(
      codigo: 'cadeirante',
      nome: 'Cadeirante',
      descricao: 'Rampas, portas largas e circulação sem degraus',
      icone: Icons.accessible,
    ),
    RecursoAcessibilidade(
      codigo: 'banheiro_adaptado',
      nome: 'Banheiro adaptado',
      descricao: 'Banheiro com barras de apoio e espaço para cadeira',
      icone: Icons.wc,
    ),
    RecursoAcessibilidade(
      codigo: 'elevador',
      nome: 'Elevador',
      descricao: 'Elevador ou plataforma elevatória funcionando',
      icone: Icons.elevator,
    ),
    RecursoAcessibilidade(
      codigo: 'piso_tatil',
      nome: 'Piso tátil',
      descricao: 'Piso tátil de alerta e direcional',
      icone: Icons.grid_on,
    ),
    RecursoAcessibilidade(
      codigo: 'libras',
      nome: 'Libras',
      descricao: 'Atendimento em Língua Brasileira de Sinais',
      icone: Icons.sign_language,
    ),
    RecursoAcessibilidade(
      codigo: 'braille',
      nome: 'Braille',
      descricao: 'Cardápios, placas ou materiais em Braille',
      icone: Icons.touch_app,
    ),
    RecursoAcessibilidade(
      codigo: 'cao_guia',
      nome: 'Cão-guia',
      descricao: 'Entrada de cão-guia permitida e bem recebida',
      icone: Icons.pets,
    ),
    RecursoAcessibilidade(
      codigo: 'baixo_estimulo',
      nome: 'Baixo estímulo',
      descricao: 'Ambiente ou horário com redução de luz e ruído (TEA)',
      icone: Icons.self_improvement,
    ),
  ];

  static RecursoAcessibilidade? buscarPorCodigo(String codigo) {
    for (final recurso in todos) {
      if (recurso.codigo == codigo) return recurso;
    }
    return null;
  }
}
