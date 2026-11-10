import 'package:flutter/material.dart';

/// Conteúdo de uma página da introdução (onboarding).
class OnboardingItem {
  final IconData icone;
  final String titulo;
  final String descricao;

  const OnboardingItem({
    required this.icone,
    required this.titulo,
    required this.descricao,
  });

  static const List<OnboardingItem> paginas = [
    OnboardingItem(
      icone: Icons.travel_explore,
      titulo: 'A cidade real, mapeada por você',
      descricao:
          'Selos de acessibilidade são autodeclarados e muitas vezes irreais. '
          'Aqui, quem vive as barreiras no dia a dia avalia cada local.',
    ),
    OnboardingItem(
      icone: Icons.sign_language,
      titulo: 'Inclusão também é invisível',
      descricao:
          'Vá além das rampas: encontre locais com atendimento em Libras, '
          'Braille, aceitação de cão-guia e ambientes de baixo estímulo.',
    ),
    OnboardingItem(
      icone: Icons.campaign,
      titulo: 'Alertas em tempo real',
      descricao:
          'Elevador quebrado? Obra bloqueando a calçada tátil? '
          'Reporte barreiras temporárias e avise toda a comunidade.',
    ),
    OnboardingItem(
      icone: Icons.emoji_events,
      titulo: 'Colabore e ganhe pontos',
      descricao:
          'Cada avaliação e alerta vale pontos que podem ser trocados por '
          'benefícios no comércio local parceiro.',
    ),
  ];
}
