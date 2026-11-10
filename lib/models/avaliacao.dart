/// Avaliação feita pelo usuário sobre a acessibilidade de um local.
class Avaliacao {
  final int localId;
  final String localNome;
  final int nota;
  final List<String> recursosConfirmados;
  final String comentario;
  final DateTime data;

  const Avaliacao({
    required this.localId,
    required this.localNome,
    required this.nota,
    required this.recursosConfirmados,
    required this.comentario,
    required this.data,
  });

  factory Avaliacao.fromJson(Map<String, dynamic> json) {
    return Avaliacao(
      localId: json['localId'] as int,
      localNome: json['localNome'] as String,
      nota: json['nota'] as int,
      recursosConfirmados: List<String>.from(
        json['recursosConfirmados'] as List,
      ),
      comentario: json['comentario'] as String? ?? '',
      data: DateTime.parse(json['data'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'localId': localId,
      'localNome': localNome,
      'nota': nota,
      'recursosConfirmados': recursosConfirmados,
      'comentario': comentario,
      'data': data.toIso8601String(),
    };
  }
}
