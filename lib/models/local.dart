import 'recurso_acessibilidade.dart';

/// Local (estabelecimento ou espaço público) mapeado pela comunidade.
///
/// Os dados vêm da API REST e são convertidos com [Local.fromJson].
class Local {
  final int id;
  final String nome;
  final String categoria;
  final String endereco;
  final String bairro;
  final String descricao;
  final String imagemUrl;
  final double nota;
  final int totalAvaliacoes;
  final bool verificado;
  final List<String> recursos;

  const Local({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.endereco,
    required this.bairro,
    required this.descricao,
    required this.imagemUrl,
    required this.nota,
    required this.totalAvaliacoes,
    required this.verificado,
    required this.recursos,
  });

  factory Local.fromJson(Map<String, dynamic> json) {
    return Local(
      id: json['id'] as int,
      nome: json['nome'] as String? ?? '',
      categoria: json['categoria'] as String? ?? '',
      endereco: json['endereco'] as String? ?? '',
      bairro: json['bairro'] as String? ?? '',
      descricao: json['descricao'] as String? ?? '',
      imagemUrl: json['imagem'] as String? ?? '',
      nota: (json['nota'] as num?)?.toDouble() ?? 0,
      totalAvaliacoes: json['avaliacoes'] as int? ?? 0,
      verificado: json['verificado'] as bool? ?? false,
      recursos: List<String>.from(json['recursos'] as List? ?? []),
    );
  }

  bool possuiRecurso(String codigo) => recursos.contains(codigo);

  /// Recursos do local já convertidos para [RecursoAcessibilidade].
  List<RecursoAcessibilidade> get recursosDisponiveis {
    return RecursoAcessibilidade.todos
        .where((recurso) => possuiRecurso(recurso.codigo))
        .toList();
  }
}
