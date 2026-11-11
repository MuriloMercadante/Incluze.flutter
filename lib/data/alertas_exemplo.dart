import '../models/alerta.dart';

/// Alertas de demonstração exibidos na primeira vez que o app é aberto,
/// simulando barreiras já reportadas pela comunidade.
///
/// As datas são relativas a [agora] para que os alertas pareçam recentes.
class AlertasExemplo {
  AlertasExemplo._();

  static List<Alerta> gerar(DateTime agora) {
    return [
      Alerta(
        id: 'exemplo-1',
        tipo: 'elevador_quebrado',
        descricao:
            'Elevador do lado esquerdo parado desde cedo. '
            'O acesso ao 2º andar só está possível pela escada.',
        localNome: 'Hospital Comunitário Bela Vista',
        localId: 13,
        data: agora.subtract(const Duration(minutes: 40)),
      ),
      Alerta(
        id: 'exemplo-2',
        tipo: 'calcada_obstruida',
        descricao:
            'Mesas e cadeiras de um bar ocupando toda a calçada. '
            'Cadeirantes precisam ir pela rua.',
        localNome: 'Rua Augusta, próximo ao nº 1200',
        localId: 12,
        data: agora.subtract(const Duration(hours: 2)),
      ),
      Alerta(
        id: 'exemplo-3',
        tipo: 'obra',
        descricao:
            'Obra na entrada principal com tapumes. Use a entrada '
            'lateral, que tem rampa.',
        localNome: 'Biblioteca Municipal Vila Mariana (Demo)',
        localId: 19,
        data: agora.subtract(const Duration(hours: 5)),
      ),
      Alerta(
        id: 'exemplo-4',
        tipo: 'piso_tatil_danificado',
        descricao:
            'Piso tátil arrancado em um trecho de uns 10 metros '
            'perto da bilheteria.',
        localNome: 'Cinema Inclusivo Frei Caneca',
        localId: 17,
        data: agora.subtract(const Duration(hours: 9)),
      ),
      Alerta(
        id: 'exemplo-5',
        tipo: 'rampa_bloqueada',
        descricao:
            'Carro estacionado em cima da rampa de acesso. '
            'Já avisamos a segurança do shopping.',
        localNome: 'Shopping Centro Paulista (Demo)',
        localId: 29,
        data: agora.subtract(const Duration(days: 1, hours: 3)),
      ),
      Alerta(
        id: 'exemplo-6',
        tipo: 'outro',
        descricao:
            'Intérprete de Libras ausente hoje na sessão das 15h. '
            'A legenda está funcionando normalmente.',
        localNome: 'Teatro Municipal Acessível (Demo)',
        localId: 24,
        data: agora.subtract(const Duration(days: 1, hours: 8)),
      ),
      Alerta(
        id: 'exemplo-7',
        tipo: 'elevador_quebrado',
        descricao:
            'Elevador hidráulico da piscina em manutenção. '
            'Previsão de volta na próxima semana.',
        localNome: 'Centro Aquático Municipal (Demo)',
        localId: 30,
        data: agora.subtract(const Duration(days: 2)),
      ),
      Alerta(
        id: 'exemplo-8',
        tipo: 'calcada_obstruida',
        descricao:
            'Caçamba de entulho bloqueando a calçada em frente '
            'ao mercado.',
        localNome: 'Mercado Bom Preço',
        localId: 23,
        data: agora.subtract(const Duration(days: 3)),
        resolvido: true,
      ),
      Alerta(
        id: 'exemplo-9',
        tipo: 'obra',
        descricao:
            'Buraco na faixa de pedestres da esquina. '
            'A prefeitura já fez o reparo.',
        localNome: 'Parque Linear Trianon (Demo)',
        localId: 16,
        data: agora.subtract(const Duration(days: 4)),
        resolvido: true,
      ),
      Alerta(
        id: 'exemplo-10',
        tipo: 'rampa_bloqueada',
        descricao: 'Entrega de mercadorias bloqueando a rampa pela manhã.',
        localNome: 'Livraria Página Aberta',
        localId: 15,
        data: agora.subtract(const Duration(days: 6)),
        resolvido: true,
      ),
    ];
  }
}
