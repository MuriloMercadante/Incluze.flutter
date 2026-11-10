import 'package:flutter/material.dart';

/// Tipo de barreira temporária que pode ser reportada.
class TipoAlerta {
  final String codigo;
  final String nome;
  final IconData icone;

  const TipoAlerta({
    required this.codigo,
    required this.nome,
    required this.icone,
  });

  static const List<TipoAlerta> todos = [
    TipoAlerta(
      codigo: 'elevador_quebrado',
      nome: 'Elevador quebrado',
      icone: Icons.elevator,
    ),
    TipoAlerta(
      codigo: 'calcada_obstruida',
      nome: 'Calçada obstruída',
      icone: Icons.block,
    ),
    TipoAlerta(
      codigo: 'obra',
      nome: 'Obra no caminho',
      icone: Icons.construction,
    ),
    TipoAlerta(
      codigo: 'piso_tatil_danificado',
      nome: 'Piso tátil danificado',
      icone: Icons.grid_off,
    ),
    TipoAlerta(
      codigo: 'rampa_bloqueada',
      nome: 'Rampa bloqueada',
      icone: Icons.accessible_forward,
    ),
    TipoAlerta(
      codigo: 'outro',
      nome: 'Outra barreira',
      icone: Icons.report_problem,
    ),
  ];

  static TipoAlerta buscarPorCodigo(String codigo) {
    return todos.firstWhere(
      (tipo) => tipo.codigo == codigo,
      orElse: () => todos.last,
    );
  }
}

/// Alerta temporário de barreira ("Waze da inclusão").
class Alerta {
  final String id;
  final String tipo;
  final String descricao;
  final String localNome;
  final int? localId;
  final DateTime data;
  final bool resolvido;

  const Alerta({
    required this.id,
    required this.tipo,
    required this.descricao,
    required this.localNome,
    required this.data,
    this.localId,
    this.resolvido = false,
  });

  TipoAlerta get tipoAlerta => TipoAlerta.buscarPorCodigo(tipo);

  Alerta copyWith({bool? resolvido}) {
    return Alerta(
      id: id,
      tipo: tipo,
      descricao: descricao,
      localNome: localNome,
      localId: localId,
      data: data,
      resolvido: resolvido ?? this.resolvido,
    );
  }

  factory Alerta.fromJson(Map<String, dynamic> json) {
    return Alerta(
      id: json['id'] as String,
      tipo: json['tipo'] as String,
      descricao: json['descricao'] as String,
      localNome: json['localNome'] as String,
      localId: json['localId'] as int?,
      data: DateTime.parse(json['data'] as String),
      resolvido: json['resolvido'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tipo': tipo,
      'descricao': descricao,
      'localNome': localNome,
      'localId': localId,
      'data': data.toIso8601String(),
      'resolvido': resolvido,
    };
  }
}
