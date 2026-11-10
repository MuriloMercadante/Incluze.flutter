import 'package:flutter/material.dart';

import '../models/gamificacao.dart';
import '../routes/app_routes.dart';
import '../services/alerta_service.dart';
import '../services/avaliacao_service.dart';
import '../services/favorito_service.dart';
import '../services/gamificacao_service.dart';
import '../services/onboarding_service.dart';
import '../utils/app_theme.dart';
import '../widgets/app_logo.dart';
import '../widgets/beneficio_card.dart';
import '../widgets/carregando_widget.dart';
import '../widgets/estatistica_card.dart';
import '../widgets/secao_titulo.dart';
import '../widgets/conteudo_centralizado.dart';

/// Perfil do usuário com pontos, nível, benefícios e informações do projeto.
class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final GamificacaoService _gamificacaoService = GamificacaoService();
  final AvaliacaoService _avaliacaoService = AvaliacaoService();
  final AlertaService _alertaService = AlertaService();
  final FavoritoService _favoritoService = FavoritoService();
  final OnboardingService _onboardingService = OnboardingService();

  bool _carregando = true;
  int _pontos = 0;
  int _totalAvaliacoes = 0;
  int _totalAlertas = 0;
  int _totalFavoritos = 0;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final pontos = await _gamificacaoService.obterPontos();
    final avaliacoes = await _avaliacaoService.listar();
    final alertas = await _alertaService.listar();
    final favoritos = await _favoritoService.listarIds();

    if (!mounted) return;
    setState(() {
      _pontos = pontos;
      _totalAvaliacoes = avaliacoes.length;
      _totalAlertas = alertas.length;
      _totalFavoritos = favoritos.length;
      _carregando = false;
    });
  }

  Future<void> _resgatar(Beneficio beneficio) async {
    final sucesso = await _gamificacaoService.resgatar(beneficio);
    await _carregarDados();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          sucesso
              ? 'Benefício "${beneficio.titulo}" resgatado! '
                    'Apresente este app em ${beneficio.parceiro}.'
              : 'Pontos insuficientes para este benefício.',
        ),
      ),
    );
  }

  Future<void> _reverIntroducao() async {
    await _onboardingService.resetar();
    if (!mounted) return;
    Navigator.pushNamed(context, AppRoutes.onboarding);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meu perfil')),
      body: ConteudoCentralizado(
        child: _carregando
            ? const CarregandoWidget()
            : RefreshIndicator(
                onRefresh: _carregarDados,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _construirCardNivel(),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        EstatisticaCard(
                          icone: Icons.rate_review,
                          valor: '$_totalAvaliacoes',
                          rotulo: 'Avaliações',
                        ),
                        EstatisticaCard(
                          icone: Icons.campaign,
                          valor: '$_totalAlertas',
                          rotulo: 'Alertas',
                        ),
                        EstatisticaCard(
                          icone: Icons.favorite,
                          valor: '$_totalFavoritos',
                          rotulo: 'Favoritos',
                        ),
                      ],
                    ),
                    const SecaoTitulo(
                      titulo: 'Troque seus pontos',
                      icone: Icons.redeem,
                    ),
                    ..._gamificacaoService.beneficios.map(
                      (beneficio) => BeneficioCard(
                        beneficio: beneficio,
                        disponivel: _gamificacaoService.podeResgatar(
                          _pontos,
                          beneficio,
                        ),
                        onResgatar: () => _resgatar(beneficio),
                      ),
                    ),
                    const SecaoTitulo(
                      titulo: 'Sobre o projeto',
                      icone: Icons.public,
                    ),
                    const _SobreProjetoCard(),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: _reverIntroducao,
                      icon: const Icon(Icons.replay),
                      label: const Text('Rever introdução'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _construirCardNivel() {
    final tema = Theme.of(context);
    final nivel = _gamificacaoService.calcularNivel(_pontos);
    final proximo = _gamificacaoService.proximoNivel(_pontos);
    final progresso = _gamificacaoService.calcularProgresso(_pontos);

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: const BoxDecoration(gradient: AppTheme.gradientePrincipal),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: Icon(nivel.icone, color: tema.colorScheme.primary),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nivel.nome,
                        style: tema.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$_pontos pontos',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progresso,
                minHeight: 10,
                backgroundColor: Colors.white24,
                color: tema.colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              proximo == null
                  ? 'Nível máximo alcançado. Obrigado por transformar a cidade!'
                  : 'Faltam ${proximo.pontosMinimos - _pontos} pontos para '
                        '${proximo.nome}',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class _SobreProjetoCard extends StatelessWidget {
  const _SobreProjetoCard();

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                AppLogo(tamanho: 40),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Grupo Aether • Global Solution FIAP — CitizenTech',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Plataforma colaborativa em que a própria comunidade mapeia, '
              'avalia e reporta as condições reais de acessibilidade da cidade.',
              style: tema.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            const _OdsLinha(
              numero: '10',
              texto: 'Redução das Desigualdades',
              cor: Color(0xFFDD1367),
            ),
            const SizedBox(height: 8),
            const _OdsLinha(
              numero: '11',
              texto: 'Cidades e Comunidades Sustentáveis',
              cor: Color(0xFFFD9D24),
            ),
          ],
        ),
      ),
    );
  }
}

class _OdsLinha extends StatelessWidget {
  final String numero;
  final String texto;
  final Color cor;

  const _OdsLinha({
    required this.numero,
    required this.texto,
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: cor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'ODS\n$numero',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(texto)),
      ],
    );
  }
}
