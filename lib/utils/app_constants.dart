/// Constantes gerais do aplicativo.
class AppConstants {
  AppConstants._();

  static const String nomeApp = 'INCLUZE';
  static const String slogan = 'Acessibilidade mapeada por quem vive a cidade';

  static const String logoPath = 'assets/images/logo.png';

  /// Endpoint REST (GET) da API do projeto.
  ///
  /// O arquivo `api/locais.json` deste repositório é servido pelo GitHub.
  static const String urlLocais =
      'https://raw.githubusercontent.com/MuriloMercadante/Incluze/main/api/locais.json';

  static const Duration tempoLimiteRequisicao = Duration(seconds: 15);
  static const Duration duracaoSplash = Duration(milliseconds: 3500);
  static const Duration duracaoAnimacaoSplash = Duration(milliseconds: 1200);

  // Chaves do SharedPreferences
  static const String chaveOnboardingVisto = 'onboarding_visto';
  static const String chaveFavoritos = 'favoritos';
  static const String chaveAvaliacoes = 'avaliacoes';
  static const String chaveAlertas = 'alertas';
  static const String chavePontos = 'pontos';

  // Gamificação
  static const int pontosPorAvaliacao = 10;
  static const int pontosPorAlerta = 5;
}
