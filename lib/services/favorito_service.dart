import 'package:shared_preferences/shared_preferences.dart';

import '../utils/app_constants.dart';

/// Persiste localmente os ids dos locais favoritados.
class FavoritoService {
  Future<Set<int>> listarIds() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(AppConstants.chaveFavoritos) ?? [];
    return ids.map(int.parse).toSet();
  }

  /// Adiciona ou remove o local dos favoritos.
  /// Retorna `true` se o local ficou favoritado.
  Future<bool> alternar(int localId) async {
    final ids = await listarIds();
    final favoritado = !ids.contains(localId);

    if (favoritado) {
      ids.add(localId);
    } else {
      ids.remove(localId);
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      AppConstants.chaveFavoritos,
      ids.map((id) => id.toString()).toList(),
    );
    return favoritado;
  }
}
