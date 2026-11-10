import 'package:flutter/material.dart';

import '../models/local.dart';
import '../routes/app_routes.dart';
import '../services/favorito_service.dart';
import '../services/local_service.dart';
import '../widgets/carregando_widget.dart';
import '../widgets/estado_mensagem.dart';
import '../widgets/local_card.dart';
import '../widgets/conteudo_centralizado.dart';

/// Lista os locais favoritados. Recebe a lista de locais carregada na Home
/// como argumento da rota.
class FavoritosScreen extends StatefulWidget {
  const FavoritosScreen({super.key});

  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  final FavoritoService _favoritoService = FavoritoService();
  final LocalService _localService = LocalService();

  List<Local> _todosLocais = [];
  Set<int> _idsFavoritos = {};
  bool _iniciado = false;
  bool _carregando = true;

  List<Local> get _favoritos =>
      _localService.filtrarFavoritos(_todosLocais, _idsFavoritos);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_iniciado) {
      final argumento = ModalRoute.of(context)?.settings.arguments;
      _todosLocais = argumento is List<Local> ? argumento : [];
      _iniciado = true;
      _carregarFavoritos();
    }
  }

  Future<void> _carregarFavoritos() async {
    final ids = await _favoritoService.listarIds();
    if (!mounted) return;
    setState(() {
      _idsFavoritos = ids;
      _carregando = false;
    });
  }

  Future<void> _remover(Local local) async {
    await _favoritoService.alternar(local.id);
    await _carregarFavoritos();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${local.nome} removido dos favoritos')),
    );
  }

  Future<void> _abrirDetalhes(Local local) async {
    await Navigator.pushNamed(context, AppRoutes.detalhe, arguments: local);
    _carregarFavoritos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meus favoritos')),
      body: ConteudoCentralizado(child: _construirCorpo()),
    );
  }

  Widget _construirCorpo() {
    if (_carregando) return const CarregandoWidget();

    if (_todosLocais.isEmpty) {
      return EstadoMensagem(
        icone: Icons.cloud_download_outlined,
        titulo: 'Locais ainda não carregados',
        mensagem:
            'Volte para a tela inicial e busque os locais para ver '
            'seus favoritos.',
        textoBotao: 'Voltar',
        iconeBotao: Icons.arrow_back,
        onPressed: () => Navigator.pop(context),
      );
    }

    final favoritos = _favoritos;

    if (favoritos.isEmpty) {
      return const EstadoMensagem(
        icone: Icons.favorite_border,
        titulo: 'Nenhum favorito ainda',
        mensagem: 'Toque no coração de um local para salvá-lo aqui.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: favoritos.length,
      itemBuilder: (context, indice) {
        final local = favoritos[indice];
        return LocalCard(
          local: local,
          favorito: true,
          onTap: () => _abrirDetalhes(local),
          onFavoritar: () => _remover(local),
        );
      },
    );
  }
}
