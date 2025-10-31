import 'package:repsys/domain/models/menu_item_model.dart';

final List<String> estados = [
  'AC',
  'AL',
  'AP',
  'AM',
  'BA',
  'CE',
  'DF',
  'ES',
  'GO',
  'MA',
  'MT',
  'MS',
  'MG',
  'PA',
  'PB',
  'PR',
  'PE',
  'PI',
  'RJ',
  'RN',
  'RS',
  'RO',
  'RR',
  'SC',
  'SP',
  'SE',
  'TO',
];

final List<String> tipoCatalogo = [
  'Produto',
  'Serviço',
  'Peça',
  'Equipamento',
  'Acessório',
];

final double desktopWidth = 1024.0;

final List<MenuItemModel> statusAtivos = [
  MenuItemModel(
    label: 'Ativo',
    value: 'ativo',
    description: 'Ativo está operando normalmente em sua função prevista.',
  ),
  MenuItemModel(
    label: 'Em stand-by',
    value: 'stand_by',
    description:
        'Ativo não está em uso no momento, mas está disponível para uso imediato.',
  ),
  MenuItemModel(
    label: 'Sem uso',
    value: 'sem_uso',
    description:
        'Ativo não está em operação e não há previsão imediata de uso.',
  ),
  MenuItemModel(
    label: 'Inoperante',
    value: 'inoperante',
    description:
        'Ativo está com falha ou inutilizável, aguardando manutenção ou descarte.',
  ),
  MenuItemModel(
    label: 'Em Manutenção',
    value: 'em_manutencao',
    description:
        'Ativo está temporariamente fora de operação para reparos oumanutenção.',
  ),
  MenuItemModel(
    label: 'Baixado',
    value: 'baixado',
    description:
        'Ativo foi removido definitivamente do inventário ou desfeito fisicamente',
  ),
  MenuItemModel(
    label: 'Desativado',
    value: 'desativado',
    description:
        'Ativo foi oficialmente retirado de operação, mas ainda está fisicamente presente.',
  ),
];

final List<MenuItemModel> classificacaoAtivos = [
  MenuItemModel(
    label: 'Novo',
    value: 'novo',
    description: 'Nunca foi usado, em perfeitas condições.',
  ),
  MenuItemModel(
    label: 'Excelente',
    value: 'excelente',
    description: 'Em uso, mas com desgaste insignificante; como novo.',
  ),
  MenuItemModel(
    label: 'Bom',
    value: 'bom',
    description:
        'Pequeno desgaste; funcionamento pleno, sem necessidade de reparos.',
  ),
  MenuItemModel(
    label: 'Regular',
    value: 'regular',
    description:
        'Apresenta sinais moderados de desgaste; pode exigir manutenção breve.',
  ),
  MenuItemModel(
    label: 'Ruim',
    value: 'ruim',
    description:
        'Danificado ou com falhas recorrentes; desempenho comprometido.',
  ),
  MenuItemModel(
    label: 'Avariado',
    value: 'avariado',
    description:
        'Não funciona ou oferece riscos; requer substituição imediata.',
  ),
];

final List<MenuItemModel> criticidadeAtivos = [
  MenuItemModel(
    label: 'Alta',
    value: 'alta',
    description:
        'A falha do ativo pode causar paralisação total da operação, acidentes graves, prejuízos financeiros significativos ou impactos ambientais severos.',
  ),
  MenuItemModel(
    label: 'Média',
    value: 'media',
    description:
        'A falha impacta parcialmente a operação, pode gerar custos relevantes, mas há meios de mitigação ou alternativas temporárias.',
  ),
  MenuItemModel(
    label: 'Baixa',
    value: 'baixa',
    description:
        'A falha tem impacto mínimo ou nulo na operação, é de fácil resolução e não afeta a segurança nem o meio ambiente',
  ),
];

final List<MenuItemModel> tipoPlanos = [
  MenuItemModel(
    label: 'Preventivo',
    value: 'preventivo',
    description: 'Plano de manutenção preventiva para prevenir falhas e garantir a segurança e o desempenho do ativo.',
  ),
  MenuItemModel(
    label: 'Corretivo',
    value: 'corretivo',
    description: 'Plano de manutenção corretiva para reparar falhas e restaurar o desempenho do ativo.',
  ),
  MenuItemModel(
    label: 'Preditivo',
    value: 'preditivo',
    description: 'Plano de manutenção preditivo para prever falhas e tomar medidas preventivas antes que ocorram.',
  ),
];

final List<MenuItemModel> recorrenciaPlanos = [
  MenuItemModel(
    label: 'Diário',
    value: 'diario',
    description: 'Plano de manutenção diário para manutenção preventiva regular.',
  ),
  MenuItemModel(
    label: 'Semanal',
    value: 'semanal',
    description: 'Plano de manutenção semanal para manutenção preventiva regular.',
  ),
  MenuItemModel(
    label: 'Mensal',
    value: 'mensal',
    description: 'Plano de manutenção mensal para manutenção preventiva regular.',
  ),
  MenuItemModel(
    label: 'Trimestral',
    value: 'trimestral',
    description: 'Plano de manutenção trimestral para manutenção preventiva regular.',
  ),
  MenuItemModel(
    label: 'Semestral',
    value: 'semestral',
    description: 'Plano de manutenção semestral para manutenção preventiva regular.',
  ),
  MenuItemModel(
    label: 'Anual',
    value: 'anual',
    description: 'Plano de manutenção anual para manutenção preventiva regular.',
  ),
];