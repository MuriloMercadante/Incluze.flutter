import 'package:flutter/material.dart';

import '../utils/app_constants.dart';

/// Logo do aplicativo, carregado dos assets.
class AppLogo extends StatelessWidget {
  final double tamanho;

  const AppLogo({super.key, this.tamanho = 120});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(
        AppConstants.logoPath,
        width: tamanho,
        height: tamanho,
        fit: BoxFit.cover,
        semanticLabel: 'Logo ${AppConstants.nomeApp}',
      ),
    );
  }
}

/// Logotipo completo (mão + "NCLUZE") em branco com fundo transparente.
/// Ideal para fundos azuis/gradiente.
class AppLogoNome extends StatelessWidget {
  final double largura;

  const AppLogoNome({super.key, this.largura = 240});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppConstants.logoNomePath,
      width: largura,
      fit: BoxFit.contain,
      semanticLabel: AppConstants.nomeApp,
    );
  }
}
