import 'package:flutter/material.dart';

import '../models/avaliacao.dart';
import '../models/local.dart';
import '../models/recurso_acessibilidade.dart';
import '../services/avaliacao_service.dart';
import '../utils/app_constants.dart';
import '../utils/app_theme.dart';
import '../widgets/botao_principal.dart';
import '../widgets/secao_titulo.dart';
import '../widgets/conteudo_centralizado.dart';

/// Formulário de avaliação de acessibilidade. Recebe o [Local] como argumento
/// e devolve os pontos ganhos ao fechar.
class AvaliacaoScreen extends StatefulWidget {
  const AvaliacaoScreen({super.key});

  @override
  State<AvaliacaoScreen> createState() => _AvaliacaoScreenState();
}

class _AvaliacaoScreenState extends State<AvaliacaoScreen> {
  static const List<String> _rotulosNota = [
    'Toque nas estrelas para avaliar',
    'Muito ruim',
    'Ruim',
    'Regular',
    'Boa',
    'Excelente',
  ];

  final AvaliacaoService _avaliacaoService = AvaliacaoService();
  final TextEditingController _comentarioController = TextEditingController();

  late Local _local;
  bool _iniciado = false;
  final Set<String> _recursosConfirmados = {};
  int _nota = 0;
  bool _salvando = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_iniciado) {
      _local = ModalRoute.of(context)!.settings.arguments as Local;
      _recursosConfirmados.addAll(_local.recursos);
      _iniciado = true;
    }
  }

  @override
  void dispose() {
    _comentarioController.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    final erro = _avaliacaoService.validar(nota: _nota);
    if (erro != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erro), backgroundColor: AppTheme.perigo),
      );
      return;
    }

    setState(() => _salvando = true);
    final pontos = await _avaliacaoService.salvar(
      Avaliacao(
        localId: _local.id,
        localNome: _local.nome,
        nota: _nota,
        recursosConfirmados: _recursosConfirmados.toList(),
        comentario: _comentarioController.text.trim(),
        data: DateTime.now(),
      ),
    );

    if (!mounted) return;
    Navigator.pop(context, pontos);
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Avaliar acessibilidade')),
      body: ConteudoCentralizado(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              _local.nome,
              style: tema.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Marque os recursos que você realmente encontrou no local.',
            ),
            const SecaoTitulo(
              titulo: 'Recursos encontrados',
              icone: Icons.checklist,
            ),
            Card(
              child: Column(
                children: RecursoAcessibilidade.todos.map((recurso) {
                  return CheckboxListTile(
                    value: _recursosConfirmados.contains(recurso.codigo),
                    onChanged: (marcado) {
                      setState(() {
                        if (marcado ?? false) {
                          _recursosConfirmados.add(recurso.codigo);
                        } else {
                          _recursosConfirmados.remove(recurso.codigo);
                        }
                      });
                    },
                    secondary: Icon(recurso.icone),
                    title: Text(recurso.nome),
                  );
                }).toList(),
              ),
            ),
            const SecaoTitulo(titulo: 'Nota geral', icone: Icons.star_outline),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (indice) {
                final valor = indice + 1;
                return IconButton(
                  iconSize: 40,
                  tooltip: '$valor estrela${valor > 1 ? 's' : ''}',
                  icon: Icon(
                    valor <= _nota ? Icons.star : Icons.star_border,
                    color: AppTheme.atencao,
                  ),
                  onPressed: () => setState(() => _nota = valor),
                );
              }),
            ),
            Center(
              child: Text(
                _rotulosNota[_nota],
                style: tema.textTheme.titleSmall,
              ),
            ),
            const SecaoTitulo(titulo: 'Comentário (opcional)'),
            TextField(
              controller: _comentarioController,
              maxLines: 3,
              maxLength: 300,
              decoration: const InputDecoration(
                hintText: 'Ex.: a rampa é íngreme, mas os atendentes ajudam.',
              ),
            ),
            const SizedBox(height: 8),
            BotaoPrincipal(
              texto:
                  'Enviar avaliação (+${AppConstants.pontosPorAvaliacao} pts)',
              icone: Icons.send,
              carregando: _salvando,
              onPressed: _enviar,
            ),
          ],
        ),
      ),
    );
  }
}
