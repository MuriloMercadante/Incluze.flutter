import 'package:flutter/material.dart';

import '../models/onboarding_item.dart';
import '../routes/app_routes.dart';
import '../services/onboarding_service.dart';
import '../widgets/indicador_paginas.dart';
import '../widgets/onboarding_pagina.dart';
import '../widgets/conteudo_centralizado.dart';

/// Introdução com 4 páginas explicando a proposta do aplicativo.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final OnboardingService _onboardingService = OnboardingService();
  final PageController _pageController = PageController();
  final List<OnboardingItem> _paginas = OnboardingItem.paginas;

  int _paginaAtual = 0;
  bool _naoMostrarNovamente = false;

  bool get _primeiraPagina => _paginaAtual == 0;
  bool get _ultimaPagina => _paginaAtual == _paginas.length - 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _irParaPagina(int pagina) {
    _pageController.animateToPage(
      pagina,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _avancar() {
    if (_ultimaPagina) {
      _finalizar();
    } else {
      _irParaPagina(_paginaAtual + 1);
    }
  }

  void _voltar() => _irParaPagina(_paginaAtual - 1);

  Future<void> _finalizar() async {
    await _onboardingService.salvarPreferencia(
      naoMostrarNovamente: _naoMostrarNovamente,
    );

    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.home,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConteudoCentralizado(
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _finalizar,
                  child: const Text('Pular'),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _paginas.length,
                  onPageChanged: (pagina) {
                    setState(() => _paginaAtual = pagina);
                  },
                  itemBuilder: (context, indice) {
                    return OnboardingPagina(item: _paginas[indice]);
                  },
                ),
              ),
              IndicadorPaginas(
                total: _paginas.length,
                paginaAtual: _paginaAtual,
              ),
              const SizedBox(height: 8),
              CheckboxListTile(
                value: _naoMostrarNovamente,
                onChanged: (valor) {
                  setState(() => _naoMostrarNovamente = valor ?? false);
                },
                title: const Text('Não mostrar novamente'),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _primeiraPagina ? null : _voltar,
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Voltar'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _avancar,
                        icon: Icon(
                          _ultimaPagina ? Icons.check : Icons.arrow_forward,
                        ),
                        label: Text(_ultimaPagina ? 'Começar' : 'Avançar'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
