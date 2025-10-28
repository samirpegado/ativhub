# Refatoração do Sistema de Navegação

## Visão Geral
A navegação do aplicativo foi refatorada para usar rotas individuais ao invés de um sistema baseado em `menuIndex`. Agora cada página tem seu próprio layout independente, tornando a navegação mais clara e manutenível.

## Mudanças Principais

### 1. Criação do `BaseLayout`
**Arquivo:** `lib/ui/components/base_layout.dart`

Widget reutilizável que encapsula a Sidebar e Topbar. Cada página agora usa este layout para manter consistência visual.

```dart
BaseLayout(
  child: // conteúdo da página
)
```

### 2. Sistema de Rotas
**Arquivos:** 
- `lib/routing/routes.dart` - Constantes de rotas
- `lib/routing/router.dart` - Configuração do GoRouter

**Rotas adicionadas:**
- `/dashboard` - Página inicial
- `/clientes` - Lista de clientes
- `/clientes/detalhes` - Detalhes do cliente
- `/ativos` - Gestão de ativos (placeholder)
- `/planos` - Gestão de planos (placeholder)
- `/ordens-servico` - Ordens de serviço (placeholder)
- `/checklists` - Checklists (placeholder)
- `/faturamento` - Faturamento (placeholder)
- `/fornecedores` - Fornecedores (placeholder)
- `/relatorios` - Relatórios (placeholder)

### 3. Menu Lateral
**Arquivo:** `lib/ui/components/menu_itens.dart`

Atualizado para usar `context.go()` ao invés de `appState.setMenuIndex()`:

**Antes:**
```dart
onTap: () {
  appState.setMenuIndex(item.index);
}
```

**Depois:**
```dart
onTap: () {
  context.go(item.route);
}
```

### 4. Páginas Atualizadas

#### `lib/ui/main/widgets/main_layout.dart`
Simplificado para ser apenas a página do Dashboard.

#### `lib/ui/core_clientes/widgets/core_clientes.dart`
Agora usa `BaseLayout` e é uma página independente.

#### `lib/ui/core_clientes/widgets/core_clientes_detalhes.dart`
Atualizado para:
- Usar `BaseLayout`
- Navegar com `Navigator.of(context).pop()` ao invés de `setMenuIndex`

#### `lib/ui/core_clientes/widgets/core_clientes_custom_table.dart`
Atualizado para usar `context.push('/clientes/detalhes')` ao invés de `setMenuIndex(9)`.

#### `lib/ui/core_clientes/components/deletar_cliente.dart`
Atualizado para usar `context.go('/clientes')` após deletar um cliente.

### 5. Páginas Placeholder
**Arquivo:** `lib/ui/pages/placeholder_page.dart`

Widget reutilizável para páginas ainda não implementadas, mostrando ícone, título e mensagem "Em desenvolvimento".

## Vantagens da Nova Arquitetura

1. **Independência de Estado**: Navegação não depende mais do `AppState.menuIndex`
2. **URLs Amigáveis**: Cada página tem sua própria URL
3. **Deep Linking**: Suporte nativo para navegação direta
4. **Manutenibilidade**: Código mais limpo e fácil de entender
5. **Escalabilidade**: Fácil adicionar novas páginas
6. **Histórico**: Suporte nativo ao botão "voltar" do navegador/dispositivo

## Migração de Código Existente

Para migrar páginas existentes:

1. Envolver o conteúdo com `BaseLayout`:
```dart
return BaseLayout(
  child: // seu conteúdo aqui
);
```

2. Adicionar rota em `lib/routing/router.dart`:
```dart
GoRoute(
  path: '/sua-rota',
  redirect: (context, state) async {
    if (!await isLoggedIn(authRepository)) return '/login';
    return null;
  },
  pageBuilder: (context, state) {
    return buildPageWithTransition(
      state: state,
      child: SuaPagina(),
    );
  },
),
```

3. Adicionar constante em `lib/routing/routes.dart`:
```dart
static const suaRota = '/sua-rota';
```

4. Usar navegação com GoRouter:
```dart
// Navegar para nova página
context.go('/sua-rota');
context.push('/sua-rota');

// Voltar
Navigator.of(context).pop();
context.pop();
```

## Notas

- O `menuIndex` ainda existe no `AppState` por questões de retrocompatibilidade, mas não é mais usado
- Todas as páginas placeholder podem ser substituídas por implementações reais no futuro
- A navegação continua funcionando com autenticação (redirect para `/login` se não autenticado)

