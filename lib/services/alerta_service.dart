import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../data/alertas_exemplo.dart';
import '../models/alerta.dart';
import '../utils/app_constants.dart';
import 'gamificacao_service.dart';

/// Gerencia os alertas temporários de barreiras.
class AlertaService {
  final GamificacaoService _gamificacaoService = GamificacaoService();

  /// Lista os alertas do mais recente para o mais antigo.
  ///
  /// Na primeira execução (chave ainda inexistente), salva os alertas de
  /// exemplo. Se o usuário excluir todos depois, eles não voltam.
  Future<List<Alerta>> listar() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(AppConstants.chaveAlertas)) {
      await _salvar(AlertasExemplo.gerar(DateTime.now()));
    }
    final dados = prefs.getStringList(AppConstants.chaveAlertas) ?? [];
    final alertas = dados
        .map((item) => Alerta.fromJson(jsonDecode(item)))
        .toList();
    alertas.sort((a, b) => b.data.compareTo(a.data));
    return alertas;
  }

  Future<List<Alerta>> listarAtivosPorLocal(int localId) async {
    final alertas = await listar();
    return alertas
        .where((alerta) => alerta.localId == localId && !alerta.resolvido)
        .toList();
  }

  /// Aplica o filtro de exibição da tela de alertas.
  List<Alerta> filtrar(
    List<Alerta> alertas, {
    required bool mostrarResolvidos,
  }) {
    if (mostrarResolvidos) return alertas;
    return alertas.where((alerta) => !alerta.resolvido).toList();
  }

  /// Retorna a mensagem de erro ou `null` se os dados forem válidos.
  String? validar({
    required String? tipo,
    required String localNome,
    required String descricao,
  }) {
    if (tipo == null) return 'Selecione o tipo de barreira.';
    if (localNome.trim().isEmpty) return 'Informe o local da barreira.';
    if (descricao.trim().length < 10) {
      return 'Descreva a barreira com pelo menos 10 caracteres.';
    }
    return null;
  }

  /// Cria um novo alerta e retorna os pontos ganhos.
  Future<int> adicionar({
    required String tipo,
    required String localNome,
    required String descricao,
    int? localId,
  }) async {
    final alertas = await listar();
    alertas.add(
      Alerta(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        tipo: tipo,
        descricao: descricao.trim(),
        localNome: localNome.trim(),
        localId: localId,
        data: DateTime.now(),
      ),
    );
    await _salvar(alertas);

    await _gamificacaoService.adicionarPontos(AppConstants.pontosPorAlerta);
    return AppConstants.pontosPorAlerta;
  }

  Future<void> alternarResolvido(String id) async {
    final alertas = await listar();
    final atualizados = alertas
        .map((a) => a.id == id ? a.copyWith(resolvido: !a.resolvido) : a)
        .toList();
    await _salvar(atualizados);
  }

  Future<void> remover(String id) async {
    final alertas = await listar();
    alertas.removeWhere((a) => a.id == id);
    await _salvar(alertas);
  }

  Future<void> _salvar(List<Alerta> alertas) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      AppConstants.chaveAlertas,
      alertas.map((a) => jsonEncode(a.toJson())).toList(),
    );
  }
}
