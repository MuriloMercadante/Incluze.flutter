import 'dart:convert';
import 'dart:io';

import 'package:aether_inclusao/models/local.dart';
import 'package:aether_inclusao/services/local_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  final jsonApi = File('api/locais.json').readAsStringSync();

  group('LocalService.buscarLocais', () {
    test('converte o JSON da API em objetos Local', () async {
      final service = LocalService(
        client: MockClient(
          (_) async => http.Response.bytes(utf8.encode(jsonApi), 200),
        ),
      );

      final locais = await service.buscarLocais();

      expect(locais, hasLength(20));
      expect(locais.first.nome, 'Café Encontro Sensorial');
      expect(locais.first.possuiRecurso('braille'), isTrue);
    });

    test('lança erro amigável quando o servidor falha', () async {
      final service = LocalService(
        client: MockClient((_) async => http.Response('erro', 500)),
      );

      expect(service.buscarLocais(), throwsA(isA<LocalServiceException>()));
    });

    test('lança erro amigável sem conexão', () async {
      final service = LocalService(
        client: MockClient((_) async => throw const SocketException('off')),
      );

      expect(service.buscarLocais(), throwsA(isA<LocalServiceException>()));
    });
  });

  group('LocalService.filtrar', () {
    final locais = (jsonDecode(jsonApi) as List)
        .map((item) => Local.fromJson(item as Map<String, dynamic>))
        .toList();
    final service = LocalService();

    test('filtra por texto (nome, bairro ou categoria)', () {
      final resultado = service.filtrar(locais, busca: 'consolação');
      expect(resultado.every((l) => l.bairro == 'Consolação'), isTrue);
      expect(resultado, isNotEmpty);
    });

    test('filtra por múltiplos recursos', () {
      final resultado =
          service.filtrar(locais, recursos: {'libras', 'baixo_estimulo'});
      expect(
        resultado.map((l) => l.id),
        containsAll([6, 10]),
      );
      expect(
        resultado.every(
          (l) => l.possuiRecurso('libras') && l.possuiRecurso('baixo_estimulo'),
        ),
        isTrue,
      );
    });
  });
}
