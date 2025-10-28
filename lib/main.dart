import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:repsys/app_state/app_state.dart';
import 'package:repsys/data/repositories/auth_repository.dart';
import 'package:repsys/routing/router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:repsys/data/repositories/supabase_auth_repository.dart';
import 'package:repsys/ui/core/themes/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Carrega as variáveis de ambiente em assets/.env
  await dotenv.load();

  // Inicializa o Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  setUrlStrategy(PathUrlStrategy());

  runApp(
    // Cria o MultiProvider para fornecer os repositórios e o estado da aplicação
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthRepository>(
          create: (_) => SupabaseAuthRepository(),
        ),
        ChangeNotifierProvider<AppState>(
          create: (_) {
            final state = AppState();
            state
                .carregar(); // <-- carrega no AppState os dados persistidos no sharedpreferences
            return state;
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = Provider.of<AuthRepository>(context, listen: false);
    final appState = Provider.of<AppState>(context, listen: false);

    return MaterialApp.router(
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [
        Locale('pt', 'BR'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      title: 'AtivHub - Sistema de Gestão de Ativos e Manutenção',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.system,
      routerConfig: router(authRepository, appState),
    );
  }
}
