-- Índice único para impedir duplicata de recorrência por plano
create unique index if not exists ux_core_planos_checklist_plano_rec
on public.core_planos_checklist (plano_manutencao_id, recorrencia);

drop function if exists public.create_default_plans(uuid);

create or replace function public.create_default_plans(p_empresa_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_plan_id uuid;
  v_exists uuid;
begin
  ----------------------------------------------------------
  -- Helper: obtém (ou cria) um plano por empresa + nome
  -- Uso:  SELECT id INTO v_exists FROM core_planos_manutencao
  --       WHERE empresa_id=p_empresa_id AND nome='...' LIMIT 1;
  --       IF v_exists IS NULL THEN INSERT ... RETURNING id INTO v_plan_id;
  --       ELSE v_plan_id := v_exists;
  ----------------------------------------------------------

  ----------------------------------------------------------------------
  -- 1) GERADOR DE ENERGIA
  ----------------------------------------------------------------------
  select id into v_exists
  from core_planos_manutencao
  where empresa_id = p_empresa_id and nome = 'Gerador de Energia'
  limit 1;

  if v_exists is null then
    insert into core_planos_manutencao
      (empresa_id, nome, descricao, tipo_plano, created_by, updated_by)
    values
      (p_empresa_id, 'Gerador de Energia',
       'Plano preventivo do grupo gerador, abrangendo verificações diárias a anuais (óleo, combustível, arrefecimento, partida, carga e segurança).',
       'preventivo', 'system', 'system')
    returning id into v_plan_id;
  else v_plan_id := v_exists; end if;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id, 'diaria', ARRAY[
    'Verificar nível de óleo lubrificante',
    'Verificar nível de combustível',
    'Verificar nível de água no radiador',
    'Verificar ausência de vazamentos',
    'Verificar painel de controle e luzes de alerta'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id, 'semanal', ARRAY[
    'Testar partida em vazio (10–15 min)',
    'Verificar tensão e frequência de saída'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id, 'mensal', ARRAY[
    'Inspecionar correias e conexões elétricas',
    'Limpar/verificar filtro de ar',
    'Verificar estado de bateria e terminais'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id, 'trimestral', ARRAY[
    'Trocar óleo (se aplicável, por horas de uso)',
    'Trocar filtro de óleo',
    'Reapertar conexões elétricas'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id, 'semestral', ARRAY[
    'Limpar/verificar sistema de arrefecimento',
    'Verificar alinhamento e vibração',
    'Testar sistema de proteção automática'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id, 'anual', ARRAY[
    'Trocar filtro de combustível',
    'Inspecionar bicos injetores (se aplicável)',
    'Teste completo em carga (simulado)',
    'Revisão geral do grupo gerador'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  ----------------------------------------------------------------------
  -- 2) AR-CONDICIONADO SPLIT
  ----------------------------------------------------------------------
  select id into v_exists
  from core_planos_manutencao
  where empresa_id = p_empresa_id and nome = 'Ar-Condicionado Split'
  limit 1;

  if v_exists is null then
    insert into core_planos_manutencao
      (empresa_id, nome, descricao, tipo_plano, created_by, updated_by)
    values
      (p_empresa_id, 'Ar-Condicionado Split',
       'Plano preventivo para sistemas Split: limpeza de filtros/serpentinas, verificações elétricas, vibração e carga de gás.',
       'preventivo', 'system', 'system')
    returning id into v_plan_id;
  else v_plan_id := v_exists; end if;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id, 'mensal', ARRAY[
    'Verificar funcionamento geral',
    'Limpar filtro da evaporadora',
    'Verificar controle remoto e ajustes'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id, 'trimestral', ARRAY[
    'Limpar/substituir filtro conforme necessidade',
    'Verificar ruído e vibrações',
    'Verificar aletas/sensores',
    'Inspecionar condensadora',
    'Limpar serpentinas (se necessário)'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id, 'semestral', ARRAY[
    'Limpeza completa unidade interna/externa',
    'Reapertar conexões elétricas',
    'Limpar dreno e bandeja',
    'Verificar corrente e tensão'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id, 'anual', ARRAY[
    'Verificar carga de gás e pressões',
    'Teste de estanqueidade',
    'Revisão geral do sistema',
    'Atualizar etiquetas de manutenção'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  ----------------------------------------------------------------------
  -- 3) AR-CONDICIONADO CASSETE
  ----------------------------------------------------------------------
  select id into v_exists from core_planos_manutencao
  where empresa_id=p_empresa_id and nome='Ar-Condicionado Cassete' limit 1;

  if v_exists is null then
    insert into core_planos_manutencao (empresa_id, nome, descricao, tipo_plano, created_by, updated_by)
    values (p_empresa_id, 'Ar-Condicionado Cassete',
            'Plano preventivo para AC Cassete: filtros, serpentinas, dreno, vibração, conexões elétricas e testes elétricos.',
            'preventivo','system','system')
    returning id into v_plan_id;
  else v_plan_id := v_exists; end if;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'mensal', ARRAY[
    'Verificar funcionamento geral',
    'Verificar temperaturas de insuflamento/retorno',
    'Limpar filtros da evaporadora',
    'Verificar modos de operação/controle'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'trimestral', ARRAY[
    'Limpar grades de insuflamento e retorno',
    'Limpar serpentinas (evaporadora/condensadora)',
    'Desobstruir dreno/bandeja',
    'Checar ruído/vibração/fixações',
    'Verificar conexões elétricas'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'semestral', ARRAY[
    'Testar corrente e tensão',
    'Verificar motores/ventiladores/turbinas',
    'Verificar sensores/termostato',
    'Lubrificar (se aplicável)'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'anual', ARRAY[
    'Verificar carga/pressão do gás',
    'Teste de estanqueidade',
    'Inspecionar condensadora externa',
    'Revisão geral do sistema'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  ----------------------------------------------------------------------
  -- 4) AR-CONDICIONADO PISO-TETO
  ----------------------------------------------------------------------
  select id into v_exists from core_planos_manutencao
  where empresa_id=p_empresa_id and nome='Ar-Condicionado Piso-Teto' limit 1;

  if v_exists is null then
    insert into core_planos_manutencao (empresa_id, nome, descricao, tipo_plano, created_by, updated_by)
    values (p_empresa_id, 'Ar-Condicionado Piso-Teto',
            'Plano preventivo para AC Piso-Teto: filtros, serpentinas, dreno, vibração, conexões elétricas e medições.',
            'preventivo','system','system')
    returning id into v_plan_id;
  else v_plan_id := v_exists; end if;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'mensal', ARRAY[
    'Verificar funcionamento geral',
    'Limpar filtros da evaporadora',
    'Verificar controle/display',
    'Checar bloqueio de saídas de ar'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'trimestral', ARRAY[
    'Limpar grades de insuflamento/retorno',
    'Limpar serpentinas (evap/cond)',
    'Limpar bandeja e dreno',
    'Checar fixações, vibração e ruído',
    'Reapertar conexões elétricas'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'semestral', ARRAY[
    'Verificar tensão e corrente',
    'Verificar sensores/termostato',
    'Avaliar ventiladores e motores (lubrificar se aplicável)',
    'Avaliar consumo x desempenho'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'anual', ARRAY[
    'Verificar pressões e carga de gás',
    'Teste de estanqueidade',
    'Inspecionar condensadora',
    'Revisão geral do sistema'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  ----------------------------------------------------------------------
  -- 5) AR-CONDICIONADO SELF-CONTAINED
  ----------------------------------------------------------------------
  select id into v_exists from core_planos_manutencao
  where empresa_id=p_empresa_id and nome='Ar-Condicionado Self-Contained' limit 1;

  if v_exists is null then
    insert into core_planos_manutencao (empresa_id, nome, descricao, tipo_plano, created_by, updated_by)
    values (p_empresa_id, 'Ar-Condicionado Self-Contained',
            'Plano preventivo para unidades self-contained: filtros, serpentinas, drenos, pressões, conexões elétricas e eficiência.',
            'preventivo','system','system')
    returning id into v_plan_id;
  else v_plan_id := v_exists; end if;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'mensal', ARRAY[
    'Verificar funcionamento geral',
    'Verificar/limpar filtros de ar',
    'Verificar nível de ruído e vibração',
    'Checar painel/termostatos'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'trimestral', ARRAY[
    'Verificar serpentinas de evaporação/condensação',
    'Limpar bandeja e dreno',
    'Verificar tubulações de gás e isolamentos',
    'Checar motores/ventiladores (lubrificar se aplicável)'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'semestral', ARRAY[
    'Reapertar conexões elétricas',
    'Medições de corrente/tensão/fator de potência',
    'Verificar pressostatos/termostatos de segurança',
    'Avaliar eficiência e consumo',
    'Limpar condensador a água (se aplicável)'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'anual', ARRAY[
    'Testar pressão do gás',
    'Teste de estanqueidade',
    'Revisão geral (filtros, tubulações, comandos, painéis)',
    'Atualizar etiquetas/relatórios'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  ----------------------------------------------------------------------
  -- 6) CHILLER
  ----------------------------------------------------------------------
  select id into v_exists from core_planos_manutencao
  where empresa_id=p_empresa_id and nome='Chiller' limit 1;

  if v_exists is null then
    insert into core_planos_manutencao (empresa_id, nome, descricao, tipo_plano, created_by, updated_by)
    values (p_empresa_id, 'Chiller',
            'Plano preventivo para chillers: pressões/temperaturas, bombas, pressões do refrigerante, sensores, válvulas, isolamento e testes de desempenho.',
            'preventivo','system','system')
    returning id into v_plan_id;
  else v_plan_id := v_exists; end if;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'diaria', ARRAY[
    'Verificar pressão/temperatura de água gelada (entrada/saída)',
    'Checar nível de óleo e pressões (sucção/descarga)',
    'Verificar alarmes/mensagens no painel'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'semanal', ARRAY[
    'Verificar funcionamento de bombas e válvulas automáticas',
    'Verificar ruídos/vibrações anormais'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'mensal', ARRAY[
    'Registrar pressões de operação do refrigerante',
    'Verificar corrente dos compressores',
    'Limpar filtros de linha de água',
    'Testar sensores de temperatura/fluxo/pressão'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'trimestral', ARRAY[
    'Verificar funcionamento dos compressores (tempo/ciclos)',
    'Testar válvulas de expansão/controle',
    'Calibrar instrumentos de medição',
    'Inspecionar isolamento térmico das tubulações'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'semestral', ARRAY[
    'Verificar estanqueidade do sistema',
    'Limpar serpentinas da condensadora (air-cooled)',
    'Teste de desempenho (ΔT e capacidade)',
    'Limpar/desobstruir trocadores de calor'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'anual', ARRAY[
    'Análise de óleo (viscosidade, acidez, umidade)',
    'Análise de água (corrosão, incrustação, pH, condutividade)',
    'Revisão do sistema elétrico/proteções',
    'Atualização de firmware do controlador (se aplicável)'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  ----------------------------------------------------------------------
  -- 7) FAN COIL
  ----------------------------------------------------------------------
  select id into v_exists from core_planos_manutencao
  where empresa_id=p_empresa_id and nome='Fan Coil' limit 1;

  if v_exists is null then
    insert into core_planos_manutencao (empresa_id, nome, descricao, tipo_plano, created_by, updated_by)
    values (p_empresa_id, 'Fan Coil',
            'Plano preventivo para fan coils: filtros, bandeja/dreno, serpentinas, conexões elétricas, válvulas e sensores.',
            'preventivo','system','system')
    returning id into v_plan_id;
  else v_plan_id := v_exists; end if;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'mensal', ARRAY[
    'Verificar unidade (ventilador, válvulas, sensores)',
    'Limpar/substituir filtros de ar',
    'Verificar controle de temperatura/termostato',
    'Verificar ruídos/vibrações',
    'Verificar bandeja de condensado e dreno'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'trimestral', ARRAY[
    'Limpar serpentinas de troca térmica',
    'Reapertar conexões elétrica/borne',
    'Verificar rolamentos/eixo/alinhamento do ventilador',
    'Verificar válvula de controle de água gelada'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'semestral', ARRAY[
    'Higienizar bandeja de condensado (bactericida/fungicida)',
    'Testar sensores/válvulas/atuadores',
    'Inspecionar isolamento térmico',
    'Verificar vazamentos hidráulicos'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'anual', ARRAY[
    'Inspeção geral da unidade',
    'Checar condição do motor (corrente/isolamento/aquecimento)',
    'Revisar damper/controle de vazão',
    'Balanceamento de ar (se aplicável)'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  ----------------------------------------------------------------------
  -- 8) ELEVADORES
  ----------------------------------------------------------------------
  select id into v_exists from core_planos_manutencao
  where empresa_id=p_empresa_id and nome='Elevadores' limit 1;

  if v_exists is null then
    insert into core_planos_manutencao (empresa_id, nome, descricao, tipo_plano, created_by, updated_by)
    values (p_empresa_id, 'Elevadores',
            'Plano preventivo para elevadores: comandos, freios, lubrificação, contatores, resgate, segurança, revisão e testes anuais.',
            'preventivo','system','system')
    returning id into v_plan_id;
  else v_plan_id := v_exists; end if;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'mensal', ARRAY[
    'Testar comandos/botoeiras',
    'Inspecionar freios/travas/sistemas de parada',
    'Verificar nível/condição do óleo do redutor (se aplicável)',
    'Limpeza de casa de máquinas/quadro/motor',
    'Nivelamento e precisão de parada',
    'Portas: sensores/alinhamento/fechamento',
    'Alarme/interfone/luz de emergência',
    'Desgaste de cabos e guias',
    'Lubrificação trilhos/cabos/roldanas'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'trimestral', ARRAY[
    'Verificar contatos elétricos e reapertos',
    'Testar sistema de emergência (bateria/resgate)',
    'Checar limitadores de velocidade e amortecedores',
    'Avaliar motor e inversor de frequência'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'semestral', ARRAY[
    'Inspecionar cabos de tração (paquímetro/visual)',
    'Analisar desgaste de trilhos e guias',
    'Verificar aterramento e dispositivos de proteção',
    'Avaliar desempenho do sistema de frenagem'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'anual', ARRAY[
    'Revisão de máquina de tração/motor/redutor',
    'Teste de paraquedas e limitador de velocidade',
    'Teste de carga',
    'Atualizar sinalizações e documentos'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  ----------------------------------------------------------------------
  -- 9) PLATAFORMA DE ACESSO
  ----------------------------------------------------------------------
  select id into v_exists from core_planos_manutencao
  where empresa_id=p_empresa_id and nome='Plataforma de Acesso' limit 1;

  if v_exists is null then
    insert into core_planos_manutencao (empresa_id, nome, descricao, tipo_plano, created_by, updated_by)
    values (p_empresa_id, 'Plataforma de Acesso',
            'Plano preventivo para plataformas elevatórias: comandos, hidráulico, segurança, fixações, sensores e testes sob carga.',
            'preventivo','system','system')
    returning id into v_plan_id;
  else v_plan_id := v_exists; end if;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'diaria', ARRAY[
    'Testar comandos (subida/descida/emergência)',
    'Inspeção visual de vazamentos hidráulicos',
    'Verificar obstruções no percurso',
    'Checar baterias e carga (se elétrica)'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'mensal', ARRAY[
    'Reapertar fixações mecânicas e conexões elétricas',
    'Inspecionar cabos/correntes/parafusos de elevação',
    'Testar fins de curso e sensores de segurança',
    'Verificar pneus/rodas/trilhos (se aplicável)',
    'Lubrificar pontos móveis'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'trimestral', ARRAY[
    'Limpar/inspecionar painéis e botoeiras/joystick',
    'Testar freio e parada de emergência',
    'Testar dispositivos antiesmagamento/nivelamento',
    'Verificar nível de óleo hidráulico',
    'Inspecionar corrosão ou trincas estruturais'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'semestral', ARRAY[
    'Teste funcional com carga nominal',
    'Testar resistência de isolamento elétrico',
    'Verificar estado de bateria/carregador (se elétrica)'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'anual', ARRAY[
    'Revisão geral de estrutura, circuitos e dispositivos',
    'Atualizar etiquetas e laudo técnico/ART (se exigido)',
    'Verificar conformidade com normas de acessibilidade'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  ----------------------------------------------------------------------
  -- 10) QUADRO DE FORÇA E LUZ
  ----------------------------------------------------------------------
  select id into v_exists from core_planos_manutencao
  where empresa_id=p_empresa_id and nome='Quadro de Força e Luz' limit 1;

  if v_exists is null then
    insert into core_planos_manutencao (empresa_id, nome, descricao, tipo_plano, created_by, updated_by)
    values (p_empresa_id, 'Quadro de Força e Luz',
            'Plano preventivo para QFL: aquecimento, limpeza, reaperto, medições, termografia, DR/DPS e revisão anual.',
            'preventivo','system','system')
    returning id into v_plan_id;
  else v_plan_id := v_exists; end if;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'mensal', ARRAY[
    'Checar sobreaquecimento em disjuntores/barramentos/cabos',
    'Cheiros/faíscas/ruídos anormais',
    'Acesso desobstruído e seguro'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'trimestral', ARRAY[
    'Limpeza superficial com aspirador/pincel antiestático (sem energizar)',
    'Testar disjuntores (liga/desliga)',
    'Verificar fixação de cabos/barramentos',
    'Conferir identificação/sinalização de circuitos'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'semestral', ARRAY[
    'Medições de tensão/corrente (análise de carga)',
    'Termografia',
    'Testar DR e DPS (se aplicáveis)',
    'Reaperto de bornes e conexões (desenergizado)'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'anual', ARRAY[
    'Revisão geral do quadro (estrutura e integridade)',
    'Atualizar diagramas unifilares/etiquetas',
    'Emitir relatório técnico com evidências'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  ----------------------------------------------------------------------
  -- 11) QUADRO DE COMANDO DE BOMBAS
  ----------------------------------------------------------------------
  select id into v_exists from core_planos_manutencao
  where empresa_id=p_empresa_id and nome='Quadro de Comando de Bombas' limit 1;

  if v_exists is null then
    insert into core_planos_manutencao (empresa_id, nome, descricao, tipo_plano, created_by, updated_by)
    values (p_empresa_id, 'Quadro de Comando de Bombas',
            'Plano preventivo para QCB: sinalização, limpeza, conexões, medições, proteções, lógica de partida e inspeções térmicas.',
            'preventivo','system','system')
    returning id into v_plan_id;
  else v_plan_id := v_exists; end if;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'mensal', ARRAY[
    'Verificar sinalização do painel (LEDs/Alarmes/Status)',
    'Cheiros/ruídos/aquecimentos anormais',
    'Limpeza externa/interna (sem energizar)',
    'Testar comutação de contatores/relés'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'trimestral', ARRAY[
    'Reapertar conexões elétricas',
    'Medir tensões e consumo dos motores',
    'Testar proteções térmicas/relés de sobrecarga',
    'Validar temporizações e lógica (manual/automático)'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'semestral', ARRAY[
    'Inspeção termográfica em cabos/componentes',
    'Atualizar etiquetas e diagramas elétricos',
    'Teste completo de sequência de partida/parada',
    'Verificar sinais de umidade/oxidação no painel'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'anual', ARRAY[
    'Revisão geral de disjuntores/contatores/relés/fontes/bornes',
    'Teste com carga real (acionar bomba)',
    'Revisar parâmetros de inversor/soft-starter (se aplicável)'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  ----------------------------------------------------------------------
  -- 12) BOMBA DE ÁGUA
  ----------------------------------------------------------------------
  select id into v_exists from core_planos_manutencao
  where empresa_id=p_empresa_id and nome='Bomba de Água' limit 1;

  if v_exists is null then
    insert into core_planos_manutencao (empresa_id, nome, descricao, tipo_plano, created_by, updated_by)
    values (p_empresa_id, 'Bomba de Água',
            'Plano preventivo para bombas: vibração, vazão/pressão, selos, alinhamento, consumo elétrico, limpeza e revisão anual.',
            'preventivo','system','system')
    returning id into v_plan_id;
  else v_plan_id := v_exists; end if;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'diaria', ARRAY[
    'Observar ruídos/vibrações anormais',
    'Observar pressão e vazão (se houver instrumentos)',
    'Checar vazamentos de água/óleo'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'mensal', ARRAY[
    'Apertar parafusos de base/acoplamento',
    'Verificar alinhamento bomba-motor',
    'Limpar crivo de sucção (se aplicável)',
    'Inspecionar selos/gaxetas',
    'Medir amperagem e tensão do motor',
    'Lubrificar mancais/rolamentos (conforme manual)'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'trimestral', ARRAY[
    'Inspecionar tubulação e válvulas',
    'Testar partida manual e automática',
    'Verificar estado de pintura/proteção anticorrosiva'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'semestral', ARRAY[
    'Limpeza geral da bomba e base',
    'Verificar folgas axial/radial dos eixos',
    'Analisar nível/qualidade do óleo (se aplicável)',
    'Testar sistema de partida (soft-starter/inversor/contator)'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'anual', ARRAY[
    'Desmontagem parcial para inspeção interna',
    'Substituir componentes de desgaste',
    'Alinhamento preciso (relógio/laser)',
    'Recondicionamento geral (se necessário)'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  ----------------------------------------------------------------------
  -- 13) CIVIL (EDIFICAÇÕES)
  ----------------------------------------------------------------------
  select id into v_exists from core_planos_manutencao
  where empresa_id=p_empresa_id and nome='Civil (Edificações)' limit 1;

  if v_exists is null then
    insert into core_planos_manutencao (empresa_id, nome, descricao, tipo_plano, created_by, updated_by)
    values (p_empresa_id, 'Civil (Edificações)',
            'Plano preventivo civil: inspeções estruturais/vedações, pisos, escadas, calhas, fachadas, impermeabilização e relatórios.',
            'preventivo','system','system')
    returning id into v_plan_id;
  else v_plan_id := v_exists; end if;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'mensal', ARRAY[
    'Inspecionar rachaduras/infiltrações em paredes/lajes',
    'Verificar desníveis e trincas em pisos',
    'Revisar travas/fechos/dobradiças',
    'Testar grelhas/ralos'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'trimestral', ARRAY[
    'Inspecionar rejuntes de pisos e revestimentos',
    'Verificar vedação de caixilhos',
    'Avaliar escadas/corrimãos/guarda-corpos',
    'Limpeza de calhas/condutores/telhados acessíveis'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'semestral', ARRAY[
    'Inspeção de fachadas/revestimentos',
    'Verificar trincas em vigas/pilares/lajes',
    'Avaliar impermeabilizações (lajes/terraços/marquises)',
    'Revisão de muros/alambrados'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'anual', ARRAY[
    'Revisão de telhados e coberturas',
    'Vistoria estrutural da edificação',
    'Avaliação de pintura externa/interna',
    'Verificação de acessibilidade e sinalização de emergência',
    'Inspeção de áreas comuns (garagem, escadas etc.)'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  ----------------------------------------------------------------------
  -- 14) HIDRÁULICO PREDIAL
  ----------------------------------------------------------------------
  select id into v_exists from core_planos_manutencao
  where empresa_id=p_empresa_id and nome='Hidráulico Predial' limit 1;

  if v_exists is null then
    insert into core_planos_manutencao (empresa_id, nome, descricao, tipo_plano, created_by, updated_by)
    values (p_empresa_id, 'Hidráulico Predial',
            'Plano preventivo hidráulico: vazamentos, registros, bombas, pressões, sifões e limpeza de reservatórios com certificação.',
            'preventivo','system','system')
    returning id into v_plan_id;
  else v_plan_id := v_exists; end if;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'mensal', ARRAY[
    'Verificar vazamentos visíveis',
    'Testar válvulas de retenção/manobra',
    'Verificar funcionamento de bombas',
    'Conferir pressão em pontos de consumo',
    'Checar entupimentos (ralos/vasos/pias)'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'trimestral', ARRAY[
    'Inspecionar umidades/infiltrações (paredes/tetos/shafts)',
    'Revisar válvulas de descarga/torneiras/registros',
    'Testar sistema de água quente (se houver)',
    'Verificar sifões/caixas sifonadas'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'semestral', ARRAY[
    'Limpeza de caixas d’água/reservatórios (com certificado)',
    'Inspecionar tubulações aparentes e suportes',
    'Verificar hidrômetros/medidores',
    'Testar válvulas redutoras de pressão (VRP)'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'anual', ARRAY[
    'Inspeções internas por amostragem/câmera',
    'Revisão geral de bombeamento (limpeza/recalibração/peças)',
    'Atualizar esquemas/plantas hidráulicas',
    'Verificar sistemas de reuso/água pluvial (se houver)'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  ----------------------------------------------------------------------
  -- 15) SUBESTAÇÃO ELÉTRICA
  ----------------------------------------------------------------------
  select id into v_exists from core_planos_manutencao
  where empresa_id=p_empresa_id and nome='Subestação Elétrica' limit 1;

  if v_exists is null then
    insert into core_planos_manutencao (empresa_id, nome, descricao, tipo_plano, created_by, updated_by)
    values (p_empresa_id, 'Subestação Elétrica',
            'Plano preventivo para subestação: inspeções, medições, aterramento, relés, limpeza, ensaios e SPDA conforme normas.',
            'preventivo','system','system')
    returning id into v_plan_id;
  else v_plan_id := v_exists; end if;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'mensal', ARRAY[
    'Inspeção visual geral (infiltrações/sujeira/ferrugem)',
    'Verificar nível de óleo do transformador (quando aplicável)',
    'Checar ventilação/exaustão',
    'Verificar presença de animais/insetos'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'trimestral', ARRAY[
    'Medir/registrar temperatura e ruído do trafo',
    'Inspecionar cabos MT e conexões',
    'Testar aterramento',
    'Testar dispositivos de proteção (relés/disjuntores)'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'semestral', ARRAY[
    'Limpeza geral da subestação (desenergizada)',
    'Medir resistência de isolamento dos cabos/transformadores',
    'Medir resistência de aterramento (Ω)',
    'Ensaiar disjuntores BT/MT',
    'Verificar DPS'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'anual', ARRAY[
    'Ensaios dielétricos do transformador',
    'Limpar isoladores/para-raios/seccionadoras',
    'Verificar SPDA (malha de aterramento)',
    'Calibrar relés e coordenação',
    'Testes de intertravamento/manobras',
    'Emitir relatório técnico com ART'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  ----------------------------------------------------------------------
  -- 16) CÂMARA FRIA
  ----------------------------------------------------------------------
  select id into v_exists from core_planos_manutencao
  where empresa_id=p_empresa_id and nome='Câmara Fria' limit 1;

  if v_exists is null then
    insert into core_planos_manutencao (empresa_id, nome, descricao, tipo_plano, created_by, updated_by)
    values (p_empresa_id, 'Câmara Fria',
            'Plano preventivo para câmaras frias: temperaturas, degelo, vedação, ventiladores, pressões, isolamento e eficiência.',
            'preventivo','system','system')
    returning id into v_plan_id;
  else v_plan_id := v_exists; end if;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'diaria', ARRAY[
    'Registrar temperatura interna',
    'Observar acúmulo de gelo',
    'Verificar vedação de portas'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'semanal', ARRAY[
    'Verificar nível de óleo do compressor (se aplicável)',
    'Checar ventiladores do evaporador/condensador',
    'Limpar ralos/drenos de degelo'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'mensal', ARRAY[
    'Limpar filtros de ar (se houver)',
    'Verificar pressões de sucção/descarga',
    'Inspecionar isolamento térmico',
    'Verificar carga de gás e vazamentos',
    'Calibrar sensores/termostatos'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'trimestral', ARRAY[
    'Limpeza completa do evaporador/condensador',
    'Testar sistema de degelo',
    'Verificar borrachas de vedação',
    'Inspecionar estrutura (painéis/piso/teto)'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'semestral', ARRAY[
    'Apertar conexões elétricas',
    'Avaliar rendimento do compressor',
    'Avaliar eficiência energética (COP/consumo)'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'anual', ARRAY[
    'Reaperto geral mecânico/elétrico',
    'Teste de estanqueidade',
    'Revisão do painel de controle/automação',
    'Verificação estrutural geral',
    'Calibrar alarmes e sistemas de emergência'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  ----------------------------------------------------------------------
  -- 17) BALCÃO FRIO ALIMENTAR
  ----------------------------------------------------------------------
  select id into v_exists from core_planos_manutencao
  where empresa_id=p_empresa_id and nome='Balcão Frio Alimentar' limit 1;

  if v_exists is null then
    insert into core_planos_manutencao (empresa_id, nome, descricao, tipo_plano, created_by, updated_by)
    values (p_empresa_id, 'Balcão Frio Alimentar',
            'Plano preventivo para balcões frios: temperaturas, degelo, limpeza, pressões, termostatos, vedação e eficiência.',
            'preventivo','system','system')
    returning id into v_plan_id;
  else v_plan_id := v_exists; end if;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'diaria', ARRAY[
    'Registrar temperatura interna',
    'Observar formação de gelo',
    'Verificar fechamento de portas/tampas/cortinas de ar',
    'Limpeza de superfícies de exposição (produtos compatíveis)'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'semanal', ARRAY[
    'Limpar ralos de drenagem e bandeja de degelo',
    'Inspecionar ventiladores/difusores internos'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'mensal', ARRAY[
    'Limpar condensadores (ar)',
    'Verificar pressões e carga de gás',
    'Testar termostato/sensor de temperatura',
    'Inspecionar borrachas de vedação',
    'Checar ruído do compressor e vibração'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'trimestral', ARRAY[
    'Limpeza profunda do evaporador e ventiladores',
    'Testar eficiência do degelo',
    'Verificar cabos/conectores/terminais (NR-10)'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'anual', ARRAY[
    'Revisão geral do balcão e refrigeração',
    'Verificação estrutural/pintura/ferragens',
    'Análise de eficiência energética (kWh vs desempenho)'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  ----------------------------------------------------------------------
  -- 18) MOTORES ELÉTRICOS
  ----------------------------------------------------------------------
  select id into v_exists from core_planos_manutencao
  where empresa_id=p_empresa_id and nome='Motores Elétricos' limit 1;

  if v_exists is null then
    insert into core_planos_manutencao (empresa_id, nome, descricao, tipo_plano, created_by, updated_by)
    values (p_empresa_id, 'Motores Elétricos',
            'Plano preventivo para motores: inspeções visuais, temperatura, vibração, medições elétricas, lubrificação, limpeza e revisão anual.',
            'preventivo','system','system')
    returning id into v_plan_id;
  else v_plan_id := v_exists; end if;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'mensal', ARRAY[
    'Inspeção visual (sujeira/umidade/trincas/ruídos)',
    'Verificar temperatura de operação',
    'Checar ruídos/vibração',
    'Verificar tensão da correia (se houver)'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'trimestral', ARRAY[
    'Medir corrente de operação (comparar nominal)',
    'Medir resistência de isolamento (megômetro)',
    'Reapertar terminais e conexões',
    'Lubrificar rolamentos (se não selados)'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'semestral', ARRAY[
    'Inspecionar acoplamentos e bases',
    'Limpeza interna e externa (quando aplicável)',
    'Verificar pintura/carcaça/ventilação'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  insert into core_planos_checklist (plano_manutencao_id, recorrencia, titulo_checklist)
  values (v_plan_id,'anual', ARRAY[
    'Revisão geral em oficina (rolamentos/ensaios)',
    'Balanceamento do rotor (se vibração)',
    'Teste de desempenho elétrico completo'
  ])
  on conflict (plano_manutencao_id, recorrencia) do nothing;

  ----------------------------------------------------------------------
  -- FIM
  ----------------------------------------------------------------------
  return;
end
$$;
