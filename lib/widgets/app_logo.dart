import 'package:flutter/material.dart';

import '../utils/app_constants.dart';

/// Logo do aplicativo, carregado dos assets.
class AppLogo extends StatelessWidget {
  final double tamanho;

  const AppLogo({super.key, this.tamanho = 120});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppConstants.logoPath,
      width: tamanho,
      height: tamanho,
      semanticLabel: 'Logo ${AppConstants.nomeApp}',
    );
  }
}
