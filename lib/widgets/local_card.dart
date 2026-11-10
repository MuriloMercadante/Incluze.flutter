import 'package:flutter/material.dart';

import '../models/local.dart';
import 'info_linha.dart';
import 'local_imagem.dart';
import 'nota_badge.dart';

/// Card de um local na lista, com imagem, nota, recursos e botão de favorito.
class LocalCard extends StatelessWidget {
  final Local local;
  final bool favorito;
  final VoidCallback onTap;
  final VoidCallback onFavoritar;

  const LocalCard({
    super.key,
    required this.local,
    required this.favorito,
    required this.onTap,
    required this.onFavoritar,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                LocalImagem(url: local.imagemUrl, altura: 140),
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      tooltip: favorito
                          ? 'Remover dos favoritos'
                          : 'Adicionar aos favoritos',
                      icon: Icon(
                        favorito ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                      ),
                      onPressed: onFavoritar,
                    ),
                  ),
                ),
                if (local.verificado)
                  const Positioned(top: 12, left: 12, child: _SeloVerificado()),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          local.nome,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: tema.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      NotaBadge(nota: local.nota),
                    ],
                  ),
                  const SizedBox(height: 4),
                  InfoLinha(
                    icone: Icons.place_outlined,
                    texto: '${local.categoria} • ${local.bairro}',
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: local.recursosDisponiveis
                        .map(
                          (recurso) => Tooltip(
                            message: recurso.nome,
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor:
                                  tema.colorScheme.primaryContainer,
                              child: Icon(
                                recurso.icone,
                                size: 18,
                                color: tema.colorScheme.primary,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SeloVerificado extends StatelessWidget {
  const _SeloVerificado();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified, size: 16, color: Colors.white),
          SizedBox(width: 4),
          Text(
            'Verificado',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
