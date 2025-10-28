import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:repsys/app_state/app_state.dart';
import 'package:repsys/data/repositories/core_at_categorias_repository.dart';
import 'package:repsys/data/repositories/core_ativos_repository.dart';
import 'package:repsys/data/repositories/core_clientes_pessoal_repository.dart';
import 'package:repsys/domain/models/core_ativos_model.dart';
import 'package:repsys/domain/models/core_clientes_model.dart';
import 'package:repsys/domain/models/core_clientes_pessoal_model.dart';
import 'package:repsys/ui/components/base_layout.dart';
import 'package:repsys/ui/core_clientes/components/deletar_ativo.dart';
import 'package:repsys/ui/core_clientes/components/deletar_responsavel.dart';
import 'package:repsys/ui/core_clientes/components/editar_cliente.dart';
import 'package:repsys/ui/core_clientes/components/form_ativo.dart';
import 'package:repsys/ui/core_clientes/components/form_responsavel.dart';
import 'package:repsys/ui/core_clientes/view_models/core_clientes_viewmodel.dart';
import 'package:repsys/ui/core/themes/colors.dart';

class CoreClientesDetalhes extends StatefulWidget {
  const CoreClientesDetalhes({super.key});

  @override
  State<CoreClientesDetalhes> createState() => _CoreClientesDetalhesState();
}

