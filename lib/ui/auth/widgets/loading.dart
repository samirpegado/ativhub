import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:repsys/data/repositories/auth_repository.dart';
import 'package:repsys/ui/auth/view_models/loading_viewmodel.dart';
import 'package:repsys/ui/core/themes/dimens.dart';
import 'package:provider/provider.dart';

class Loading extends StatefulWidget {
  const Loading({super.key, required this.viewModel});
  final LoadingViewModel viewModel;

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    await widget.viewModel.initAndRoute(GoRouter.of(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: Dimens.of(context).edgeInsetsScreen,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('images/lottie_loading_dots.json', width: 120),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  await context.read<AuthRepository>().logout();
                  context.go('/login');
                },
                child: const Text('Carregando...'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
