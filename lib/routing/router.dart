import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:repsys/app_state/app_state.dart';
import 'package:repsys/data/repositories/auth_repository.dart';
import 'package:repsys/data/repositories/endereco_repository.dart';
import 'package:repsys/data/services/auth_service.dart';
import 'package:repsys/ui/auth/view_models/change_password_viewmodel.dart';
import 'package:repsys/ui/auth/view_models/loading_viewmodel.dart';
import 'package:repsys/ui/auth/view_models/login_viewmodel.dart';
import 'package:repsys/ui/auth/view_models/new_password_viewmodel.dart';
import 'package:repsys/ui/auth/view_models/recovery_viewmodel.dart';
import 'package:repsys/ui/auth/view_models/signup_viewmodel.dart';
import 'package:repsys/ui/auth/view_models/verify_viewmodel.dart';
import 'package:repsys/ui/auth/widgets/change_password.dart';
import 'package:repsys/ui/auth/widgets/loading.dart';
import 'package:repsys/ui/auth/widgets/login.dart';
import 'package:repsys/ui/auth/widgets/new_password.dart';
import 'package:repsys/ui/auth/widgets/policy.dart';
import 'package:repsys/ui/auth/widgets/recovery.dart';
import 'package:repsys/ui/auth/widgets/signup.dart';
import 'package:repsys/ui/auth/widgets/verify.dart';
import 'package:repsys/ui/core_clientes/widgets/core_clientes.dart';
import 'package:repsys/ui/core_clientes/widgets/core_clientes_detalhes.dart';
import 'package:repsys/ui/main/view_models/main_layout_viewmodel.dart';
import 'package:repsys/ui/main/widgets/main_layout.dart';
import 'package:repsys/ui/pages/placeholder_page.dart';
import 'package:provider/provider.dart';

