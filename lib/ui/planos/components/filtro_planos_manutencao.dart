import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repsys/app_state/app_state.dart';
import 'package:repsys/ui/core/themes/colors.dart';
import 'package:repsys/ui/core/ui/input_decorations.dart';
import 'package:repsys/utils/constants.dart';
import 'package:repsys/ui/planos/view_models/planos_viewmodel.dart';

class FiltroPlanosManutencao extends StatefulWidget {
  const FiltroPlanosManutencao({super.key});

  @override
  State<FiltroPlanosManutencao> createState() => _FiltroPlanosManutencaoState();
}

class _FiltroPlanosManutencaoState extends State<FiltroPlanosManutencao> {
  String? _tipo;
  late AppState _appState;

  @override
  void initState() {
    super.initState();
    _appState = context.read<AppState>();
    // Inicializar com valores atuais do filtro, se houver
    _tipo = _appState.planosManutencaoFiltro?.tipo;
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
                      'Filtros',
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
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Tipo
                      DropdownButtonFormField<String>(
                        value: _tipo,
                        items: tipoPlanos
                            .map((item) => DropdownMenuItem<String>(
                                  value: item.value,
                                  child: Text(item.label),
                                ))
                            .toList(),
                        onChanged: (value) => setState(() => _tipo = value),
                        style: TextStyle(
                          height: 1.6,
                          color: AppColors.primaryText,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: AppInputDecorations.normal(
                          label: 'Tipo',
                          icon: Icons.category,
                        ),
                      ),
                    ],
                  ),
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
                          _appState.updatePlanosManutencaoFiltro(
                              tipo: null,
                              busca: null,
                              replaceAll: true);
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
                          child: Text('Limpar',
                              style: TextStyle(
                                  color: AppColors.primaryText, fontSize: 14)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Consumer<PlanosViewModel>(
                      builder: (_, vm, __) => Material(
                        elevation: 2,
                        borderRadius: BorderRadius.circular(8.0),
                        child: TextButton(
                          onPressed: vm.isSaving
                              ? null
                              : () async {
                                  _appState.updatePlanosManutencaoFiltro(
                                    tipo: _tipo,
                                  );
                                  Navigator.of(context).pop();
                                },
                          style: ButtonStyle(
                            minimumSize:
                                const WidgetStatePropertyAll(Size(0, 50)),
                            backgroundColor:
                                WidgetStatePropertyAll(AppColors.primary),
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
                                : Text('Aplicar',
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
