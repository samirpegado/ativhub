import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:repsys/app_state/app_state.dart';
import 'package:repsys/data/repositories/core_clientes_pessoal_repository.dart';
import 'package:repsys/domain/models/core_clientes_pessoal_model.dart';
import 'package:repsys/ui/core/themes/colors.dart';
import 'package:repsys/ui/core/ui/input_decorations.dart';
import 'package:repsys/ui/core/ui/validators.dart';

class FormResponsavel extends StatefulWidget {
  final String clienteId;
  final CoreClientesPessoalModel? responsavel; // null = criar, não null = editar

  const FormResponsavel({
    super.key,
    required this.clienteId,
    this.responsavel,
  });

  @override
  State<FormResponsavel> createState() => _FormResponsavelState();
}

class _FormResponsavelState extends State<FormResponsavel> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cargoController = TextEditingController();
  final _repository = CoreClientesPessoalRepository();
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.responsavel != null) {
      _nomeController.text = widget.responsavel!.nome ?? '';
      _emailController.text = widget.responsavel!.email ?? '';
      _telefoneController.text = widget.responsavel!.telefone ?? '';
      _cargoController.text = widget.responsavel!.cargo ?? '';
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _cargoController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final appState = context.read<AppState>();
    final empresaId = appState.empresa?.id;

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
      final responsavel = CoreClientesPessoalModel(
        id: widget.responsavel?.id,
        empresaId: empresaId,
        clienteId: widget.clienteId,
        nome: _nomeController.text.trim(),
        email: _emailController.text.trim(),
        telefone: _telefoneController.text.trim(),
        cargo: _cargoController.text.trim(),
      );

      if (widget.responsavel == null) {
        // Criar novo
        await _repository.inserir(responsavel: responsavel);
      } else {
        // Atualizar existente
        await _repository.atualizar(
          id: widget.responsavel!.id!,
          responsavel: responsavel,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.responsavel == null
                  ? 'Responsável adicionado com sucesso!'
                  : 'Responsável atualizado com sucesso!',
            ),
          ),
        );
        Navigator.of(context).pop(true); // Retorna true indicando sucesso
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
  Widget build(BuildContext context) {
    final isEditing = widget.responsavel != null;
    
    return Dialog(
      child: Container(
        width: 500,
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
                    isEditing ? Icons.edit : Icons.person_add,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isEditing ? 'Editar Responsável' : 'Adicionar Responsável',
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

              // Nome
              TextFormField(
                controller: _nomeController,
                textCapitalization: TextCapitalization.words,
                decoration: AppInputDecorations.normal(
                  label: 'Nome completo',
                  icon: Icons.person,
                ),
                validator: AppValidators.nome(),
              ),
              const SizedBox(height: 16),

              // Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: AppInputDecorations.normal(
                  label: 'E-mail',
                  icon: Icons.email,
                ),
                validator: AppValidators.email(),
              ),
              const SizedBox(height: 16),

              // Telefone
              TextFormField(
                controller: _telefoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  TelefoneInputFormatter(),
                ],
                decoration: AppInputDecorations.normal(
                  label: 'Telefone',
                  icon: Icons.phone,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Telefone é obrigatório';
                  }
                  // Remove formatação para validar
                  final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
                  if (digitsOnly.length < 10) {
                    return 'Telefone inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Cargo
              TextFormField(
                controller: _cargoController,
                textCapitalization: TextCapitalization.words,
                decoration: AppInputDecorations.normal(
                  label: 'Cargo',
                  icon: Icons.work,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Cargo é obrigatório';
                  }
                  return null;
                },
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
}

