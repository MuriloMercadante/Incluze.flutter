import 'package:flutter/material.dart';

import '../models/estado_tela.dart';
import '../models/local.dart';
import '../models/recurso_acessibilidade.dart';
import '../routes/app_routes.dart';
import '../services/favorito_service.dart';
import '../services/local_service.dart';
import '../utils/app_constants.dart';
import '../widgets/app_logo.dart';
import '../widgets/boas_vindas_banner.dart';
import '../widgets/conteudo_centralizado.dart';
import '../widgets/carregando_widget.dart';
import '../widgets/estado_mensagem.dart';
import '../widgets/local_card.dart';
import '../widgets/recurso_chip.dart';

/// Tela principal: lista os locais vindos da API, com busca e filtros.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocalService _localService = LocalService();
  final FavoritoService _favoritoService = FavoritoService();
  final TextEditingController _buscaController = TextEditingController();

  EstadoTela _estado = EstadoTela.inicial;
  String _mensagemErro = '';
  List<Local> _locais = [];
  Set<int> _favoritos = {};
  final Set<String> _recursosSelecionados = {};

  List<Local> get _locaisFiltrados => _localService.filtrar(
    _locais,
    busca: _buscaController.text,
    recursos: _recursosSelecionados,
  );

  @override
  void initState() {
    super.initState();
    _carregarFavoritos();
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  Future<void> _carregarLocais() async {
    setState(() => _estado = EstadoTela.carregando);

    try {
      final locais = await _localService.buscarLocais();
      if (!mounted) return;
      setState(() {
        _locais = locais;
        _estado = EstadoTela.sucesso;
      });
    } on LocalServiceException catch (erro) {
      if (!mounted) return;
      setState(() {
        _mensagemErro = erro.mensagem;
        _estado = EstadoTela.erro;
      });
    }
  }

  Future<void> _carregarFavoritos() async {
    final favoritos = await _favoritoService.listarIds();
    if (!mounted) return;
    setState(() => _favoritos = favoritos);
  }

  Future<void> _alternarFavorito(Local local) async {
    final favoritado = await _favoritoService.alternar(local.id);
    await _carregarFavoritos();

    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            favoritado
                ? '${local.nome} adicionado aos favoritos'
                : '${local.nome} removido dos favoritos',
          ),
        ),
      );
  }

  void _alternarFiltro(String codigo, bool selecionado) {
    setState(() {
      if (selecionado) {
        _recursosSelecionados.add(codigo);
      } else {
        _recursosSelecionados.remove(codigo);
      }
    });
  }

  void _limparFiltros() {
    setState(() {
      _buscaController.clear();
      _recursosSelecionados.clear();
    });
  }

  Future<void> _abrirDetalhes(Local local) async {
    await Navigator.pushNamed(context, AppRoutes.detalhe, arguments: local);
    _carregarFavoritos();
  }

  Future<void> _abrirFavoritos() async {
    await Navigator.pushNamed(context, AppRoutes.favoritos, arguments: _locais);
    _carregarFavoritos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const AppLogo(tamanho: 30),
            ),
            const SizedBox(width: 10),
            const Flexible(child: Text(AppConstants.nomeApp)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Favoritos',
            icon: const Icon(Icons.favorite),
            onPressed: _abrirFavoritos,
          ),
          IconButton(
            tooltip: 'Alertas da comunidade',
            icon: const Icon(Icons.campaign),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.alertas),
          ),
          IconButton(
            tooltip: 'Meu perfil',
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.perfil),
          ),
        ],
      ),
      body: _construirCorpo(),
    );
  }

  Widget _construirCorpo() {
    switch (_estado) {
      case EstadoTela.inicial:
        return ConteudoCentralizado(
          larguraMaxima: 560,
          alinhamento: Alignment.center,
          child: BoasVindasBanner(onBuscar: _carregarLocais),
        );
      case EstadoTela.carregando:
        return const CarregandoWidget(mensagem: 'Buscando locais...');
      case EstadoTela.erro:
        return EstadoMensagem(
          icone: Icons.wifi_off,
          titulo: 'Não foi possível carregar',
          mensagem: _mensagemErro,
          textoBotao: 'Tentar novamente',
          onPressed: _carregarLocais,
          erro: true,
        );
      case EstadoTela.sucesso:
        return _construirLista();
    }
  }

  Widget _construirLista() {
    final locais = _locaisFiltrados;

    return ConteudoCentralizado(
      larguraMaxima: 1200,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _buscaController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Buscar por nome, bairro ou categoria',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _buscaController.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Limpar busca',
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(_buscaController.clear),
                      ),
              ),
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: RecursoAcessibilidade.todos.length,
              separatorBuilder: (context, indice) => const SizedBox(width: 8),
              itemBuilder: (context, indice) {
                final recurso = RecursoAcessibilidade.todos[indice];
                return RecursoChip(
                  recurso: recurso,
                  selecionado: _recursosSelecionados.contains(recurso.codigo),
                  onSelecionado: (valor) =>
                      _alternarFiltro(recurso.codigo, valor),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${locais.length} de ${_locais.length} locais',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                if (_recursosSelecionados.isNotEmpty ||
                    _buscaController.text.isNotEmpty)
                  TextButton.icon(
                    onPressed: _limparFiltros,
                    icon: const Icon(Icons.filter_alt_off),
                    label: const Text('Limpar filtros'),
                  ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _carregarLocais,
              child: locais.isEmpty
                  ? ListView(
                      children: const [
                        SizedBox(height: 40),
                        EstadoMensagem(
                          icone: Icons.search_off,
                          titulo: 'Nenhum local encontrado',
                          mensagem:
                              'Tente outra busca ou remova alguns filtros.',
                        ),
                      ],
                    )
                  : _construirGradeOuLista(locais),
            ),
          ),
        ],
      ),
    );
  }

  /// Celular: lista em uma coluna. Telas largas: grade de cards.
  Widget _construirGradeOuLista(List<Local> locais) {
    Widget card(BuildContext context, int indice) {
      final local = locais[indice];
      return LocalCard(
        local: local,
        favorito: _favoritos.contains(local.id),
        onTap: () => _abrirDetalhes(local),
        onFavoritar: () => _alternarFavorito(local),
      );
    }

    return LayoutBuilder(
      builder: (context, restricoes) {
        if (restricoes.maxWidth < _larguraMinimaGrade) {
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            itemCount: locais.length,
            itemBuilder: card,
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 400,
            mainAxisExtent: 300,
            crossAxisSpacing: 16,
          ),
          itemCount: locais.length,
          itemBuilder: card,
        );
      },
    );
  }

  static const double _larguraMinimaGrade = 700;
}
