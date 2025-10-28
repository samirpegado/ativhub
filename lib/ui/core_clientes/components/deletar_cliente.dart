import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:repsys/app_state/app_state.dart';
import 'package:repsys/domain/models/core_clientes_model.dart';
import 'package:repsys/ui/core_clientes/view_models/core_clientes_viewmodel.dart';
import 'package:repsys/ui/core/themes/colors.dart';

class DeletarCliente extends StatelessWidget {
  const DeletarCliente({super.key, required this.cliente});
  final CoreClientesModel cliente;

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();

    return Dialog(
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surface,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Header do modal
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Deletar Cliente',
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.close_rounded,
                          color: AppColors.primaryText),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Divider(height: 1, color: AppColors.borderColor),

                const SizedBox(height: 16),
                Text(
                  'Tem certeza que deseja deletar o cliente "${cliente.nome}"?',
                  style: TextStyle(color: AppColors.primaryText, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Divider(height: 1, color: AppColors.borderColor),

                /// Ações do modal
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Material(
                      elevation: 2,
                      borderRadius: BorderRadius.circular(8.0),
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ButtonStyle(
                          minimumSize: const WidgetStatePropertyAll(Size(0, 50)),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('Cancelar',
                              style: TextStyle(
                                  color: AppColors.primaryText, fontSize: 14)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Consumer<CoreClientesViewModel>(
                      builder: (_, vm, __) => Material(
                        elevation: 2,
                        borderRadius: BorderRadius.circular(8.0),
                        child: TextButton(
                          onPressed: vm.isSaving
                              ? null
                              : () async {
                                  final erro = await vm.deletar(
                                    itemId: cliente.id,
                                    empresaId: appState.empresa!.id,
                                  );

                                  if (!context.mounted) return;

                                  if (erro == null) {
                                    // Limpa o cliente do AppState
                                    appState.updateCoreClientesModel(coreClientesModel: null);
                                    
                                    // Navega de volta à lista de clientes
                                    context.go('/clientes');

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Cliente deletado com sucesso!'),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(erro)),
                                    );
                                  }
                                },
                          style: ButtonStyle(
                            minimumSize:
                                const WidgetStatePropertyAll(Size(0, 50)),
                            backgroundColor: WidgetStatePropertyAll(Colors.red),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: vm.isSaving
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Deletar',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

