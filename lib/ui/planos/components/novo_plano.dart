import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repsys/app_state/app_state.dart';
import 'package:repsys/domain/models/core_planos_checklist_model.dart';
import 'package:repsys/domain/models/menu_item_model.dart';
import 'package:repsys/ui/core/themes/colors.dart';
import 'package:repsys/ui/core/ui/input_decorations.dart';
import 'package:repsys/ui/planos/view_models/planos_viewmodel.dart';
import 'package:repsys/utils/constants.dart';

class NovoPlano extends StatefulWidget {
  const NovoPlano({super.key});

  @override
  State<NovoPlano> createState() => _NovoPlanoState();
}

class _NovoPlanoState extends State<NovoPlano> {
  final _formKey = GlobalKey<FormState>();
  String? _tipoPlano;
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();

  // Lista de grupos de checklist (cada grupo tem uma recorrência e seus itens)
  final List<_ChecklistGroup> _checklistGroups = [];

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    // Dispose dos controllers dos checklists
    for (var group in _checklistGroups) {
      for (var item in group.items) {
        item.tituloController.dispose();
      }
    }
    super.dispose();
  }

  // Retorna as recorrências disponíveis (excluindo as já usadas)
  List<MenuItemModel> _getRecorrenciasDisponiveis() {
    final usadas = _checklistGroups.map((g) => g.recorrencia).toSet();
    return recorrenciaPlanos
        .where((rec) => !usadas.contains(rec.value))
        .toList();
  }

  String _getRecorrenciaLabel(String? value) {
    if (value == null) return '';
    try {
      final item = recorrenciaPlanos.firstWhere(
        (rec) => rec.value == value,
      );
      return item.label;
    } catch (e) {
      return value;
    }
  }

  void _adicionarGrupoChecklist() {
    final disponiveis = _getRecorrenciasDisponiveis();

    if (disponiveis.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Todas as recorrências já foram adicionadas'),
        ),
      );
      return;
    }

    // Mostra modal para selecionar recorrência e adicionar itens
    showDialog(
      context: context,
      builder: (context) => _DialogAdicionarGrupoChecklist(
        recorrenciasDisponiveis: disponiveis,
        onConcluir: (recorrencia, itens) {
          setState(() {
            _checklistGroups.add(_ChecklistGroup(
              recorrencia: recorrencia,
              items: itens,
            ));
          });
        },
      ),
    );
  }

  void _editarGrupoChecklist(int index) {
    final group = _checklistGroups[index];

    // Mostra modal para editar recorrência e itens
    showDialog(
      context: context,
      builder: (context) => _DialogAdicionarGrupoChecklist(
        recorrenciasDisponiveis: [
          ...recorrenciaPlanos.where((rec) => rec.value == group.recorrencia),
          ..._getRecorrenciasDisponiveis(),
        ],
        recorrenciaInicial: group.recorrencia,
        itensIniciais: group.items,
        onConcluir: (recorrencia, itens) {
          setState(() {
            // Dispose dos controllers antigos
            for (var item in _checklistGroups[index].items) {
              item.tituloController.dispose();
            }
            // Substitui o grupo
            _checklistGroups[index] = _ChecklistGroup(
              recorrencia: recorrencia,
              items: itens,
            );
          });
        },
      ),
    );
  }

  void _removerGrupo(int index) {
    setState(() {
      // Dispose dos controllers
      for (var item in _checklistGroups[index].items) {
        item.tituloController.dispose();
      }
      _checklistGroups.removeAt(index);
    });
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
                      'Novo Plano de Manutenção',
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

                /// Formulário para adicionar novo plano
                const SizedBox(height: 16),
                Flexible(
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // === DADOS BÁSICOS ===
                          Text(
                            'Dados Básicos',
                            style: TextStyle(
                              color: AppColors.primaryText,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Linha 1: Tipo e Nome
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: _tipoPlano,
                                  items: tipoPlanos
                                      .map((item) => DropdownMenuItem<String>(
                                            value: item.value,
                                            child: Text(item.label),
                                          ))
                                      .toList(),
                                  onChanged: (value) =>
                                      setState(() => _tipoPlano = value),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Selecione o tipo de plano';
                                    }
                                    return null;
                                  },
                                  style: TextStyle(
                                    height: 1.6,
                                    color: AppColors.primaryText,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  decoration: AppInputDecorations.normal(
                                    label: 'Tipo de Plano',
                                    icon: Icons.category,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  controller: _nomeController,
                                  textCapitalization: TextCapitalization.words,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Informe o nome do plano';
                                    }
                                    return null;
                                  },
                                  decoration: AppInputDecorations.normal(
                                    label: 'Nome',
                                    icon: Icons.label,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Descrição
                          TextFormField(
                            controller: _descricaoController,
                            decoration: AppInputDecorations.normal(
                              label: 'Descrição',
                              icon: Icons.description,
                            ),
                            maxLines: 4,
                          ),
                          const SizedBox(height: 24),

                          // === CHECKLIST ===
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Checklist',
                                style: TextStyle(
                                  color: AppColors.primaryText,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Material(
                                elevation: 2,
                                borderRadius: BorderRadius.circular(8.0),
                                child: TextButton(
                                  onPressed: _adicionarGrupoChecklist,
                                  style: ButtonStyle(
                                    minimumSize: const WidgetStatePropertyAll(
                                        Size(0, 40)),
                                    backgroundColor: WidgetStatePropertyAll(
                                        AppColors.primary),
                                    shape: WidgetStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.add,
                                          color: AppColors.secondary, size: 18),
                                      const SizedBox(width: 6),
                                      Text('Adicionar Grupo',
                                          style: TextStyle(
                                              color: AppColors.secondary,
                                              fontSize: 13)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Lista de grupos de checklist
                          if (_checklistGroups.isEmpty)
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: AppColors.grey1,
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: AppColors.borderColor),
                              ),
                              child: Center(
                                child: Text(
                                  'Nenhum grupo de checklist adicionado',
                                  style: TextStyle(
                                    color: AppColors.secondaryText,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            )
                          else
                            ..._checklistGroups.asMap().entries.map((entry) {
                              final groupIndex = entry.key;
                              final group = entry.value;
                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.grey1,
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      Border.all(color: AppColors.borderColor),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Header do grupo
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.schedule,
                                                color: AppColors.primary,
                                                size: 20),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Recorrência: ${_getRecorrenciaLabel(group.recorrencia)}',
                                              style: TextStyle(
                                                color: AppColors.primaryText,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                              decoration: BoxDecoration(
                                                color: AppColors.primary
                                                    .withValues(alpha: 0.1),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                '${group.items.length} ${group.items.length == 1 ? 'item' : 'itens'}',
                                                style: TextStyle(
                                                  color: AppColors.primary,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              style: ButtonStyle(
                                                padding:
                                                    WidgetStateProperty.all(
                                                        EdgeInsets.all(8)),
                                              ),
                                              icon: Icon(Icons.edit_outlined,
                                                  color: AppColors.primary,
                                                  size: 20),
                                              onPressed: () =>
                                                  _editarGrupoChecklist(
                                                      groupIndex),
                                              padding: EdgeInsets.zero,
                                              constraints:
                                                  const BoxConstraints(),
                                              tooltip: 'Editar grupo',
                                            ),
                                            IconButton(
                                              style: ButtonStyle(
                                                padding:
                                                    WidgetStateProperty.all(
                                                        EdgeInsets.all(8)),
                                              ),
                                              icon: Icon(Icons.delete_outline,
                                                  color: AppColors.error,
                                                  size: 20),
                                              onPressed: () =>
                                                  _removerGrupo(groupIndex),
                                              padding: EdgeInsets.zero,
                                              constraints:
                                                  const BoxConstraints(),
                                              tooltip: 'Excluir grupo',
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    // Lista de itens do grupo
                                    ...group.items
                                        .asMap()
                                        .entries
                                        .map((itemEntry) {
                                      final itemIndex = itemEntry.key;
                                      final item = itemEntry.value;
                                      final titulo =
                                          item.tituloController.text.trim();
                                      if (titulo.isEmpty) {
                                        return const SizedBox.shrink();
                                      }

                                      return Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 12),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: Border.all(
                                              color: AppColors.borderColor),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 24,
                                              height: 24,
                                              decoration: BoxDecoration(
                                                color: AppColors.primary
                                                    .withValues(alpha: 0.1),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '${itemIndex + 1}',
                                                  style: TextStyle(
                                                    color: AppColors.primary,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                titulo,
                                                style: TextStyle(
                                                  color: AppColors.primaryText,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              );
                            }),
                          const SizedBox(height: 24),

                          // === AÇÕES ===
                          Divider(height: 1, color: AppColors.borderColor),
                          const SizedBox(height: 16),
                          Consumer<PlanosViewModel>(
                            builder: (_, vm, __) => Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Material(
                                  elevation: 2,
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: TextButton(
                                    onPressed: vm.isSaving
                                        ? null
                                        : () => Navigator.of(context).pop(),
                                    style: ButtonStyle(
                                      minimumSize: const WidgetStatePropertyAll(
                                          Size(0, 50)),
                                      shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Text('Cancelar',
                                          style: TextStyle(
                                              color: AppColors.primaryText,
                                              fontSize: 14)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Material(
                                  elevation: 2,
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: TextButton(
                                    onPressed: vm.isSaving
                                        ? null
                                        : () async {
                                            if (!_formKey.currentState!
                                                .validate()) {
                                              return;
                                            }

                                            // Validações adicionais
                                            if (_tipoPlano == null ||
                                                _tipoPlano!.isEmpty) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Selecione o tipo de plano'),
                                                  backgroundColor:
                                                      AppColors.error,
                                                ),
                                              );
                                              return;
                                            }

                                            final empresa = appState.empresa;
                                            final usuario = appState.usuario;

                                            if (empresa == null ||
                                                usuario == null) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Erro: Empresa ou usuário não encontrado')),
                                              );
                                              return;
                                            }

                                            // Converter grupos de checklist (agrupa títulos por recorrência)
                                            final checklistsModels =
                                                <CorePlanosChecklistModel>[];
                                            for (var group
                                                in _checklistGroups) {
                                              // Coleta todos os títulos válidos do grupo
                                              final titulos = group.items
                                                  .map((item) => item
                                                      .tituloController.text
                                                      .trim())
                                                  .where((titulo) =>
                                                      titulo.isNotEmpty)
                                                  .toList();

                                              if (titulos.isNotEmpty) {
                                                checklistsModels.add(
                                                    CorePlanosChecklistModel(
                                                  recorrencia:
                                                      group.recorrencia,
                                                  tituloChecklist: titulos,
                                                ));
                                              }
                                            }

                                            final erro = await vm.inserir(
                                              empresaId: empresa.id,
                                              userId: usuario.id,
                                              nome: _nomeController.text,
                                              descricao: _descricaoController
                                                      .text.isEmpty
                                                  ? null
                                                  : _descricaoController.text,
                                              tipoPlano: _tipoPlano!,
                                              checklists: checklistsModels,
                                            );

                                            if (!mounted) return;

                                            if (erro == null) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Plano de manutenção criado com sucesso!')),
                                              );
                                              Navigator.of(context).pop(true);
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(erro),
                                                    backgroundColor:
                                                        AppColors.error),
                                              );
                                            }
                                          },
                                    style: ButtonStyle(
                                      minimumSize: const WidgetStatePropertyAll(
                                          Size(0, 50)),
                                      backgroundColor: WidgetStatePropertyAll(
                                          AppColors.primary),
                                      shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: vm.isSaving
                                          ? const SizedBox(
                                              width: 18,
                                              height: 18,
                                              child: CircularProgressIndicator(
                                                color: AppColors.secondary,
                                              ),
                                            )
                                          : Text('Salvar',
                                              style: TextStyle(
                                                  color: AppColors.secondary,
                                                  fontSize: 14)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Classe auxiliar para grupos de checklist
class _ChecklistGroup {
  final String recorrencia;
  final List<_ChecklistItem> items;

  _ChecklistGroup({
    required this.recorrencia,
    required this.items,
  });
}

// Classe auxiliar para itens de checklist
class _ChecklistItem {
  final TextEditingController tituloController;

  _ChecklistItem() : tituloController = TextEditingController();
}

// Dialog para adicionar/editar grupo de checklist
class _DialogAdicionarGrupoChecklist extends StatefulWidget {
  final List<MenuItemModel> recorrenciasDisponiveis;
  final Function(String recorrencia, List<_ChecklistItem> itens) onConcluir;
  final String? recorrenciaInicial;
  final List<_ChecklistItem>? itensIniciais;

  const _DialogAdicionarGrupoChecklist({
    required this.recorrenciasDisponiveis,
    required this.onConcluir,
    this.recorrenciaInicial,
    this.itensIniciais,
  });

  @override
  State<_DialogAdicionarGrupoChecklist> createState() =>
      _DialogAdicionarGrupoChecklistState();
}

class _DialogAdicionarGrupoChecklistState
    extends State<_DialogAdicionarGrupoChecklist> {
  String? _recorrenciaSelecionada;
  final List<_ChecklistItem> _itens = [];
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _isEditMode =
        widget.recorrenciaInicial != null && widget.itensIniciais != null;
    _recorrenciaSelecionada = widget.recorrenciaInicial;

    if (_isEditMode && widget.itensIniciais != null) {
      // Clona os itens iniciais para não modificar os originais diretamente
      for (var item in widget.itensIniciais!) {
        final newItem = _ChecklistItem();
        newItem.tituloController.text = item.tituloController.text;
        _itens.add(newItem);
      }
    }
  }

  @override
  void dispose() {
    for (var item in _itens) {
      item.tituloController.dispose();
    }
    super.dispose();
  }

  void _adicionarItem() {
    setState(() {
      _itens.add(_ChecklistItem());
    });
  }

  void _removerItem(int index) {
    setState(() {
      _itens[index].tituloController.dispose();
      _itens.removeAt(index);
    });
  }

  void _concluir() {
    if (_recorrenciaSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione uma recorrência'),
        ),
      );
      return;
    }

    // Validar que tem pelo menos um item preenchido
    final itensValidos = _itens
        .where((item) => item.tituloController.text.trim().isNotEmpty)
        .toList();

    if (itensValidos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Adicione pelo menos um item de checklist'),
        ),
      );
      return;
    }

    widget.onConcluir(_recorrenciaSelecionada!, itensValidos);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isRecorrenciaSelecionada = _recorrenciaSelecionada != null;

    return Dialog(
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surface,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _isEditMode
                          ? 'Editar Grupo de Checklist'
                          : 'Adicionar Grupo de Checklist',
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 18,
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

                // Seleção de recorrência
                DropdownButtonFormField<String>(
                  value: _recorrenciaSelecionada,
                  items: widget.recorrenciasDisponiveis
                      .map((rec) => DropdownMenuItem<String>(
                            value: rec.value,
                            child: Text(rec.label),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() {
                    _recorrenciaSelecionada = value;
                  }),
                  style: TextStyle(
                    height: 1.6,
                    color: AppColors.primaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: AppInputDecorations.normal(
                    label: 'Recorrência',
                    icon: Icons.schedule,
                  ),
                ),
                const SizedBox(height: 24),

                // Seção de itens (só aparece após selecionar recorrência)
                if (isRecorrenciaSelecionada) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Itens de Checklist',
                        style: TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Material(
                        elevation: 2,
                        borderRadius: BorderRadius.circular(8.0),
                        child: TextButton(
                          onPressed: _adicionarItem,
                          style: ButtonStyle(
                            minimumSize:
                                const WidgetStatePropertyAll(Size(0, 36)),
                            backgroundColor:
                                WidgetStatePropertyAll(AppColors.primary),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add,
                                  color: AppColors.secondary, size: 16),
                              const SizedBox(width: 4),
                              Text('Adicionar Item',
                                  style: TextStyle(
                                      color: AppColors.secondary,
                                      fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          if (_itens.isEmpty)
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.grey1,
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: AppColors.borderColor),
                              ),
                              child: Center(
                                child: Text(
                                  'Nenhum item adicionado',
                                  style: TextStyle(
                                    color: AppColors.secondaryText,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            )
                          else
                            ..._itens.asMap().entries.map((entry) {
                              final index = entry.key;
                              final item = entry.value;
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      Border.all(color: AppColors.borderColor),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${index + 1}',
                                          style: TextStyle(
                                            color: AppColors.primary,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: TextFormField(
                                        controller: item.tituloController,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        decoration: AppInputDecorations.normal(
                                          label: 'Título do Checklist',
                                          icon: Icons.checklist,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: Icon(Icons.delete_outline,
                                          color: AppColors.error, size: 20),
                                      onPressed: () => _removerItem(index),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                  ],
                                ),
                              );
                            }),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),

                // Ações
                Divider(height: 1, color: AppColors.borderColor),
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
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text('Cancelar',
                              style: TextStyle(
                                  color: AppColors.primaryText, fontSize: 14)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Material(
                      elevation: 2,
                      borderRadius: BorderRadius.circular(8.0),
                      child: TextButton(
                        onPressed: _concluir,
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
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(_isEditMode ? 'Salvar' : 'Concluir',
                              style: TextStyle(
                                  color: AppColors.secondary, fontSize: 14)),
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
