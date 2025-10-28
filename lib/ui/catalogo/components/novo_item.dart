import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:repsys/app_state/app_state.dart';
import 'package:repsys/ui/catalogo/view_models/catalogo_viewmodel.dart';
import 'package:repsys/ui/core/themes/colors.dart';
import 'package:repsys/ui/core/ui/input_decorations.dart';
import 'package:repsys/ui/core/ui/validators.dart';
import 'package:repsys/utils/constants.dart';

class NovoItem extends StatefulWidget {
  const NovoItem({super.key});

  @override
  State<NovoItem> createState() => _NovoItemState();
}

class _NovoItemState extends State<NovoItem> {
  final _formKey = GlobalKey<FormState>();
  String? _tipo;
  final _quantidadeController = TextEditingController(text: '1');
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _marcaController = TextEditingController();
  final _codigoController = TextEditingController();
  final _numeroSerieController = TextEditingController();
  final _imeiController = TextEditingController();
  final _valorCompraController = TextEditingController();
  final _valorVendaController = TextEditingController();

  @override
  void dispose() {
    _quantidadeController.dispose();
    _nomeController.dispose();
    _descricaoController.dispose();
    _marcaController.dispose();
    _codigoController.dispose();
    _numeroSerieController.dispose();
    _imeiController.dispose();
    _valorCompraController.dispose();
    _valorVendaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();

    return Dialog(

      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surface,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1024),
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
                      'Novo item',
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.close_rounded, color: AppColors.primaryText),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Divider(height: 1, color: AppColors.borderColor),

                /// Formulário para adicionar novo item
                const SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
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
                            ),
                            if (_tipo != 'Serviço' && _tipo != null) ...[
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _quantidadeController,
                                  keyboardType: TextInputType.number,
                                  decoration: AppInputDecorations.normal(
                                    label: 'Quantidade',
                                    icon: Icons.numbers,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _nomeController,
                          textCapitalization: TextCapitalization.words,
                          validator: AppValidators.nome(),
                          decoration: AppInputDecorations.normal(
                            label: 'Nome',
                            icon: Icons.label,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _descricaoController,
                          decoration: AppInputDecorations.normal(
                            label: 'Descrição',
                            icon: Icons.description,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_tipo != null && _tipo != 'Serviço') ...[
                              Expanded(
                                child: TextFormField(
                                  controller: _marcaController,
                                  decoration: AppInputDecorations.normal(
                                    label: 'Marca',
                                    icon: Icons.business,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                            ],
                            Expanded(
                              child: TextFormField(
                                controller: _codigoController,
                                decoration: AppInputDecorations.normal(
                                  label: 'Código',
                                  icon: Icons.qr_code,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (_tipo == 'Equipamento' && _tipo != null) ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _numeroSerieController,
                                  decoration: AppInputDecorations.normal(
                                    label: 'Número de Série',
                                    icon: Icons.confirmation_number,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _imeiController,
                                  decoration: AppInputDecorations.normal(
                                    label: 'Imei',
                                    icon: Icons.smartphone,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _valorCompraController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  CentavosInputFormatter(moeda: true),
                                ],
                                decoration: AppInputDecorations.normal(
                                  label: 'Valor de compra (un)',
                                  icon: Icons.shopping_cart,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _valorVendaController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  CentavosInputFormatter(moeda: true),
                                ],
                                validator: AppValidators.nome(),
                                decoration: AppInputDecorations.normal(
                                  label: 'Valor de venda (un)',
                                  icon: Icons.attach_money,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
                        onPressed: () => Navigator.of(context).pop(),
                        style: ButtonStyle(
                          minimumSize: const WidgetStatePropertyAll(Size(0, 50)),
                          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
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
                                  if (!_formKey.currentState!.validate()) return;

                                  final erro = await vm.inserir(
                                    empresaId:
                                        appState.empresa!.id, 
                                    tipo: _tipo!,
                                    nome: _nomeController.text,
                                    descricao: _descricaoController.text,
                                    codigo: _codigoController.text,
                                    marca: _marcaController.text,
                                    quantidadeTxt: _quantidadeController.text,
                                    valorCompraTxt: _valorCompraController.text,
                                    valorVendaTxt: _valorVendaController.text,
                                    numeroSerie: _numeroSerieController.text,
                                    imei: _imeiController.text,
                                    imagemUrl: null,
                                  );

                                  if (!mounted) return;

                                  if (erro == null) {
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Item inserido com sucesso!'),
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
                                WidgetStatePropertyAll(AppColors.primary),
                            shape: WidgetStateProperty.all<
                                RoundedRectangleBorder>(
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
                                    child:
                                        CircularProgressIndicator(color: AppColors.secondary,),
                                  )
                                : Text('Salvar',
                                    style: TextStyle(
                                        color: AppColors.secondary, fontSize: 14)),
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
