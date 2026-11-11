/// Constantes gerais do aplicativo.
class AppConstants {
  AppConstants._();

  static const String nomeApp = 'INCLUZE';
  static const String slogan = 'Acessibilidade mapeada por quem vive a cidade';

  static const String logoPath = 'assets/images/logo.png';

  /// API REST do projeto (Spring Boot + Azure SQL), publicada no Azure.
  /// Repositório: https://github.com/MuriloMercadante/Incluze.Micro
  static const String urlApi =
      'https://rm554799-incluze-api.livelytree-72ea2755.brazilsouth.azurecontainerapps.io';

  /// Endpoint REST (GET) com os locais no formato consumido pelo app.
  static const String urlLocais = '$urlApi/api/v1/locais/app';

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
