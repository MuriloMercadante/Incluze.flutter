import 'package:flutter/material.dart';

import '../models/alerta.dart';
import '../models/local.dart';
import '../services/alerta_service.dart';
import '../utils/app_constants.dart';
import '../utils/app_theme.dart';
import '../widgets/botao_principal.dart';
import '../widgets/secao_titulo.dart';
import '../widgets/conteudo_centralizado.dart';

/// Formulário para reportar uma barreira temporária.
///
/// Pode receber um [Local] como argumento (vindo da tela de detalhes) para
/// preencher o local automaticamente. Devolve os pontos ganhos ao fechar.
class NovoAlertaScreen extends StatefulWidget {
  const NovoAlertaScreen({super.key});

  @override
  State<NovoAlertaScreen> createState() => _NovoAlertaScreenState();
}

class _NovoAlertaScreenState extends State<NovoAlertaScreen> {
  final AlertaService _alertaService = AlertaService();
  final TextEditingController _localController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();

  Local? _local;
  bool _iniciado = false;
  String? _tipoSelecionado;
  bool _salvando = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_iniciado) {
      final argumento = ModalRoute.of(context)?.settings.arguments;
      if (argumento is Local) {
        _local = argumento;
        _localController.text = argumento.nome;
      }
      _iniciado = true;
    }
  }

  @override
  void dispose() {
    _localController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  Future<void> _publicar() async {
    final erro = _alertaService.validar(
      tipo: _tipoSelecionado,
      localNome: _localController.text,
      descricao: _descricaoController.text,
    );
    if (erro != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erro), backgroundColor: AppTheme.perigo),
      );
      return;
    }

    setState(() => _salvando = true);
    final pontos = await _alertaService.adicionar(
      tipo: _tipoSelecionado!,
      localNome: _localController.text,
      descricao: _descricaoController.text,
      localId: _local?.id,
    );

    if (!mounted) return;
    Navigator.pop(context, pontos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reportar barreira')),
      body: ConteudoCentralizado(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Barreiras temporárias atrapalham quem depende de acessibilidade. '
              'Avise a comunidade para que todos possam se planejar.',
            ),
            const SecaoTitulo(
              titulo: 'Tipo de barreira',
              icone: Icons.report_problem_outlined,
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: TipoAlerta.todos.map((tipo) {
                return ChoiceChip(
                  avatar: Icon(tipo.icone, size: 18),
                  label: Text(tipo.nome),
                  selected: _tipoSelecionado == tipo.codigo,
                  onSelected: (_) {
                    setState(() => _tipoSelecionado = tipo.codigo);
                  },
                );
              }).toList(),
            ),
            const SecaoTitulo(titulo: 'Local', icone: Icons.place_outlined),
            TextField(
              controller: _localController,
              readOnly: _local != null,
              decoration: const InputDecoration(
                hintText: 'Ex.: Estação Consolação - saída Augusta',
                prefixIcon: Icon(Icons.place),
              ),
            ),
            const SecaoTitulo(titulo: 'Descrição', icone: Icons.notes),
            TextField(
              controller: _descricaoController,
              maxLines: 3,
              maxLength: 200,
              decoration: const InputDecoration(
                hintText: 'Ex.: elevador da plataforma 2 parado desde cedo.',
              ),
            ),
            const SizedBox(height: 8),
            BotaoPrincipal(
              texto: 'Publicar alerta (+${AppConstants.pontosPorAlerta} pts)',
              icone: Icons.campaign,
              carregando: _salvando,
              onPressed: _publicar,
            ),
          ],
        ),
      ),
    );
  }
}
