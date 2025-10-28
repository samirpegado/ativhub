import 'package:flutter/material.dart';
import 'package:repsys/data/repositories/core_ativos_repository.dart';
import 'package:repsys/domain/models/core_ativos_model.dart';
import 'package:repsys/ui/core/themes/colors.dart';

class DeletarAtivo extends StatelessWidget {
  final CoreAtivosModel ativo;

  const DeletarAtivo({
    super.key,
    required this.ativo,
  });

  @override
  Widget build(BuildContext context) {
    final repository = CoreAtivosRepository();

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.orange[700]),
          const SizedBox(width: 12),
          const Text('Confirmar Exclusão'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tem certeza que deseja excluir este ativo?',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (ativo.imagemUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      ativo.imagemUrl!,
                      width: double.infinity,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 120,
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image, size: 48),
                        );
                      },
                    ),
                  ),
                if (ativo.imagemUrl != null) const SizedBox(height: 12),
                Text(
                  ativo.nome ?? 'Nome não informado',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tag: ${ativo.tag ?? '-'}',
                  style: TextStyle(color: AppColors.secondaryText),
                ),
                if (ativo.categoria != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Categoria: ${ativo.categoria}',
                    style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
                  ),
                ],
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(ativo.status ?? 'ativo').withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    ativo.getStatusLabel(),
                    style: TextStyle(
                      fontSize: 12,
                      color: _getStatusColor(ativo.status ?? 'ativo'),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Esta ação não pode ser desfeita.',
            style: TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: Colors.red,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancelar',
            style: TextStyle(color: AppColors.secondaryText),
          ),
        ),
        const SizedBox(width: 8),
        Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(8.0),
          child: TextButton(
            onPressed: () async {
              try {
                // Remove a imagem se existir
                if (ativo.imagemUrl != null) {
                  await repository.removerImagem(imagemUrl: ativo.imagemUrl!);
                }
                
                // Remove o ativo
                await repository.deletar(id: ativo.id!);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ativo excluído com sucesso!'),
                    ),
                  );
                  Navigator.of(context).pop(true);
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao excluir: $e')),
                  );
                  Navigator.of(context).pop();
                }
              }
            },
            style: ButtonStyle(
              minimumSize: const WidgetStatePropertyAll(Size(0, 50)),
              backgroundColor: WidgetStatePropertyAll(AppColors.error),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.delete_forever, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Excluir',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'ativo':
        return Colors.green;
      case 'em_manutencao':
        return Colors.orange;
      case 'inativo':
      case 'baixado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

