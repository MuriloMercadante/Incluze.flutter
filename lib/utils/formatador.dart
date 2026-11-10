/// Funções auxiliares de formatação de datas e textos.
class Formatador {
  Formatador._();

  static String _doisDigitos(int valor) => valor.toString().padLeft(2, '0');

  /// Ex.: 09/11/2026 14:35
  static String dataHora(DateTime data) {
    return '${_doisDigitos(data.day)}/${_doisDigitos(data.month)}/${data.year} '
        '${_doisDigitos(data.hour)}:${_doisDigitos(data.minute)}';
  }

  /// Ex.: "agora", "há 5 min", "há 2 h", "há 3 dias"
  static String tempoRelativo(DateTime data, {DateTime? agora}) {
    final diferenca = (agora ?? DateTime.now()).difference(data);

    if (diferenca.inMinutes < 1) return 'agora';
    if (diferenca.inMinutes < 60) return 'há ${diferenca.inMinutes} min';
    if (diferenca.inHours < 24) return 'há ${diferenca.inHours} h';
    if (diferenca.inDays == 1) return 'há 1 dia';
    return 'há ${diferenca.inDays} dias';
  }
}