GoRouter router(AuthRepository authRepository, AppState appState) => GoRouter(
        initialLocation: '/loading',
        refreshListenable: authRepository,
        routes: [
          GoRoute(
            path: '/login',
            pageBuilder: (context, state) {
              final viewModel = LoginViewModel(authRepository: context.read());
              return buildPageWithTransition(
                state: state,
                child: Login(viewModel: viewModel),
              );
            },
          ),
          GoRoute(
            path: '/',
            redirect: (context, state) async {
              if (!await isLoggedIn(authRepository)) return '/login';
              return '/dashboard';
            },
          ),
          GoRoute(
            path: '/dashboard',
            redirect: (context, state) async {
              if (!await isLoggedIn(authRepository)) return '/login';
              return null;
            },
            pageBuilder: (context, state) {
              final viewModel = MainLayoutViewmodel();
              return buildPageWithTransition(
                state: state,
                child: MainLayout(viewModel: viewModel),
              );
            },
          ),
          GoRoute(
            path: '/clientes',
            redirect: (context, state) async {
              if (!await isLoggedIn(authRepository)) return '/login';
              return null;
            },
            pageBuilder: (context, state) {
              return buildPageWithTransition(
                state: state,
                child: CoreClientes(),
              );
            },
          ),
          GoRoute(
            path: '/clientes/detalhes',
            redirect: (context, state) async {
              if (!await isLoggedIn(authRepository)) return '/login';
              return null;
            },
            pageBuilder: (context, state) {
              return buildPageWithTransition(
                state: state,
                child: CoreClientesDetalhes(),
              );
            },
          ),
          GoRoute(
            path: '/ativos',
            redirect: (context, state) async {
              if (!await isLoggedIn(authRepository)) return '/login';
              return null;
            },
            pageBuilder: (context, state) {
              return buildPageWithTransition(
                state: state,
                child: PlaceholderPage(
                  title: 'Ativos',
                  icon: Icons.precision_manufacturing,
                ),
              );
            },
          ),
          GoRoute(
            path: '/planos',
            redirect: (context, state) async {
              if (!await isLoggedIn(authRepository)) return '/login';
              return null;
            },
            pageBuilder: (context, state) {
              return buildPageWithTransition(
                state: state,
                child: PlaceholderPage(
                  title: 'Planos',
                  icon: Icons.calendar_month,
                ),
              );
            },
          ),
          GoRoute(
            path: '/ordens-servico',
            redirect: (context, state) async {
              if (!await isLoggedIn(authRepository)) return '/login';
              return null;
            },
            pageBuilder: (context, state) {
              return buildPageWithTransition(
                state: state,
                child: PlaceholderPage(
                  title: 'Ordens de Serviço',
                  icon: Icons.assignment_turned_in,
                ),
              );
            },
          ),
          GoRoute(
            path: '/checklists',
            redirect: (context, state) async {
              if (!await isLoggedIn(authRepository)) return '/login';
              return null;
            },
            pageBuilder: (context, state) {
              return buildPageWithTransition(
                state: state,
                child: PlaceholderPage(
                  title: 'Checklists',
                  icon: Icons.checklist,
                ),
              );
            },
          ),
          GoRoute(
            path: '/faturamento',
            redirect: (context, state) async {
              if (!await isLoggedIn(authRepository)) return '/login';
              return null;
            },
            pageBuilder: (context, state) {
              return buildPageWithTransition(
                state: state,
                child: PlaceholderPage(
                  title: 'Faturamento',
                  icon: Icons.request_quote,
                ),
              );
            },
          ),
          GoRoute(
            path: '/fornecedores',
            redirect: (context, state) async {
              if (!await isLoggedIn(authRepository)) return '/login';
              return null;
            },
            pageBuilder: (context, state) {
              return buildPageWithTransition(
                state: state,
                child: PlaceholderPage(
                  title: 'Fornecedores',
                  icon: Icons.local_shipping,
                ),
              );
            },
          ),
          GoRoute(
            path: '/relatorios',
            redirect: (context, state) async {
              if (!await isLoggedIn(authRepository)) return '/login';
              return null;
            },
            pageBuilder: (context, state) {
              return buildPageWithTransition(
                state: state,
                child: PlaceholderPage(
                  title: 'Relatórios',
                  icon: Icons.bar_chart,
                ),
              );
            },
          ),
          GoRoute(
            path: '/loading',
            redirect: (context, state) async {
              if (!await isLoggedIn(authRepository)) return '/login';
              return null;
            },
            pageBuilder: (context, state) {
              final viewModel = LoadingViewModel(appState: appState);
              return buildPageWithTransition(
                state: state,
                child: Loading(viewModel: viewModel),
              );
            },
          ),
          GoRoute(
            path: '/signup',
            pageBuilder: (context, state) {
              final authService = AuthService();
              final enderecoRepository = EnderecoRepository();
              final viewModel = SignUpViewModel(
                authService: authService,
                appState: appState,
                enderecoRepository: enderecoRepository,
              );
              return buildPageWithTransition(
                state: state,
                child: SignUp(viewModel: viewModel),
              );
            },
          ),
          GoRoute(
            path: '/change-password',
            pageBuilder: (context, state) {
              final authService = AuthService();
              final viewModel =
                  ChangePasswordViewModel(authService: authService);
              return buildPageWithTransition(
                state: state,
                child: ChangePassword(viewModel: viewModel),
              );
            },
          ),
          GoRoute(
            path: '/verify',
            redirect: (context, state) async {
              if (!await isLoggedIn(authRepository)) return '/login';
              return null;
            },
            pageBuilder: (context, state) {
              final authService = AuthService();
              final viewModel =
                  VerifyViewModel(authService: authService, appState: appState);
              return buildPageWithTransition(
                state: state,
                child: Verify(viewModel: viewModel),
              );
            },
          ),
          GoRoute(
            path: '/policy',
            pageBuilder: (context, state) {
              return buildPageWithTransition(
                state: state,
                child: Policy(),
              );
            },
          ),
          GoRoute(
            path: '/recovery',
            pageBuilder: (context, state) {
              final authService = AuthService();
              final viewModel = RecoveryViewModel(authService: authService);
              return buildPageWithTransition(
                state: state,
                child: Recovery(
                  viewModel: viewModel,
                ),
              );
            },
          ),
          GoRoute(
            path: '/new-password',
            pageBuilder: (context, state) {
              final authService = AuthService();
              final email = state.uri.queryParameters['email'];
              final viewModel = NewPasswordViewModel(authService: authService);
              return buildPageWithTransition(
                state: state,
                child: NewPassword(
                  viewModel: viewModel,
                  email: email,
                ),
              );
            },
          ),
        ]);

CustomTransitionPage<T> buildPageWithTransition<T>({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

Future<bool> isLoggedIn(AuthRepository authRepository) async {
  return await authRepository.isAuthenticated;
}
