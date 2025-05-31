import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_one/config/app_router.dart';

import '../auth/bloc/auth.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          previous != current &&
          (current is Authenticated || current is Unauthenticated),
      listener: (context, state) {
        if (state is Authenticated) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(AppRouter.home, (router) => false);
        } else if (state is Unauthenticated) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(AppRouter.signin, (router) => false);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.amber,
        body: Center(child: Text('SPLASH SCREEN')),
      ),
    );
  }
}
