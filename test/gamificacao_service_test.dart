import 'package:aether_inclusao/models/gamificacao.dart';
import 'package:aether_inclusao/services/gamificacao_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final service = GamificacaoService();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('calcula o nível de acordo com os pontos', () {
    expect(service.calcularNivel(0).nome, 'Iniciante');
    expect(service.calcularNivel(60).nome, 'Colaborador');
    expect(service.calcularNivel(320).nome, 'Embaixador');
    expect(service.proximoNivel(320), isNull);
    expect(service.calcularProgresso(100), closeTo(0.5, 0.001));
  });

  test('resgata benefício apenas com pontos suficientes', () async {
    const beneficio = Beneficio(
      titulo: 'Teste',
      parceiro: 'Parceiro',
      custo: 30,
      icone: Icons.star,
    );

    expect(await service.resgatar(beneficio), isFalse);
    await service.adicionarPontos(40);
    expect(await service.resgatar(beneficio), isTrue);
    expect(await service.obterPontos(), 10);
  });
}
