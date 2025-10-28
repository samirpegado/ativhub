import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repsys/app_state/app_state.dart';
import 'package:repsys/ui/clientes/view_models/clientes_viewmodel.dart';
import 'package:repsys/ui/core/themes/colors.dart';
import 'package:repsys/ui/core/ui/input_decorations.dart';
import 'package:repsys/ui/core/ui/validators.dart';
import 'package:repsys/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ClientesFitlro extends StatefulWidget {
  const ClientesFitlro({super.key});

  @override
  State<ClientesFitlro> createState() => _ClientesFitlroState();
}

class _ClientesFitlroState extends State<ClientesFitlro> {
  String? _tipo;
  String? _marca;
  late AppState _appState;
  final _supabase = Supabase.instance.client;
  List<String> _marcas = [];

  @override
  void initState() {
    super.initState();
    _appState = context.read<AppState>();
    _loadMarcas();
    _tipo = _appState.catalogoFiltro?.tipo;
    _marca = _appState.catalogoFiltro?.marca;
  }

  @override
  void dispose() {
    super.dispose();
  }

  // ---------- Chamadas backend ----------
  Future<void> _loadMarcas() async {
    try {
      final raw = await _supabase.rpc('catalogo_marcas', params: {
        'p_empresa_id': _appState.empresa?.id ?? '',
      }) as List<dynamic>;
      final marcas = raw
          .whereType<Map<String, dynamic>>()
          .map((e) => (e['marca'] as String?)?.trim())
          .where((e) => e != null && e.isNotEmpty)
          .cast<String>()
          .toSet()
          .toList()
        ..sort();
      if (!mounted) return;
      setState(() {
        _marcas = marcas;
        // se a marca atual não existir mais na lista, volta pra null
        if (_marca != null && !_marcas.contains(_marca)) {
          _marca = null;
        }
      });
    } catch (e) {
      // se falhar, apenas mantém a lista vazia
    }
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
                      DropdownButtonFormField<String>(
                        validator: AppValidators.nome(),
                        value: _tipo,
                        items: tipoCatalogo
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item),
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
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        validator: AppValidators.nome(),
                        menuMaxHeight: 300,
                        value: _marca,
                        items: _marcas
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item),
                                ))
                            .toList(),
                        onChanged: (value) => setState(() {
                          _marca = value;                          
                        }),
                        style: TextStyle(
                          height: 1.6,
                          color: AppColors.primaryText,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: AppInputDecorations.normal(
                          label: 'Marca',
                          icon: Icons.branding_watermark,
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
                           _appState.updateCatalogoFiltro(
                              marca: null, tipo: null, busca: null,replaceAll: true);
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
                    Consumer<ClientesViewmodel>(
                      builder: (_, vm, __) => Material(
                        elevation: 2,
                        borderRadius: BorderRadius.circular(8.0),
                        child: TextButton(
                          onPressed: vm.isSaving
                              ? null
                              : () async {
                                _appState.updateCatalogoFiltro(
                              marca: _marca, tipo: _tipo);
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
