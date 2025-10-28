import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repsys/domain/models/catalogo_model.dart';
import 'package:repsys/ui/catalogo/view_models/catalogo_viewmodel.dart';
import 'package:repsys/ui/core/themes/colors.dart';

class DeletarItem extends StatefulWidget {
  const DeletarItem({super.key, required this.item});
  final CatalogoModel item;

  @override
  State<DeletarItem> createState() => _DeletarItemState();
}

class _DeletarItemState extends State<DeletarItem> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surface,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// header do modal
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Atenção!',
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
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Tem certeza que deseja excluir o item abaixo?',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 16),
                    Text(
                      widget.item.nome,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Text('Essa ação não poderá ser desfeita!'),
                  ],
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
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ButtonStyle(
                          minimumSize:
                              const WidgetStatePropertyAll(Size(0, 50)),
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
                    Consumer<CatalogoViewModel>(
                      builder: (_, vm, __) => Material(
                        elevation: 2,
                        borderRadius: BorderRadius.circular(8.0),
                        child: TextButton(
                          onPressed: vm.isSaving
                              ? null
                              : () async {
                                  final erro = await vm.deletar(
                                      itemId: widget.item.id,
                                      empresaId: widget.item.empresaId ?? '');

                                  if (!mounted) return;

                                  if (erro == null) {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        backgroundColor: AppColors.error,
                                        content:
                                            Text('Item deletado com sucesso!'),
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
                            backgroundColor:
                                WidgetStatePropertyAll(AppColors.error),
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
                                      color: AppColors.secondary,
                                    ),
                                  )
                                : Text('Excluir',
                                    style: TextStyle(
                                        color: AppColors.secondary,
                                        fontSize: 14)),
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
