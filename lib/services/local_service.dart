import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/local.dart';
import '../utils/app_constants.dart';

/// Erro amigável retornado pelo [LocalService] para ser exibido ao usuário.
class LocalServiceException implements Exception {
  final String mensagem;

  LocalServiceException(this.mensagem);

  @override
  String toString() => mensagem;
}

/// Serviço responsável por consumir a API REST de locais e
/// por aplicar as regras de busca e filtro.
class LocalService {
  final http.Client _client;

  LocalService({http.Client? client}) : _client = client ?? http.Client();

  /// GET /locais — retorna a lista de locais mapeados.
  Future<List<Local>> buscarLocais() async {
    try {
      final resposta = await _client
          .get(Uri.parse(AppConstants.urlLocais))
          .timeout(AppConstants.tempoLimiteRequisicao);

      if (resposta.statusCode == 200) {
        final List<dynamic> dados = jsonDecode(utf8.decode(resposta.bodyBytes));
        return dados
            .map((item) => Local.fromJson(item as Map<String, dynamic>))
            .toList();
      }

      if (resposta.statusCode == 404) {
        throw LocalServiceException(
          'Não encontramos a lista de locais no servidor (erro 404).',
        );
      }

      throw LocalServiceException(
        'O servidor respondeu com erro (${resposta.statusCode}). '
        'Tente novamente em alguns instantes.',
      );
    } on LocalServiceException {
      rethrow;
    } on TimeoutException {
      throw LocalServiceException(
        'A conexão demorou demais para responder. Verifique sua internet.',
      );
    } on FormatException {
      throw LocalServiceException(
        'Os dados recebidos estão em um formato inválido.',
      );
    } on TypeError {
      throw LocalServiceException(
        'Os dados recebidos estão em um formato inválido.',
      );
    } catch (_) {
      throw LocalServiceException(
        'Sem conexão com a internet. Verifique sua rede e tente novamente.',
      );
    }
  }

  /// Busca um único local pelo id. Retorna `null` se não existir na API.
  Future<Local?> buscarPorId(int id) async {
    final locais = await buscarLocais();
    for (final local in locais) {
      if (local.id == id) return local;
    }
    return null;
  }

  /// Filtra os locais pelo texto digitado (nome, bairro ou categoria)
  /// e pelos recursos de acessibilidade selecionados.
  List<Local> filtrar(
    List<Local> locais, {
    String busca = '',
    Set<String> recursos = const {},
  }) {
    final termo = busca.trim().toLowerCase();

    return locais.where((local) {
      final correspondeBusca =
          termo.isEmpty ||
          local.nome.toLowerCase().contains(termo) ||
          local.bairro.toLowerCase().contains(termo) ||
          local.categoria.toLowerCase().contains(termo);

      final possuiRecursos = recursos.every(local.possuiRecurso);

      return correspondeBusca && possuiRecursos;
    }).toList();
  }

  /// Retorna apenas os locais cujos ids estão na lista de favoritos.
  List<Local> filtrarFavoritos(List<Local> locais, Set<int> idsFavoritos) {
    return locais.where((local) => idsFavoritos.contains(local.id)).toList();
  }
}
