import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/avaliacao.dart';
import '../utils/app_constants.dart';
import 'gamificacao_service.dart';

/// Persiste as avaliações feitas pelo usuário e concede pontos.
class AvaliacaoService {
  final GamificacaoService _gamificacaoService = GamificacaoService();

  Future<List<Avaliacao>> listar() async {
    final prefs = await SharedPreferences.getInstance();
    final dados = prefs.getStringList(AppConstants.chaveAvaliacoes) ?? [];
    return dados.map((item) => Avaliacao.fromJson(jsonDecode(item))).toList();
  }

  Future<List<Avaliacao>> listarPorLocal(int localId) async {
    final avaliacoes = await listar();
    return avaliacoes.where((a) => a.localId == localId).toList();
  }

  /// Retorna a mensagem de erro ou `null` se os dados forem válidos.
  String? validar({required int nota}) {
    if (nota < 1 || nota > 5) {
      return 'Selecione uma nota de 1 a 5 estrelas.';
    }
    return null;
  }

  /// Salva a avaliação e retorna os pontos ganhos.
  Future<int> salvar(Avaliacao avaliacao) async {
    final avaliacoes = await listar();
    avaliacoes.add(avaliacao);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      AppConstants.chaveAvaliacoes,
      avaliacoes.map((a) => jsonEncode(a.toJson())).toList(),
    );

    await _gamificacaoService.adicionarPontos(AppConstants.pontosPorAvaliacao);
    return AppConstants.pontosPorAvaliacao;
  }
}
