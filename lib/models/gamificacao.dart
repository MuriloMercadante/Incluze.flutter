import 'package:flutter/material.dart';

/// Nível do usuário de acordo com os pontos acumulados.
class NivelUsuario {
  final String nome;
  final int pontosMinimos;
  final IconData icone;

  const NivelUsuario({
    required this.nome,
    required this.pontosMinimos,
    required this.icone,
  });

  static const List<NivelUsuario> niveis = [
    NivelUsuario(nome: 'Iniciante', pontosMinimos: 0, icone: Icons.eco),
    NivelUsuario(
      nome: 'Colaborador',
      pontosMinimos: 50,
      icone: Icons.volunteer_activism,
    ),
    NivelUsuario(
      nome: 'Guardião da Inclusão',
      pontosMinimos: 150,
      icone: Icons.shield,
    ),
    NivelUsuario(
      nome: 'Embaixador',
      pontosMinimos: 300,
      icone: Icons.emoji_events,
    ),
  ];
}

/// Benefício do comércio parceiro que pode ser trocado por pontos.
class Beneficio {
  final String titulo;
  final String parceiro;
  final int custo;
  final IconData icone;

  const Beneficio({
    required this.titulo,
    required this.parceiro,
    required this.custo,
    required this.icone,
  });

  static const List<Beneficio> disponiveis = [
    Beneficio(
      titulo: 'Café grátis',
      parceiro: 'Café Encontro Sensorial',
      custo: 30,
      icone: Icons.local_cafe,
    ),
    Beneficio(
      titulo: '10% de desconto',
      parceiro: 'Farmácia Bem Estar 24h',
      custo: 60,
      icone: Icons.local_pharmacy,
    ),
    Beneficio(
      titulo: 'Ingresso de cinema',
      parceiro: 'Cinema Inclusivo Frei Caneca',
      custo: 150,
      icone: Icons.movie,
    ),
    Beneficio(
      titulo: '1 mês de academia',
      parceiro: 'Academia Movimento Livre',
      custo: 300,
      icone: Icons.fitness_center,
    ),
  ];
}