class _CoreClientesDetalhesState extends State<CoreClientesDetalhes> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final cliente = appState.coreClientesModel;
    
    if (cliente == null) {
      return const Scaffold(
        body: Center(child: Text('Cliente não encontrado')),
      );
    }

    final isWide = MediaQuery.of(context).size.width >= 900;

    return BaseLayout(
      child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            // Header fixo com botão voltar e editar
          Row(
            children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 8),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cliente.nome ?? 'Cliente',
                        style: Theme.of(context).textTheme.headlineMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                      ),
                      if (cliente.email != null)
                        Text(
                          cliente.email!,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.secondaryText,
                              ),
                        ),
                    ],
                  ),
                ),
                Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(8.0),
                  child: TextButton.icon(
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (_) => ChangeNotifierProvider(
                          create: (_) => CoreClientesViewModel(),
                          child: EditarCliente(cliente: cliente),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      minimumSize: const WidgetStatePropertyAll(Size(0, 50)),
                      backgroundColor: WidgetStatePropertyAll(AppColors.primary),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    icon: Icon(Icons.edit, color: AppColors.secondary),
                    label: Text(
                      'Editar',
                      style: TextStyle(color: AppColors.secondary, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Conteúdo rolável a partir daqui
            Expanded(
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Cards de informações rápidas
                          if (isWide)
                            _buildInfoCards(cliente)
                          else
                            _buildInfoCardsMobile(cliente),
                          const SizedBox(height: 24),

                          // Tabs
                          TabBar(
                            controller: _tabController,
                            labelColor: AppColors.primary,
                            unselectedLabelColor: AppColors.secondaryText,
                            indicatorColor: AppColors.primary,
                            tabs: const [
                              Tab(text: 'Responsáveis'),
                              Tab(text: 'Ativos'),
                              Tab(text: 'Faturamento'),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    _ResponsaveisTab(clienteId: cliente.id),
                    _AtivosTab(clienteId: cliente.id),
                    _FaturamentoTab(clienteId: cliente.id),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCards(CoreClientesModel cliente) {
    return Row(
      children: [
        Expanded(child: _buildInfoCard('Tipo', cliente.tipo ?? '-', Icons.person_outline)),
        const SizedBox(width: 16),
        Expanded(child: _buildInfoCard('Documento', cliente.documento ?? '-', Icons.description)),
        const SizedBox(width: 16),
        Expanded(child: _buildInfoCard('Telefone', cliente.telefone ?? '-', Icons.phone)),
        const SizedBox(width: 16),
        Expanded(
          child: _buildInfoCard(
            'Status',
            cliente.ativo == true ? 'Ativo' : 'Inativo',
            Icons.check_circle,
            statusColor: cliente.ativo == true ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCardsMobile(CoreClientesModel cliente) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildInfoCard('Tipo', cliente.tipo ?? '-', Icons.person_outline)),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInfoCard(
                'Status',
                cliente.ativo == true ? 'Ativo' : 'Inativo',
                Icons.check_circle,
                statusColor: cliente.ativo == true ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildInfoCard('Documento', cliente.documento ?? '-', Icons.description)),
            const SizedBox(width: 16),
            Expanded(child: _buildInfoCard('Telefone', cliente.telefone ?? '-', Icons.phone)),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon, {Color? statusColor}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
                      children: [
              Icon(icon, size: 20, color: statusColor ?? AppColors.primary),
                        const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.secondaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
                            style: TextStyle(
              fontSize: 16,
              color: statusColor ?? AppColors.primaryText,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// Tab de Responsáveis
class _ResponsaveisTab extends StatefulWidget {
  final String clienteId;
  const _ResponsaveisTab({required this.clienteId});

  @override
  State<_ResponsaveisTab> createState() => _ResponsaveisTabState();
}

class _ResponsaveisTabState extends State<_ResponsaveisTab> {
  final _repository = CoreClientesPessoalRepository();
  List<CoreClientesPessoalModel> _responsaveis = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarResponsaveis();
  }

  String _formatarTelefone(String? telefone) {
    if (telefone == null || telefone.isEmpty) return '';
    // Remove tudo que não é número
    final digitsOnly = telefone.replaceAll(RegExp(r'\D'), '');
    // Aplica a formatação do brasil_fields
    return UtilBrasilFields.obterTelefone(digitsOnly);
  }

  Future<void> _carregarResponsaveis() async {
    setState(() => _isLoading = true);
    
    final appState = context.read<AppState>();
    final empresaId = appState.empresa?.id;

    if (empresaId == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final responsaveis = await _repository.buscarPorCliente(
        empresaId: empresaId,
        clienteId: widget.clienteId,
      );

      if (mounted) {
        setState(() {
          _responsaveis = responsaveis;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar responsáveis: $e')),
        );
      }
    }
  }

  Future<void> _adicionarResponsavel() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => FormResponsavel(clienteId: widget.clienteId),
    );

    if (result == true) {
      _carregarResponsaveis();
    }
  }

  Future<void> _editarResponsavel(CoreClientesPessoalModel responsavel) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => FormResponsavel(
        clienteId: widget.clienteId,
        responsavel: responsavel,
      ),
    );

    if (result == true) {
      _carregarResponsaveis();
    }
  }

  Future<void> _deletarResponsavel(CoreClientesPessoalModel responsavel) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => DeletarResponsavel(responsavel: responsavel),
    );

    if (result == true) {
      _carregarResponsaveis();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // Header com botão adicionar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Responsáveis (${_responsaveis.length})',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(8.0),
              child: TextButton(
                onPressed: _adicionarResponsavel,
                style: ButtonStyle(
                  minimumSize: const WidgetStatePropertyAll(Size(0, 50)),
                  backgroundColor: WidgetStatePropertyAll(AppColors.info),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, color: AppColors.secondary),
                    const SizedBox(width: 8),
                    Text(
                      'Adicionar',
                      style: TextStyle(color: AppColors.secondary, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            ],
          ),
          const SizedBox(height: 16),

        // Lista de responsáveis
          Expanded(
          child: _responsaveis.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'Nenhum responsável cadastrado',
                        style: TextStyle(color: AppColors.secondaryText),
                      ),
                      const SizedBox(height: 16),
                      Material(
                        elevation: 2,
                        borderRadius: BorderRadius.circular(8.0),
                        child: TextButton(
                          onPressed: _adicionarResponsavel,
                          style: ButtonStyle(
                            minimumSize: const WidgetStatePropertyAll(Size(0, 50)),
                            backgroundColor: WidgetStatePropertyAll(AppColors.info),
                            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add, color: AppColors.secondary),
                              const SizedBox(width: 8),
                              Text(
                                'Adicionar primeiro responsável',
                                style: TextStyle(color: AppColors.secondary, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _responsaveis.length,
                  itemBuilder: (context, index) {
                    final resp = _responsaveis[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: AppColors.borderColor),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                          child: Text(
                            (resp.nome?.isNotEmpty == true) ? resp.nome![0].toUpperCase() : '?',
                            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(
                          resp.nome ?? 'Nome não informado',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(resp.cargo ?? ''),
                            const SizedBox(height: 2),
                            if (resp.email?.isNotEmpty == true)
                              Text(
                                resp.email!,
                                style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
                              ),
                            if (resp.telefone?.isNotEmpty == true)
                              Text(
                                _formatarTelefone(resp.telefone),
                                style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
                              ),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert),
                          onSelected: (value) {
                            if (value == 'editar') {
                              _editarResponsavel(resp);
                            } else if (value == 'deletar') {
                              _deletarResponsavel(resp);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(value: 'editar', child: Text('Editar')),
                            const PopupMenuItem(value: 'deletar', child: Text('Deletar')),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

// Tab de Ativos
class _AtivosTab extends StatefulWidget {
  final String clienteId;
  const _AtivosTab({required this.clienteId});

  @override
  State<_AtivosTab> createState() => _AtivosTabState();
}

class _AtivosTabState extends State<_AtivosTab> {
  final _repository = CoreAtivosRepository();
  final _categoriasRepository = CoreAtCategoriasRepository();
  List<CoreAtivosModel> _ativos = [];
  Map<String, String> _categoriasNomes = {}; // ID -> Nome
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarAtivos();
  }

  Future<void> _carregarAtivos() async {
    setState(() => _isLoading = true);
    
    final appState = context.read<AppState>();
    final empresaId = appState.empresa?.id;

    if (empresaId == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      // Carregar categorias primeiro
      final categorias = await _categoriasRepository.buscarPorEmpresa(empresaId: empresaId);
      final categoriasMap = <String, String>{};
      for (var cat in categorias) {
        if (cat.id != null && cat.nome != null) {
          categoriasMap[cat.id!] = cat.nome!;
        }
      }

      // Carregar ativos
      final ativos = await _repository.buscarPorCliente(
        empresaId: empresaId,
        clienteId: widget.clienteId,
      );

      if (mounted) {
        setState(() {
          _categoriasNomes = categoriasMap;
          _ativos = ativos;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar ativos: $e')),
        );
      }
    }
  }

  Future<void> _adicionarAtivo() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => FormAtivo(clienteId: widget.clienteId),
    );

    if (result == true) {
      _carregarAtivos();
    }
  }

  Future<void> _editarAtivo(CoreAtivosModel ativo) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => FormAtivo(
        clienteId: widget.clienteId,
        ativo: ativo,
      ),
    );

    if (result == true) {
      _carregarAtivos();
    }
  }

  Future<void> _deletarAtivo(CoreAtivosModel ativo) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => DeletarAtivo(ativo: ativo),
    );

    if (result == true) {
      _carregarAtivos();
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'ativo':
        return Colors.green;
      case 'em_manutencao':
        return Colors.orange;
      case 'inativo':
      case 'baixado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // Header com botão adicionar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Ativos (${_ativos.length})',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(8.0),
              child: TextButton(
                onPressed: _adicionarAtivo,
                style: ButtonStyle(
                  minimumSize: const WidgetStatePropertyAll(Size(0, 50)),
                  backgroundColor: WidgetStatePropertyAll(AppColors.info),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, color: AppColors.secondary),
                    const SizedBox(width: 8),
                    Text(
                      'Adicionar',
                      style: TextStyle(color: AppColors.secondary, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Lista de ativos
        Expanded(
          child: _ativos.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.devices_other, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'Nenhum ativo cadastrado',
                        style: TextStyle(color: AppColors.secondaryText),
                      ),
                      const SizedBox(height: 16),
                      Material(
                        elevation: 2,
                        borderRadius: BorderRadius.circular(8.0),
                        child: TextButton(
                          onPressed: _adicionarAtivo,
                          style: ButtonStyle(
                            minimumSize: const WidgetStatePropertyAll(Size(0, 50)),
                            backgroundColor: WidgetStatePropertyAll(AppColors.info),
                            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add, color: AppColors.secondary),
                              const SizedBox(width: 8),
                              Text(
                                'Adicionar primeiro ativo',
                                style: TextStyle(color: AppColors.secondary, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _ativos.length,
                  itemBuilder: (context, index) {
                    final ativo = _ativos[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: AppColors.borderColor),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: ativo.imagemUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  ativo.imagemUrl!,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(Icons.devices, color: AppColors.primary),
                                    );
                                  },
                                ),
                              )
                            : Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(Icons.devices, color: AppColors.primary),
                              ),
                        title: Text(
                          ativo.nome ?? 'Nome não informado',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('Tag: ${ativo.tag ?? '-'}'),
                            if (ativo.categoria != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                'Categoria: ${_categoriasNomes[ativo.categoria] ?? '-'}',
                                style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
                              ),
                            ],
                            if (ativo.numeroSerie != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                'S/N: ${ativo.numeroSerie}',
                                style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
                              ),
                            ],
                            if (ativo.dataInstalacao != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                'Instalação: ${DateFormat('dd/MM/yyyy').format(ativo.dataInstalacao!)}',
                                style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
                              ),
                            ],
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getStatusColor(ativo.status ?? 'ativo').withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                ativo.getStatusLabel(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _getStatusColor(ativo.status ?? 'ativo'),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert),
                          onSelected: (value) {
                            if (value == 'editar') {
                              _editarAtivo(ativo);
                            } else if (value == 'deletar') {
                              _deletarAtivo(ativo);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(value: 'editar', child: Text('Editar')),
                            const PopupMenuItem(value: 'deletar', child: Text('Deletar')),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

// Tab de Faturamento
class _FaturamentoTab extends StatelessWidget {
  final String clienteId;
  const _FaturamentoTab({required this.clienteId});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pago':
        return Colors.green;
      case 'Pendente':
        return Colors.orange;
      case 'Atrasado':
        return Colors.red;
      case 'Cancelado':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Dados mockados
    final faturas = [
      {
        'id': '1',
        'numero': 'FAT-2024-001',
        'valor': 1500.00,
        'dataEmissao': DateTime(2024, 1, 1),
        'dataVencimento': DateTime(2024, 1, 15),
        'status': 'Pago',
        'dataPagamento': DateTime(2024, 1, 10),
      },
      {
        'id': '2',
        'numero': 'FAT-2024-002',
        'valor': 1500.00,
        'dataEmissao': DateTime(2024, 2, 1),
        'dataVencimento': DateTime(2024, 2, 15),
        'status': 'Pago',
        'dataPagamento': DateTime(2024, 2, 12),
      },
      {
        'id': '3',
        'numero': 'FAT-2024-003',
        'valor': 1500.00,
        'dataEmissao': DateTime(2024, 3, 1),
        'dataVencimento': DateTime(2024, 3, 15),
        'status': 'Pendente',
      },
    ];

    final valorTotal = faturas.fold<double>(0, (sum, fat) => sum + (fat['valor'] as double));
    final faturasPagas = faturas.where((f) => f['status'] == 'Pago').length;

    return Column(
      children: [
        // Resumo
        Row(
          children: [
            Expanded(
              child: _buildResumoCard(
                context,
                'Total Faturado',
                'R\$ ${valorTotal.toStringAsFixed(2)}',
                Icons.attach_money,
                Colors.green,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildResumoCard(
                context,
                'Faturas Pagas',
                '$faturasPagas de ${faturas.length}',
                Icons.check_circle,
                Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Últimas Faturas',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ver todas em desenvolvimento')),
                );
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Ver todas'),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Lista de faturas
        Expanded(
          child: ListView.builder(
            itemCount: faturas.length,
            itemBuilder: (context, index) {
              final fatura = faturas[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: AppColors.borderColor),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getStatusColor(fatura['status'] as String).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.receipt_long,
                      color: _getStatusColor(fatura['status'] as String),
                    ),
                  ),
                  title: Text(
                    fatura['numero'] as String,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        'Vencimento: ${DateFormat('dd/MM/yyyy').format(fatura['dataVencimento'] as DateTime)}',
                      ),
                      if (fatura['dataPagamento'] != null)
                        Text(
                          'Pago em: ${DateFormat('dd/MM/yyyy').format(fatura['dataPagamento'] as DateTime)}',
                          style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
                        ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(fatura['status'] as String).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          fatura['status'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: _getStatusColor(fatura['status'] as String),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'R\$ ${(fatura['valor'] as double).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildResumoCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
