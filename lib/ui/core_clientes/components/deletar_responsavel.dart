import 'package:flutter/material.dart';
import 'package:repsys/data/repositories/core_clientes_pessoal_repository.dart';
import 'package:repsys/domain/models/core_clientes_pessoal_model.dart';
import 'package:repsys/ui/core/themes/colors.dart';

class DeletarResponsavel extends StatelessWidget {
  final CoreClientesPessoalModel responsavel;

  const DeletarResponsavel({
    super.key,
    required this.responsavel,
  });

  @override
  Widget build(BuildContext context) {
    final repository = CoreClientesPessoalRepository();

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
            'Tem certeza que deseja excluir este responsável?',
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
                Text(
                  responsavel.nome ?? 'Nome não informado',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  responsavel.cargo ?? 'Cargo não informado',
                  style: TextStyle(color: AppColors.secondaryText),
                ),
                const SizedBox(height: 4),
                Text(
                  responsavel.email ?? '',
                  style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
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
                await repository.deletar(id: responsavel.id!);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Responsável excluído com sucesso!'),
                    ),
                  );
                  Navigator.of(context).pop(true); // Retorna true indicando sucesso
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
}

