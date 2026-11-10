import 'package:shared_preferences/shared_preferences.dart';

import '../models/gamificacao.dart';
import '../utils/app_constants.dart';

/// Regras de pontuação, níveis e resgate de benefícios.
class GamificacaoService {
  Future<int> obterPontos() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(AppConstants.chavePontos) ?? 0;
  }

  Future<int> adicionarPontos(int quantidade) async {
    final prefs = await SharedPreferences.getInstance();
    final total = (prefs.getInt(AppConstants.chavePontos) ?? 0) + quantidade;
    await prefs.setInt(AppConstants.chavePontos, total);
    return total;
  }

  bool podeResgatar(int pontos, Beneficio beneficio) =>
      pontos >= beneficio.custo;

  /// Desconta os pontos do benefício. Retorna `false` se não houver saldo.
  Future<bool> resgatar(Beneficio beneficio) async {
    final pontos = await obterPontos();
    if (!podeResgatar(pontos, beneficio)) return false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.chavePontos, pontos - beneficio.custo);
    return true;
  }

  NivelUsuario calcularNivel(int pontos) {
    return NivelUsuario.niveis.lastWhere(
      (nivel) => pontos >= nivel.pontosMinimos,
    );
  }

  NivelUsuario? proximoNivel(int pontos) {
    for (final nivel in NivelUsuario.niveis) {
      if (nivel.pontosMinimos > pontos) return nivel;
    }
    return null;
  }

  /// Progresso (0.0 a 1.0) até o próximo nível.
  double calcularProgresso(int pontos) {
    final atual = calcularNivel(pontos);
    final proximo = proximoNivel(pontos);
    if (proximo == null) return 1.0;

    return (pontos - atual.pontosMinimos) /
        (proximo.pontosMinimos - atual.pontosMinimos);
  }

  List<Beneficio> get beneficios => Beneficio.disponiveis;
}
