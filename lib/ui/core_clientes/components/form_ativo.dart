import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:repsys/app_state/app_state.dart';
import 'package:repsys/data/repositories/core_ativos_repository.dart';
import 'package:repsys/data/repositories/core_at_categorias_repository.dart';
import 'package:repsys/data/repositories/core_planos_manutencao_repository.dart';
import 'package:repsys/domain/models/core_ativos_model.dart';
import 'package:repsys/domain/models/core_at_categorias_model.dart';
import 'package:repsys/domain/models/core_planos_manutencao_model.dart';
import 'package:repsys/ui/core/themes/colors.dart';
import 'package:repsys/ui/core/ui/input_decorations.dart';
import 'package:repsys/utils/constants.dart';
import 'package:repsys/utils/image_helper.dart';

class FormAtivo extends StatefulWidget {
  final String clienteId;
  final CoreAtivosModel? ativo; // null = criar, não null = editar

  const FormAtivo({
    super.key,
    required this.clienteId,
    this.ativo,
  });

  @override
  State<FormAtivo> createState() => _FormAtivoState();
}

class _FormAtivoState extends State<FormAtivo> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _localInstalacaoController = TextEditingController();
  final _numeroSerieController = TextEditingController();
  final _notaFiscalController = TextEditingController();
  final _fornecedorController = TextEditingController();
  
  final _repository = CoreAtivosRepository();
  final _planosRepository = CorePlanosManutencaoRepository();
  final _categoriasRepository = CoreAtCategoriasRepository();
  
  String _status = 'ativo';
  String? _categoriaId;
  String? _planoManutencaoId;
  DateTime? _dataInstalacao;
  DateTime? _dataInicioOperacao;
  DateTime? _garantiaFim;
  
  bool _isLoading = false;
  bool _isLoadingPlanos = true;
  bool _isLoadingCategorias = true;
  List<CorePlanosManutencaoModel> _planosManutencao = [];
  List<CoreAtCategoriasModel> _categorias = [];
  
  // Imagem
  Uint8List? _imagemBytes;
  String? _imagemUrlAtual;

  @override
  void initState() {
    super.initState();
    _carregarPlanos();
    _carregarCategorias();
    
    if (widget.ativo != null) {
      _nomeController.text = widget.ativo!.nome ?? '';
      _localInstalacaoController.text = widget.ativo!.localInstalacao ?? '';
      _categoriaId = widget.ativo!.categoria;
      _numeroSerieController.text = widget.ativo!.numeroSerie ?? '';
      _notaFiscalController.text = widget.ativo!.notaFiscal ?? '';
      _fornecedorController.text = widget.ativo!.fornecedor ?? '';
      _status = widget.ativo!.status ?? 'ativo';
      _planoManutencaoId = widget.ativo!.planoManutencaoId;
      _dataInstalacao = widget.ativo!.dataInstalacao;
      _dataInicioOperacao = widget.ativo!.dataInicioOperacao;
      _garantiaFim = widget.ativo!.garantiaFim;
      _imagemUrlAtual = widget.ativo!.imagemUrl;
    }
  }

  Future<void> _carregarPlanos() async {
    final appState = context.read<AppState>();
    final empresaId = appState.empresa?.id;

    if (empresaId == null) {
      setState(() => _isLoadingPlanos = false);
      return;
    }

    try {
      final planos = await _planosRepository.buscarPorEmpresa(empresaId: empresaId);
      if (mounted) {
        setState(() {
          _planosManutencao = planos;
          _isLoadingPlanos = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingPlanos = false);
      }
    }
  }

  Future<void> _carregarCategorias() async {
    final appState = context.read<AppState>();
    final empresaId = appState.empresa?.id;

    if (empresaId == null) {
      setState(() => _isLoadingCategorias = false);
      return;
    }

    try {
      final categorias = await _categoriasRepository.buscarPorEmpresa(empresaId: empresaId);
      if (mounted) {
        setState(() {
          _categorias = categorias;
          _isLoadingCategorias = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingCategorias = false);
      }
    }
  }

  Future<void> _selecionarImagem() async {
    final ImagePicker picker = ImagePicker();
    
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        final redimensionada = await ImageHelper.redimensionarImagem(bytes);
        
        setState(() {
          _imagemBytes = redimensionada;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao selecionar imagem: $e')),
        );
      }
    }
  }

  Future<void> _removerImagem() async {
    setState(() {
      _imagemBytes = null;
      _imagemUrlAtual = null;
    });
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final appState = context.read<AppState>();
    final empresaId = appState.empresa?.id;
    final userId = appState.usuario?.id;

    if (empresaId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro: Empresa não identificada')),
        );
      }
      setState(() => _isLoading = false);
      return;
    }

    try {
      String? imagemUrl = _imagemUrlAtual;

      // Upload da nova imagem se foi selecionada
      if (_imagemBytes != null) {
        final ativoId = widget.ativo?.id ?? DateTime.now().millisecondsSinceEpoch.toString();
        final extensao = ImageHelper.getExtension('image/jpeg');
        final nomeArquivo = '${DateTime.now().millisecondsSinceEpoch}.$extensao';
        
        imagemUrl = await _repository.uploadImagem(
          empresaId: empresaId,
          ativoId: ativoId,
          imageBytes: _imagemBytes!,
          fileName: nomeArquivo,
        );
      }

      final ativo = CoreAtivosModel(
        id: widget.ativo?.id,
        empresaId: empresaId,
        clienteId: widget.clienteId,
        nome: _nomeController.text.trim(),
        localInstalacao: _localInstalacaoController.text.trim(),
        // tag não é enviado - gerado automaticamente pelo banco
        categoria: _categoriaId,
        status: _status,
        numeroSerie: _numeroSerieController.text.trim(),
        notaFiscal: _notaFiscalController.text.trim(),
        fornecedor: _fornecedorController.text.trim(),
        planoManutencaoId: _planoManutencaoId,
        dataInstalacao: _dataInstalacao,
        dataInicioOperacao: _dataInicioOperacao,
        garantiaFim: _garantiaFim,
        imagemUrl: imagemUrl,
        createdBy: widget.ativo == null ? userId : null,
        updatedBy: widget.ativo != null ? userId : null,
      );

      if (widget.ativo == null) {
        await _repository.inserir(ativo: ativo);
      } else {
        await _repository.atualizar(
          id: widget.ativo!.id!,
          ativo: ativo,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.ativo == null
                  ? 'Ativo adicionado com sucesso!'
                  : 'Ativo atualizado com sucesso!',
            ),
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _localInstalacaoController.dispose();
    _numeroSerieController.dispose();
    _notaFiscalController.dispose();
    _fornecedorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.ativo != null;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Dialog(
      child: Container(
        width: screenWidth > 900 ? 800 : screenWidth * 0.9,
        constraints: const BoxConstraints(maxHeight: 700),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    isEditing ? Icons.edit : Icons.add_box,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isEditing ? 'Editar Ativo' : 'Adicionar Ativo',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.primaryText,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Conteúdo rolável
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Imagem
                      _buildImageSection(),
                      const SizedBox(height: 24),

                      // Nome do Ativo
                      TextFormField(
                        controller: _nomeController,
                        textCapitalization: TextCapitalization.words,
                        decoration: AppInputDecorations.normal(
                          label: 'Nome do Ativo',
                          icon: Icons.devices,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nome é obrigatório';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Categoria e Status
                      Row(
                        children: [
                          Expanded(
                            child: _isLoadingCategorias
                                ? const Center(child: CircularProgressIndicator())
                                : DropdownButtonFormField<String>(
                                    value: _categoriaId,
                                    style: TextStyle(
                                      height: 1.6,
                                      color: AppColors.primaryText,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    decoration: AppInputDecorations.normal(
                                      label: 'Categoria',
                                      icon: Icons.category,
                                    ),
                                    items: _categorias.map((categoria) {
                                      return DropdownMenuItem<String>(
                                        value: categoria.id,
                                        child: Text(categoria.nome ?? 'Sem nome'),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() => _categoriaId = value);
                                    },
                                  ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _status,
                              style: TextStyle(
                                height: 1.6,
                                color: AppColors.primaryText,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: AppInputDecorations.normal(
                                label: 'Status',
                                icon: Icons.info_outline,
                              ),
                              items: statusAtivos.map((status) {
                                return DropdownMenuItem<String>(
                                  value: status.value,
                                  child: Text(status.label),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => _status = value);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Local de Instalação
                      TextFormField(
                        controller: _localInstalacaoController,
                        textCapitalization: TextCapitalization.words,
                        decoration: AppInputDecorations.normal(
                          label: 'Local de Instalação',
                          icon: Icons.location_on,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Número de Série e Nota Fiscal
                      Row(
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
                              controller: _notaFiscalController,
                              decoration: AppInputDecorations.normal(
                                label: 'Nota Fiscal',
                                icon: Icons.receipt,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Fornecedor
                      TextFormField(
                        controller: _fornecedorController,
                        textCapitalization: TextCapitalization.words,
                        decoration: AppInputDecorations.normal(
                          label: 'Fornecedor',
                          icon: Icons.business,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Plano de Manutenção
                      _isLoadingPlanos
                          ? const Center(child: CircularProgressIndicator())
                          : DropdownButtonFormField<String>(
                              value: _planoManutencaoId,
                              style: TextStyle(
                                height: 1.6,
                                color: AppColors.primaryText,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: AppInputDecorations.normal(
                                label: 'Plano de Manutenção',
                                icon: Icons.build,
                              ),
                              hint: const Text('Selecione um plano'),
                              items: [
                                const DropdownMenuItem<String>(
                                  value: null,
                                  child: Text('Nenhum'),
                                ),
                                ..._planosManutencao.map((plano) {
                                  return DropdownMenuItem<String>(
                                    value: plano.id,
                                    child: Text(plano.nome ?? 'Sem nome'),
                                  );
                                }),
                              ],
                              onChanged: (value) {
                                setState(() => _planoManutencaoId = value);
                              },
                            ),
                      const SizedBox(height: 16),

                      // Datas
                      _buildDateFields(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Botões
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancelar',
                      style: TextStyle(color: AppColors.secondaryText),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(8.0),
                    child: TextButton(
                      onPressed: _isLoading ? null : _salvar,
                      style: ButtonStyle(
                        minimumSize: const WidgetStatePropertyAll(Size(0, 50)),
                        backgroundColor: WidgetStatePropertyAll(
                          _isLoading ? AppColors.info.withValues(alpha: 0.6) : AppColors.info,
                        ),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_isLoading)
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          else
                            Icon(Icons.check, color: AppColors.secondary, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            isEditing ? 'Atualizar' : 'Adicionar',
                            style: TextStyle(color: AppColors.secondary, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Foto do Ativo',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderColor),
            ),
          child: _imagemBytes != null
              ? Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(
                        _imagemBytes!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: _removerImagem,
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                )
              : _imagemUrlAtual != null
                  ? Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            _imagemUrlAtual!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(child: Icon(Icons.broken_image, size: 64));
                            },
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: _removerImagem,
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo, size: 48, color: Colors.grey[400]),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: _selecionarImagem,
                            child: const Text('Selecionar Imagem'),
                          ),
                          Text(
                            'Máx: 512px | Qualidade: 70%',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateFields() {
    final dateFormat = DateFormat('dd/MM/yyyy');
    
    return Column(
      children: [
        // Data de Instalação
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _dataInstalacao ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (date != null) {
              setState(() => _dataInstalacao = date);
            }
          },
          child: InputDecorator(
            decoration: AppInputDecorations.normal(
              label: 'Data de Instalação',
              icon: Icons.calendar_today,
            ),
            child: Text(
              _dataInstalacao != null ? dateFormat.format(_dataInstalacao!) : 'Selecione',
              style: TextStyle(
                color: _dataInstalacao != null ? AppColors.primaryText : AppColors.secondaryText,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Data de Início de Operação
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _dataInicioOperacao ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (date != null) {
              setState(() => _dataInicioOperacao = date);
            }
          },
          child: InputDecorator(
            decoration: AppInputDecorations.normal(
              label: 'Data de Início de Operação',
              icon: Icons.play_arrow,
            ),
            child: Text(
              _dataInicioOperacao != null ? dateFormat.format(_dataInicioOperacao!) : 'Selecione',
              style: TextStyle(
                color: _dataInicioOperacao != null ? AppColors.primaryText : AppColors.secondaryText,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Garantia Fim
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _garantiaFim ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (date != null) {
              setState(() => _garantiaFim = date);
            }
          },
          child: InputDecorator(
            decoration: AppInputDecorations.normal(
              label: 'Fim da Garantia',
              icon: Icons.verified_user,
            ),
            child: Text(
              _garantiaFim != null ? dateFormat.format(_garantiaFim!) : 'Selecione',
              style: TextStyle(
                color: _garantiaFim != null ? AppColors.primaryText : AppColors.secondaryText,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

