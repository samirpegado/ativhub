import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repsys/app_state/app_state.dart';
import 'package:repsys/ui/clientes/components/clientes_fitlro.dart';
import 'package:repsys/ui/clientes/components/clientes_novo_item.dart';
import 'package:repsys/ui/clientes/view_models/clientes_viewmodel.dart';
import 'package:repsys/ui/clientes/widgets/clientes_custom_table.dart';
import 'package:repsys/ui/core/themes/colors.dart';
import 'package:repsys/ui/core/ui/input_decorations.dart';

class Clientes extends StatefulWidget {
  const Clientes({super.key});

  @override
  State<Clientes> createState() => _ClientesState();
}

class _ClientesState extends State<Clientes> {
  final _searchController = TextEditingController();
  Timer? _searchDebounce;

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
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text('Clientes',maxLines: 1,overflow: TextOverflow.ellipsis,
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
                            create: (_) =>
                                ClientesViewmodel(), // já instancia com o repo dentro
                            child: const ClientesFitlro(),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        minimumSize: WidgetStatePropertyAll(Size(0, 50)),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.filter_list, color: AppColors.primaryText),
                          SizedBox(width: 8),
                          Text('Filtros',
                              style: TextStyle(
                                  color: AppColors.primaryText, fontSize: 14)),
                        ],
                      )),
                ),
                if(isWide)...[SizedBox(width: 16),
                Container(
                  constraints: BoxConstraints(maxWidth: 250),
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
                        context.read<AppState>().updateCatalogoFiltro(
                              busca: txt.isEmpty ? null : txt,
                            );
                      });
                    },
                  ),
                ),],
                
                SizedBox(width: 16),
                Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(8.0),
                  child: TextButton(
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (_) => ChangeNotifierProvider(
                          create: (_) =>
                              ClientesViewmodel(), // já instancia com o repo dentro
                          child: const ClientesNovoItem(),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      minimumSize: WidgetStatePropertyAll(Size(0, 50)),
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
                        SizedBox(width: 8),
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
          SizedBox(height: 16),

          /// datatable paginado
          Expanded(
            child: ClientesCustomTable(
              empresaId: appState.empresa?.id ?? '',
            ),
          )
        ],
      ),
    );
  }
}
