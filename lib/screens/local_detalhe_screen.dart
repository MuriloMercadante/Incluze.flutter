import 'package:flutter/material.dart';

import '../models/alerta.dart';
import '../models/avaliacao.dart';
import '../models/local.dart';
import '../models/recurso_acessibilidade.dart';
import '../routes/app_routes.dart';
import '../services/alerta_service.dart';
import '../services/avaliacao_service.dart';
import '../services/favorito_service.dart';
import '../utils/app_theme.dart';
import '../utils/formatador.dart';
import '../widgets/alerta_card.dart';
import '../widgets/botao_principal.dart';
import '../widgets/info_linha.dart';
import '../widgets/local_imagem.dart';
import '../widgets/nota_badge.dart';
import '../widgets/secao_titulo.dart';
import '../widgets/conteudo_centralizado.dart';

/// Detalhes de um local. Recebe o [Local] como argumento da rota.
class LocalDetalheScreen extends StatefulWidget {
  const LocalDetalheScreen({super.key});

  @override
  State<LocalDetalheScreen> createState() => _LocalDetalheScreenState();
}

class _LocalDetalheScreenState extends State<LocalDetalheScreen> {
  final FavoritoService _favoritoService = FavoritoService();
  final AvaliacaoService _avaliacaoService = AvaliacaoService();
  final AlertaService _alertaService = AlertaService();

  late Local _local;
  bool _iniciado = false;
  bool _favorito = false;
  List<Avaliacao> _minhasAvaliacoes = [];
  List<Alerta> _alertasAtivos = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_iniciado) {
      _local = ModalRoute.of(context)!.settings.arguments as Local;
      _iniciado = true;
      _carregarDadosLocais();
    }
  }

  Future<void> _carregarDadosLocais() async {
    final favoritos = await _favoritoService.listarIds();
    final avaliacoes = await _avaliacaoService.listarPorLocal(_local.id);
    final alertas = await _alertaService.listarAtivosPorLocal(_local.id);

    if (!mounted) return;
    setState(() {
      _favorito = favoritos.contains(_local.id);
      _minhasAvaliacoes = avaliacoes;
      _alertasAtivos = alertas;
    });
  }

  Future<void> _alternarFavorito() async {
    final favoritado = await _favoritoService.alternar(_local.id);
    setState(() => _favorito = favoritado);
  }

  Future<void> _abrirAvaliacao() async {
    final pontos = await Navigator.pushNamed(
      context,
      AppRoutes.avaliacao,
      arguments: _local,
    );
    _tratarRetorno(pontos, 'Obrigado pela avaliação!');
  }

  Future<void> _abrirNovoAlerta() async {
    final pontos = await Navigator.pushNamed(
      context,
      AppRoutes.novoAlerta,
      arguments: _local,
    );
    _tratarRetorno(pontos, 'Alerta publicado para a comunidade!');
  }

  void _tratarRetorno(Object? pontos, String mensagem) {
    if (pontos is! int || !mounted) return;
    _carregarDadosLocais();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$mensagem Você ganhou +$pontos pontos.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_local.nome, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            tooltip: _favorito
                ? 'Remover dos favoritos'
                : 'Adicionar aos favoritos',
            icon: Icon(_favorito ? Icons.favorite : Icons.favorite_border),
            onPressed: _alternarFavorito,
          ),
        ],
      ),
      body: ConteudoCentralizado(
        child: ListView(
          children: [
            LocalImagem(url: _local.imagemUrl, altura: 220),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Chip(label: Text(_local.categoria)),
                      const Spacer(),
                      NotaBadge(nota: _local.nota),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _local.nome,
                    style: tema.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InfoLinha(
                    icone: Icons.place_outlined,
                    texto: '${_local.endereco} - ${_local.bairro}',
                  ),
                  const SizedBox(height: 4),
                  InfoLinha(
                    icone: Icons.groups_outlined,
                    texto: '${_local.totalAvaliacoes} avaliações da comunidade',
                  ),
                  const SizedBox(height: 4),
                  InfoLinha(
                    icone: _local.verificado
                        ? Icons.verified
                        : Icons.hourglass_top,
                    texto: _local.verificado
                        ? 'Informações verificadas pela comunidade'
                        : 'Aguardando validação da comunidade',
                    cor: _local.verificado
                        ? AppTheme.sucesso
                        : AppTheme.atencao,
                  ),
                  const SecaoTitulo(titulo: 'Sobre', icone: Icons.info_outline),
                  Text(_local.descricao, style: tema.textTheme.bodyLarge),
                  const SecaoTitulo(
                    titulo: 'Recursos de acessibilidade',
                    icone: Icons.accessibility_new,
                  ),
                  Card(
                    child: Column(
                      children: RecursoAcessibilidade.todos
                          .map(
                            (recurso) => _RecursoLinha(
                              recurso: recurso,
                              disponivel: _local.possuiRecurso(recurso.codigo),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  if (_alertasAtivos.isNotEmpty) ...[
                    const SecaoTitulo(
                      titulo: 'Alertas ativos neste local',
                      icone: Icons.warning_amber,
                    ),
                    ..._alertasAtivos.map(
                      (alerta) => AlertaCard(alerta: alerta),
                    ),
                  ],
                  const SecaoTitulo(
                    titulo: 'Suas avaliações',
                    icone: Icons.rate_review_outlined,
                  ),
                  if (_minhasAvaliacoes.isEmpty)
                    const Text('Você ainda não avaliou este local.')
                  else
                    ..._minhasAvaliacoes.map(
                      (avaliacao) => _AvaliacaoResumo(avaliacao: avaliacao),
                    ),
                  const SizedBox(height: 24),
                  BotaoPrincipal(
                    texto: 'Avaliar este local',
                    icone: Icons.rate_review,
                    onPressed: _abrirAvaliacao,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: _abrirNovoAlerta,
                      icon: const Icon(Icons.campaign),
                      label: const Text('Reportar barreira temporária'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecursoLinha extends StatelessWidget {
  final RecursoAcessibilidade recurso;
  final bool disponivel;

  const _RecursoLinha({required this.recurso, required this.disponivel});

  @override
  Widget build(BuildContext context) {
    final cor = disponivel ? AppTheme.sucesso : Colors.grey;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(recurso.icone, color: cor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recurso.nome,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  recurso.descricao,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Icon(
            disponivel ? Icons.check_circle : Icons.cancel_outlined,
            color: cor,
            semanticLabel: disponivel ? 'Disponível' : 'Não informado',
          ),
        ],
      ),
    );
  }
}

class _AvaliacaoResumo extends StatelessWidget {
  final Avaliacao avaliacao;

  const _AvaliacaoResumo({required this.avaliacao});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ...List.generate(
                  5,
                  (indice) => Icon(
                    indice < avaliacao.nota ? Icons.star : Icons.star_border,
                    color: AppTheme.atencao,
                    size: 20,
                  ),
                ),
                const Spacer(),
                Text(
                  Formatador.dataHora(avaliacao.data),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            if (avaliacao.comentario.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(avaliacao.comentario),
            ],
            const SizedBox(height: 6),
            Text(
              '${avaliacao.recursosConfirmados.length} recursos confirmados',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
