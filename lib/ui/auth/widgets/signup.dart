import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repsys/app_state/app_state.dart';
import 'package:repsys/ui/auth/components/active_logo.dart';
import 'package:repsys/ui/auth/components/progress_bar_signup.dart';
import 'package:repsys/ui/auth/components/signup_step1.dart';
import 'package:repsys/ui/auth/components/signup_step2.dart';
import 'package:repsys/ui/auth/components/signup_step3.dart';
import 'package:repsys/ui/auth/components/signup_step4.dart';
import 'package:repsys/ui/auth/view_models/signup_viewmodel.dart';
import 'package:repsys/ui/core/themes/dimens.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key, required this.viewModel});
  final SignUpViewModel viewModel;

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late final PageController _pageController;
  late final List<Widget> _steps;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _currentIndex = context.read<AppState>().pageViewIndex;
    _pageController = PageController(initialPage: _currentIndex);

    _steps = [
      SignupStep1(viewModel: widget.viewModel),
      SignupStep2(viewModel: widget.viewModel),
      SignupStep3(viewModel: widget.viewModel),
      SignupStep4(viewModel: widget.viewModel),
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newIndex = context.watch<AppState>().pageViewIndex;
    if (newIndex != _currentIndex) {
      _currentIndex = newIndex;
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return SafeArea(
      top: false,
      child: Scaffold(
        body: Padding(
          padding: Dimens.of(context).edgeInsetsScreen,
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  children: [
                    ActiveLogo(),
                    ProgressBarSignup(currentStep: appState.pageViewIndex),
                    const SizedBox(height: 32),
                    Container(
                      constraints: const BoxConstraints(maxHeight: 800),
                      child: PageView.builder(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _steps.length,
                        itemBuilder: (_, index) => _steps[index],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
