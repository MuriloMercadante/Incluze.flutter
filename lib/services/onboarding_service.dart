import 'package:shared_preferences/shared_preferences.dart';

import '../utils/app_constants.dart';

/// Controla, via SharedPreferences, se a introdução deve ser exibida.
class OnboardingService {
  Future<bool> jaVisualizou() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstants.chaveOnboardingVisto) ?? false;
  }

  /// Salva a preferência ao final da introdução.
  ///
  /// Se o usuário marcou "Não mostrar novamente", a introdução não aparece
  /// mais. Caso contrário, ela será exibida novamente na próxima abertura.
  Future<void> salvarPreferencia({required bool naoMostrarNovamente}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.chaveOnboardingVisto, naoMostrarNovamente);
  }

  Future<void> resetar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.chaveOnboardingVisto);
  }
}
