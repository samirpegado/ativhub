import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repsys/app_state/app_state.dart';
import 'package:repsys/ui/components/base_layout.dart';
import 'package:repsys/ui/core_clientes/components/filtro_core_clientes.dart';
import 'package:repsys/ui/core_clientes/components/novo_cliente.dart';
import 'package:repsys/ui/core_clientes/view_models/core_clientes_viewmodel.dart';
import 'package:repsys/ui/core_clientes/widgets/core_clientes_custom_table.dart';
import 'package:repsys/ui/core/themes/colors.dart';
import 'package:repsys/ui/core/ui/input_decorations.dart';

class CoreClientes extends StatefulWidget {
  const CoreClientes({super.key});

  @override
  State<CoreClientes> createState() => _CoreClientesState();
}

class _CoreClientesState extends State<CoreClientes> {
  final _searchController = TextEditingController();
  Timer? _searchDebounce;
  VoidCallback? _reloadTable;

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    final isWide = MediaQuery.of(context).size.width >= 900;
    return BaseLayout(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text('Clientes',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headlineLarge),
              ),
              Row(children: [
                Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(8.0),
                  child: TextButton(
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (_) => ChangeNotifierProvider(
                            create: (_) => CoreClientesViewModel(),
                            child: const FiltroCoreClientes(),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        minimumSize: const WidgetStatePropertyAll(Size(0, 50)),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.filter_list, color: AppColors.primaryText),
                          const SizedBox(width: 8),
                          Text('Filtros',
                              style: TextStyle(
                                  color: AppColors.primaryText, fontSize: 14)),
                        ],
                      )),
                ),
                if (isWide) ...[
                  const SizedBox(width: 16),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 250),
                    child: TextFormField(
                      controller: _searchController,
                      textCapitalization: TextCapitalization.words,
                      decoration: AppInputDecorations.normal(
                        label: 'Pesquisar',
                        icon: Icons.search_rounded,
                      ),
                      onChanged: (value) {
                        _searchDebounce?.cancel();
                        _searchDebounce =
                            Timer(const Duration(milliseconds: 1000), () {
                          if (!mounted) {
                            return;
                          }
                          final txt = value.trim();
                          context.read<AppState>().updateCoreClientesFiltro(
                                busca: txt.isEmpty ? null : txt,
                              );
                        });
                      },
                    ),
                  ),
                ],
                const SizedBox(width: 16),
                Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(8.0),
                  child: TextButton(
                    onPressed: () async {
                      final result = await showDialog(
                        context: context,
                        builder: (_) => ChangeNotifierProvider(
                          create: (_) => CoreClientesViewModel(),
                          child: const NovoCliente(),
                        ),
                      );
                      // Recarrega a tabela se o cliente foi inserido
                      if (result == true && mounted) {
                        _reloadTable?.call();
                      }
                    },
                    style: ButtonStyle(
                      minimumSize: const WidgetStatePropertyAll(Size(0, 50)),
                      backgroundColor:
                          WidgetStatePropertyAll(AppColors.primary),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.add, color: AppColors.secondary),
                        const SizedBox(width: 8),
                        Text('Adicionar',
                            style: TextStyle(
                                color: AppColors.secondary, fontSize: 14)),
                      ],
                    ),
                  ),
                ),
              ])
            ],
          ),
          const SizedBox(height: 16),

          /// datatable paginado
          Expanded(
            child: CoreClientesCustomTable(
              empresaId: appState.empresa?.id ?? '',
              onInit: (reloadCallback) {
                _reloadTable = reloadCallback;
              },
            ),
          )
          ],
        ),
      ),
    );
  }
}

