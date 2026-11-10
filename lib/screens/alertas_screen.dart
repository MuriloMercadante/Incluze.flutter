import 'package:flutter/material.dart';

import '../models/alerta.dart';
import '../routes/app_routes.dart';
import '../services/alerta_service.dart';
import '../services/local_service.dart';
import '../widgets/alerta_card.dart';
import '../widgets/carregando_widget.dart';
import '../widgets/estado_mensagem.dart';
import '../widgets/conteudo_centralizado.dart';

/// Lista de alertas temporários de barreiras ("Waze da inclusão").
class AlertasScreen extends StatefulWidget {
  const AlertasScreen({super.key});

  @override
  State<AlertasScreen> createState() => _AlertasScreenState();
}

class _AlertasScreenState extends State<AlertasScreen> {
  final AlertaService _alertaService = AlertaService();
  final LocalService _localService = LocalService();

  List<Alerta> _alertas = [];
  bool _carregando = true;
  bool _abrindoLocal = false;
  bool _mostrarResolvidos = true;

  List<Alerta> get _alertasExibidos =>
      _alertaService.filtrar(_alertas, mostrarResolvidos: _mostrarResolvidos);

  int get _totalAtivos => _alertas.where((a) => !a.resolvido).length;

  @override
  void initState() {
    super.initState();
    _carregarAlertas();
  }

  Future<void> _carregarAlertas() async {
    final alertas = await _alertaService.listar();
    if (!mounted) return;
    setState(() {
      _alertas = alertas;
      _carregando = false;
    });
  }

  Future<void> _alternarResolvido(Alerta alerta) async {
    await _alertaService.alternarResolvido(alerta.id);
    await _carregarAlertas();
  }

  Future<void> _remover(Alerta alerta) async {
    await _alertaService.remover(alerta.id);
    await _carregarAlertas();

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Alerta excluído')));
  }

  /// Abre a tela de detalhes do local ligado ao alerta.
  Future<void> _abrirLocal(Alerta alerta) async {
    if (_abrindoLocal || alerta.localId == null) return;
    setState(() => _abrindoLocal = true);

    String? erro;
    try {
      final local = await _localService.buscarPorId(alerta.localId!);
      if (!mounted) return;
      if (local == null) {
        erro = 'Este local não foi encontrado na lista de locais.';
      } else {
        setState(() => _abrindoLocal = false);
        await Navigator.pushNamed(context, AppRoutes.detalhe, arguments: local);
        await _carregarAlertas();
        return;
      }
    } on LocalServiceException catch (e) {
      erro = e.mensagem;
    }

    if (!mounted) return;
    setState(() => _abrindoLocal = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(erro)));
  }

  Future<void> _novoAlerta() async {
    final pontos = await Navigator.pushNamed(context, AppRoutes.novoAlerta);
    if (pontos is! int) return;

    await _carregarAlertas();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Alerta publicado! Você ganhou +$pontos pontos.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alertas da comunidade'),
        actions: [
          IconButton(
            tooltip: _mostrarResolvidos
                ? 'Ocultar resolvidos'
                : 'Mostrar resolvidos',
            icon: Icon(
              _mostrarResolvidos ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() => _mostrarResolvidos = !_mostrarResolvidos);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _novoAlerta,
        icon: const Icon(Icons.add_alert),
        label: const Text('Novo alerta'),
      ),
      body: ConteudoCentralizado(child: _construirCorpo()),
    );
  }

  Widget _construirCorpo() {
    if (_carregando) {
      return const CarregandoWidget(mensagem: 'Carregando alertas...');
    }

    if (_alertas.isEmpty) {
      return EstadoMensagem(
        icone: Icons.campaign_outlined,
        titulo: 'Nenhum alerta por enquanto',
        mensagem:
            'Viu um elevador quebrado ou uma calçada bloqueada? '
            'Avise a comunidade!',
        textoBotao: 'Reportar barreira',
        iconeBotao: Icons.add_alert,
        onPressed: _novoAlerta,
      );
    }

    final alertas = _alertasExibidos;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_abrindoLocal) const LinearProgressIndicator(),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Text(
            '$_totalAtivos alerta(s) ativo(s) de ${_alertas.length}',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        Expanded(
          child: alertas.isEmpty
              ? const EstadoMensagem(
                  icone: Icons.task_alt,
                  titulo: 'Tudo resolvido!',
                  mensagem: 'Não há alertas ativos no momento.',
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                  itemCount: alertas.length,
                  itemBuilder: (context, indice) {
                    final alerta = alertas[indice];
                    return AlertaCard(
                      alerta: alerta,
                      onAlternarResolvido: () => _alternarResolvido(alerta),
                      onRemover: () => _remover(alerta),
                      onTap: alerta.localId == null
                          ? null
                          : () => _abrirLocal(alerta),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
