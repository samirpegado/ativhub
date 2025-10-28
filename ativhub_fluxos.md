# AtivHub — Domínio, Nomenclaturas e Fluxos (v2)

> Ajustes feitos conforme seu briefing: distinção **Empresa (cliente da AtivHub)** × **Core Clientes (cliente do seu cliente)**, inclusão de **Users**, **Adm Roles**, **Core Ativos** (com `tag` única por empresa e `status`), **Responsáveis do Core Cliente**, e alinhamento dos módulos de **Planos/Programações/OS/Faturamento** com as regras descritas. (Sem SQL agora; foco em visão do domínio + fluxos.)

---

## 1) Convenções gerais
- **Tabelas:** `empresa`, `users`, `adm_roles`, `core_*` (dados operacionais do cliente do seu cliente).
- **PK:** `id (uuid)`; **FK:** `<entidade>_id`.
- **Colunas padrão:** `empresa_id`, `created_at`, `updated_at`, `created_by`, `updated_by`, `deleted_at?` (quando fizer sentido), `metadata jsonb '{}'`.
- **Enums:** preferir `CHECK` para facilitar no Supabase Studio.
- **Datas:** `timestamptz` para eventos; `date` para datas sem hora.

---

## 2) Núcleo de Acesso e Tenancy

### 2.1 Empresa (cliente da AtivHub)
**Tabela:** `empresa`
- Identidade e dados institucionais (nome fantasia, razão social, CNPJ, contatos, endereço, `logo_url`).
- **Relacionamento:** 1..N com `users` (todos sempre vinculados a uma `empresa`).
- **Operação:** define parâmetros globais (ex.: `os_inicial`, `fim_teste`, `termos_servico`, `garantia_dias`).
- **Super user:** `super_user` (auth.users) — utilizado como dono/master inicial.

### 2.2 Users (autenticação e papéis)
**Tabela:** `users`
- Espelha `auth.users` por FK, sempre com `empresa_id`.
- Campos de perfil: `nome`, `email`, `cpf`, `celular`, `status`.
- **Papel:** `role → adm_roles.id`.

### 2.3 Adm Roles (catálogo de papéis)
**Tabela:** `adm_roles`
- Define os tipos de usuários por chave (`key`) e nome (`nome`).
- Exemplos de `key`: `master`, `admin`, `tecnico`, `padrao`, `visualizador`.

---

## 3) Domínio Operacional (do cliente do seu cliente)

### 3.1 Core Clientes (cliente do seu cliente)
**Tabela:** `core_clientes`
- Quem **recebe as manutenções** do seu cliente.
- Identificação, contato e **contrato**:
  - `tipo_contrato` (ex.: `recorrente`, `avulso`, `outro`).
  - `valor_contrato` e `data_assinatura` 
  - `dia_pagamento` (1..28) para recorrência mensal.
- Endereço e `observacoes`.
- **Regras:** Se `tipo_contrato = 'recorrente'` e `dia_pagamento` definido ⇒ geração mensal de fatura (ver §4.2).

#### 3.1.1 Responsáveis do Core Cliente
**Tabela:** `core_clientes_responsaveis`
- Contatos (nome/email/telefone/cargo) ligados ao `core_clientes`.

### 3.2 Core Ativos (do core_cliente)
**Tabela:** `core_ativos`
- Campos chave:
  - `cliente_id` (vincula ao **core_cliente**), `tag` **única por empresa** (`empresa_id + tag`), `status` (`ativo | inativo | em_manutencao | baixado`).
  - Atributos: `nome`, `categoria`, `local_instalacao`, `imagem_url`.
  - Datas: `data_instalacao`, `data_inicio_operacao`, `garantia_fim`.
  - Identificação técnica: `numero_serie`, `nota_fiscal`.
  - Vínculo opcional pré-definido: `plano_manutencao_id`.
- **Filtros comuns de UI:** nome/ID (tag), localidade (usar `local_instalacao` ou campo de localização), cliente, categoria, status.
- **Sugestões de anteriores:** `marca`, `potencia`, `local_instalacao` —
  pode-se manter como **texto livre** e usar `SELECT DISTINCT` por `empresa_id/cliente_id` para autocomplete; criar tabelas auxiliares depois, se necessário.

> **Observações adicionais de cadastro de ativos:**
> - `criticidade` (Alta/Média/Baixa) e `classificacao` podem ser campos de texto ou check; ficam em `core_ativos` ou em tabela auxiliar (`core_at_categorias`).
> - `fornecedor` (texto) e `data_aquisicao` (date) também cabem aqui se desejar (mantidos como opcionais).

### 3.3 Categorias de Ativo
**Tabela:** `core_at_categorias`
- Taxonomia leve por `empresa` para filtrar/classificar ativos.

### 3.4 Planos de Manutenção
**Tabelas:**
- **Catálogo do sistema (opcional):** `adm_planos_manutencao` — base para **seed** ao criar uma `empresa`.
- **Por empresa:** `core_planos_manutencao` —
  - `nome`, `descricao`, `frequencia` (`diario|semanal|mensal|trimestral|semestral|anual|horimetro|odometro`).
  - *(Opcional)* `tipo` (`Preventiva|Corretiva|Preditiva`).
  - `checklist` (JSONB **array** de itens modelo).
- **Checklist modelo (sugestão):**
```json
[
  { "id": "slug|uuid", "titulo": "Inspecionar correias", "tipo": "checkbox|numero|texto|foto", "unidade": "mm|°C", "obrigatorio": true }
]
```

### 3.5 Programações de Manutenção
**Tabela:** `core_programacoes_manutencao`
- Associação **Plano × Ativo** com `data_prevista`.
- `status`: `Agendado | Atrasado | Gerado | Cancelado`.
- Pode ser criada por ação manual ou por rotina conforme `frequencia` do plano.

### 3.6 Ordens de Serviço (OS)
**Tabela:** `core_ordens_servico`
- Pode nascer de uma `programacao` (FK opcional) ou ser **ad hoc**.
- Datas: `data_prevista_execucao`, `data_inicio_execucao`, `data_execucao`.
- Atribuição: `tecnico_id` (pode apontar para `users` com `role` técnico ou outra tabela de técnicos se preferir separar).
- `status`: `Pendente | Em execução | Concluída | Cancelada`.
- **Evidências**: `checklist_result` (JSONB) + `fotos_urls` (text[]).
- **Fechamento**: ao concluir ⇒ **travar edição** e **gerar PDF snapshot** (guardar URL em `metadata`). Ao abrir novamente, apenas **download do PDF**.

### 3.7 Faturamento (Faturas)
**Tabela sugerida:** `core_faturas`
- `empresa_id`, `cliente_id` (**core_cliente**), valores e datas: `data_vencimento`, `data_pagamento`, `valor`, `valor_pago`.
- `status_pagamento`: `Pendente | Pago | Atrasado | Cancelado`.
- `tipo_pagamento`: `CartaoCredito | CartaoDebito | Pix | Boleto | Especie | Transferencia`.
- `observacoes`, `metadata`.
- **Regra automática (recorrente)**: se `core_clientes.tipo_contrato = 'recorrente'` e `dia_pagamento` definido ⇒ criar fatura mensal (ver §4.2).

---

## 4) Regras e Automações

### 4.1 `updated_at`
- Trigger padrão para `users`, `core_clientes`, `core_ativos`, `core_planos_manutencao`, `core_programacoes_manutencao`, `core_ordens_servico`, `core_faturas`.

### 4.2 Fatura recorrente
- **Idempotência mensal:** verifique se já existe fatura `YYYY-MM` para o `cliente_id` antes de criar.
- **Agendamento:** `pg_cron` diário (ex.: 01:00) roda uma função `gerar_faturas_recorrentes(empresa_id?)`.
- `data_vencimento = <YYYY-MM-dia_pagamento>` (ajustar meses com 28/29/30/31). `valor = valor_contrato`.

### 4.3 Programações recorrentes
- Rotina (diária/semanal) que projeta próximas `data_prevista` conforme `frequencia` do plano e existência de OS abertas.

### 4.4 Fechamento de OS
- Função transacional: valida checklist, seta `status='Concluída'`, calcula `tempo_total_min`, gera **PDF** (Edge Function) e persiste URL, remove permissões de edição/upload.

---

## 5) CRUDs e Telas (escopo mínimo)

- **Empresa**: perfil, logo, termos, garantia padrão.
- **Users**: gestão de usuários por empresa, papéis (`adm_roles`).
- **Core Clientes**: cadastro + responsáveis; contrato (tipo, valor, dia_pagamento, data_assinatura), endereço, observações.
- **Ativos**: cadastro por core_cliente; filtros (nome/tag, local, cliente, categoria, status); sugestões (`marca`, `potencia`, `local_instalacao`).
- **Planos**: catálogo por empresa (e opcional seed de `adm_planos_manutencao`); editor do checklist-modelo.
- **Programações**: lista/calendário; gerar por plano×ativo; reagendar/cancelar.
- **OS**: criar da programação; executar (checklist_result, fotos); concluir (PDF e bloqueio).
- **Faturamento**: listar por cliente/mês/status; registrar pagamento; exportações.

---

## 6) Métricas e Relatórios Iniciais
- **Manutenção**: OS por status, tempo médio até conclusão, atraso médio, custo por ativo/cliente.
- **Financeiro**: receitas recorrentes vs avulsas, inadimplência por mês, ticket médio, margem (valor recebido − custos OS).

---

## 7) Diagrama de Fluxo (Mermaid)
```mermaid
flowchart TB
  subgraph Tenancy & Acesso
    EMP[Empresa]
(cliente da AtivHub)
    U[Users]
(vinculados à Empresa)
    R[adm_roles]
    EMP --> U
    U --> R
  end

  subgraph Operacional (Cliente do seu Cliente)
    CC[Core Clientes]
(cliente do cliente)
    RESP[Responsáveis do Core Cliente]
    AT[Core Ativos]
    CAT[Core At Categorias]
    PL[Core Planos de Manutenção]
    PRG[Programações de Manutenção]
    OS[Ordens de Serviço]
    FAT[Faturamento (Faturas)]

    CC --> RESP
    CC --> AT
    AT --> PL
    PL --> PRG
    PRG --> OS
    CC --> FAT
    OS -->|Concluída| PDF[(PDF Snapshot)]
  end

  EMP --> CC
  EMP --> PL
  EMP --> CAT
  OS -. custos .-> FAT
```

---

## 8) Próximos passos
1. Validar se mantemos `tipo` em `core_planos_manutencao` (Preventiva/Corretiva/Preditiva). Se sim, incluo nos contratos.
2. Definir **contratos de API/CRUD** (payloads) por módulo.
3. Desenhar **funções**: `gerar_faturas_recorrentes`, `projetar_programacoes`, `fechar_os_com_pdf`.
4. Especificar **RLS**: isolamento por `empresa_id` e papéis (`adm_roles`).
5. (Opcional) Criar `adm_planos_manutencao` + rotina de **seed** ao criar `empresa`.

